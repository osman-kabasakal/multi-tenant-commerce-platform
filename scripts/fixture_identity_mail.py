#!/usr/bin/env python3
"""Receive only a synthetic Keycloak verification email; never relay or retain raw mail."""
import email
from email import policy
import html
import json
from pathlib import Path
import re
import socketserver
import threading
import urllib.parse

import production_config


class IdentityMail(socketserver.ThreadingTCPServer):
    daemon_threads = True
    allow_reuse_address = False

    def __init__(self, address, destination: Path, recipient: str):
        self.destination = destination
        self.recipient = recipient
        self.delivery_lock = threading.Lock()
        super().__init__(address, MailSession)

    def accept_message(self, payload):
        message = email.message_from_bytes(payload, policy=policy.default)
        if email.utils.parseaddr(message.get('To', ''))[1] != self.recipient:
            raise ValueError('Unexpected synthetic recipient.')
        bodies = [part.get_content() for part in message.walk() if part.get_content_type() in ('text/plain', 'text/html') and not part.is_multipart()]
        links = set()
        for body in bodies:
            for match in re.findall(r'''https://identity\.example\.test:19443/realms/commerce/login-actions/action-token\?[^\s<>"']+''', body):
                link = html.unescape(match)
                parsed = urllib.parse.urlsplit(link)
                if not parsed.username and not parsed.password and 'key' in urllib.parse.parse_qs(parsed.query):
                    links.add(link)
        if len(links) != 1:
            raise ValueError('Expected one owned identity verification link.')
        with self.delivery_lock:
            production_config.write_json(self.destination, {'verificationUrl': links.pop(), 'recipient': self.recipient})


class MailSession(socketserver.StreamRequestHandler):
    def handle(self):
        self.connection.settimeout(20)
        sender = False; recipient = False
        self.wfile.write(b'220 identity-fixture ESMTP\r\n')
        while True:
            line = self.rfile.readline(4097)
            if not line or len(line) > 4096: return
            command, _, argument = line.decode('ascii', errors='replace').rstrip('\r\n').partition(' ')
            command = command.upper()
            if command in ('EHLO', 'HELO'):
                sender = recipient = False
                self.wfile.write(b'250-identity-fixture\r\n250 SIZE 1048576\r\n')
            elif command == 'MAIL':
                sender = argument.upper().startswith('FROM:<NO-REPLY@EXAMPLE.TEST>'); recipient = False
                self.wfile.write(b'250 Sender accepted\r\n' if sender else b'550 Synthetic sender only\r\n')
            elif command == 'RCPT':
                recipient = sender and argument.lower() == 'to:<' + self.server.recipient + '>'
                self.wfile.write(b'250 Recipient accepted\r\n' if recipient else b'550 Synthetic recipient only\r\n')
            elif command == 'DATA' and sender and recipient:
                self.wfile.write(b'354 End with dot\r\n'); data = bytearray()
                while True:
                    line = self.rfile.readline(65537)
                    if line == b'.\r\n': break
                    if not line or len(line) > 65536 or len(data) + len(line) > 1048576:
                        self.wfile.write(b'552 Message too large\r\n'); return
                    data.extend(line[1:] if line.startswith(b'..') else line)
                try:
                    self.server.accept_message(bytes(data))
                    self.wfile.write(b'250 Verification received\r\n')
                except (ValueError, TypeError): self.wfile.write(b'550 Unexpected verification message\r\n')
                sender = recipient = False
            elif command == 'RSET':
                sender = recipient = False; self.wfile.write(b'250 Reset\r\n')
            elif command == 'NOOP': self.wfile.write(b'250 OK\r\n')
            elif command == 'QUIT': self.wfile.write(b'221 Bye\r\n'); return
            else: self.wfile.write(b'502 Not supported\r\n')
