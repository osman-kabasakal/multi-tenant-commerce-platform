#!/usr/bin/env python3
# SPDX-License-Identifier: GPL-3.0-only
"""Loopback CONNECT proxy for one identity host through an existing SSH tunnel."""

import argparse
import re
import select
import socket
import socketserver

MAX_HEADER_BYTES = 8192


def identity_host(value):
    try:
        host = value.encode('idna').decode('ascii').lower()
    except UnicodeError as exc:
        raise argparse.ArgumentTypeError('Use a DNS hostname, without a URL or port.') from exc
    labels = host.split('.')
    if len(host) > 253 or len(labels) < 2 or any(
        not re.fullmatch(r'[a-z0-9](?:[a-z0-9-]{0,61}[a-z0-9])?', label)
        for label in labels
    ):
        raise argparse.ArgumentTypeError('Use a DNS hostname, without a URL or port.')
    return host


def port_number(value):
    try:
        number = int(value)
    except ValueError as exc:
        raise argparse.ArgumentTypeError('Use a port between 1 and 65535.') from exc
    if not 1 <= number <= 65535:
        raise argparse.ArgumentTypeError('Use a port between 1 and 65535.')
    return number


class ConnectHandler(socketserver.BaseRequestHandler):
    def respond(self, status):
        self.request.sendall(
            f'HTTP/1.1 {status}\r\nContent-Length: 0\r\nConnection: close\r\n\r\n'.encode('ascii')
        )

    def handle(self):
        self.request.settimeout(10)
        try:
            data = b''
            while b'\r\n\r\n' not in data:
                chunk = self.request.recv(1024)
                if not chunk:
                    return
                data += chunk
                if len(data.split(b'\r\n\r\n', 1)[0]) > MAX_HEADER_BYTES:
                    self.respond('431 Request Header Fields Too Large')
                    return
            header, tail = data.split(b'\r\n\r\n', 1)
            parts = header.split(b'\r\n', 1)[0].split()
            if len(parts) != 3 or parts[2] not in (b'HTTP/1.0', b'HTTP/1.1'):
                self.respond('400 Bad Request')
                return
            if parts[0] != b'CONNECT':
                self.respond('405 Method Not Allowed')
                return
            if parts[1].lower() != self.server.allowed_authority:
                self.respond('403 Forbidden')
                return
            try:
                upstream = socket.create_connection(('127.0.0.1', self.server.tunnel_port), timeout=10)
            except OSError:
                self.respond('502 Bad Gateway')
                return
            with upstream:
                self.request.sendall(b'HTTP/1.1 200 Connection Established\r\n\r\n')
                if tail:
                    upstream.sendall(tail)
                while True:
                    readable, _, _ = select.select([self.request, upstream], [], [], 90)
                    if not readable:
                        return
                    for source in readable:
                        chunk = source.recv(65536)
                        if not chunk:
                            return
                        (upstream if source is self.request else self.request).sendall(chunk)
        except OSError:
            # Closed clients/tunnels need no request, cookie or credential logging.
            return


class ProxyServer(socketserver.ThreadingTCPServer):
    allow_reuse_address = True
    daemon_threads = True

    def __init__(self, listen_port, host, tunnel_port):
        self.allowed_authority = (identity_host(host) + ':443').encode('ascii')
        self.tunnel_port = tunnel_port
        super().__init__(('127.0.0.1', listen_port), ConnectHandler)


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--host', required=True, type=identity_host, help='Identity DNS host, without https:// or a port.')
    parser.add_argument('--listen-port', default=18882, type=port_number)
    parser.add_argument('--tunnel-port', default=18444, type=port_number)
    args = parser.parse_args()
    try:
        with ProxyServer(args.listen_port, args.host, args.tunnel_port) as server:
            print(f'CONNECT proxy: 127.0.0.1:{args.listen_port}; only {args.host}:443; tunnel 127.0.0.1:{args.tunnel_port}. Ctrl+C stops it.', flush=True)
            try:
                server.serve_forever()
            except KeyboardInterrupt:
                pass
    except OSError as exc:
        parser.exit(1, f'Cannot start the loopback proxy: {exc}\n')


if __name__ == '__main__':
    main()
