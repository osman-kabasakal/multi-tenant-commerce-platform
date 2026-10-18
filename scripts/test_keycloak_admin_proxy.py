#!/usr/bin/env python3
# SPDX-License-Identifier: GPL-3.0-only
"""Socket-level checks for the operator proxy's routing boundary."""

import argparse
import socket
import socketserver
import threading
import unittest
from unittest.mock import patch
from contextlib import contextmanager

from keycloak_admin_proxy import ProxyServer, identity_host, port_number


@contextmanager
def running(server):
    thread = threading.Thread(target=server.serve_forever, kwargs={'poll_interval': 0.02}, daemon=True)
    thread.start()
    try:
        yield server.server_address[1]
    finally:
        server.shutdown()
        server.server_close()
        thread.join(timeout=2)


class Echo(socketserver.BaseRequestHandler):
    def handle(self):
        self.server.connections.append(True)
        self.request.settimeout(2)
        try:
            while chunk := self.request.recv(4096):
                self.request.sendall(chunk)
        except OSError:
            pass


class ProxyTests(unittest.TestCase):
    def test_only_requested_authority_reaches_tunnel_and_preserves_bytes(self):
        upstream = socketserver.ThreadingTCPServer(('127.0.0.1', 0), Echo)
        upstream.connections = []
        upstream.daemon_threads = True
        with running(upstream) as tunnel_port, running(ProxyServer(0, 'identity.example.com', tunnel_port)) as port:
            with socket.create_connection(('127.0.0.1', port), timeout=2) as client:
                client.sendall(b'CONNECT IDENTITY.EXAMPLE.COM:443 HTTP/1.1\r\nHost: identity.example.com:443\r\n\r\n\x16\x03\x01test')
                response = b''
                while b'\r\n\r\n' not in response:
                    response += client.recv(4096)
                header, payload = response.split(b'\r\n\r\n', 1)
                self.assertIn(b'200 Connection Established', header)
                while len(payload) < 7:
                    payload += client.recv(4096)
                self.assertEqual(payload, b'\x16\x03\x01test')
                client.sendall(b'\x00\xffsecond')
                self.assertEqual(client.recv(4096), b'\x00\xffsecond')
            self.assertEqual(len(upstream.connections), 1)

    def test_rejects_other_targets_and_malformed_requests_before_connecting(self):
        upstream = socketserver.ThreadingTCPServer(('127.0.0.1', 0), Echo)
        upstream.connections = []
        upstream.daemon_threads = True
        cases = [
            (b'CONNECT other.example.com:443 HTTP/1.1\r\n\r\n', b'403'),
            (b'CONNECT identity.example.com:80 HTTP/1.1\r\n\r\n', b'403'),
            (b'CONNECT identity.example.com:443.evil HTTP/1.1\r\n\r\n', b'403'),
            (b'GET https://identity.example.com/ HTTP/1.1\r\n\r\n', b'405'),
            (b'CONNECT identity.example.com:443 HTTP/9\r\n\r\n', b'400'),
            (b'broken\r\n\r\n', b'400'),
            (b'CONNECT identity.example.com:443 HTTP/1.1\r\nX: ' + b'x' * 8200 + b'\r\n\r\n', b'431'),
        ]
        with running(upstream) as tunnel_port, running(ProxyServer(0, 'identity.example.com', tunnel_port)) as port:
            for request, status in cases:
                with self.subTest(status=status, request=request[:90]):
                    with socket.create_connection(('127.0.0.1', port), timeout=2) as client:
                        client.sendall(request)
                        self.assertIn(b'HTTP/1.1 ' + status, client.recv(4096))
            self.assertEqual(upstream.connections, [])

    def test_missing_tunnel_returns_bad_gateway(self):
        with running(ProxyServer(0, 'identity.example.com', 18444)) as port:
            with socket.create_connection(('127.0.0.1', port), timeout=2) as client:
                with patch('keycloak_admin_proxy.socket.create_connection', side_effect=ConnectionRefusedError) as connect:
                    client.sendall(b'CONNECT identity.example.com:443 HTTP/1.1\r\n\r\n')
                    self.assertIn(b'502 Bad Gateway', client.recv(4096))
                    connect.assert_called_once_with(('127.0.0.1', 18444), timeout=10)

    def test_arguments_reject_urls_and_invalid_ports(self):
        self.assertEqual(identity_host('IDENTITY.example.com'), 'identity.example.com')
        for host in ['https://identity.example.com', 'identity.example.com:443', 'a..com', 'bad/name.com']:
            with self.assertRaises(argparse.ArgumentTypeError):
                identity_host(host)
        for port in ['0', '65536', 'invalid']:
            with self.assertRaises(argparse.ArgumentTypeError):
                port_number(port)


if __name__ == '__main__':
    unittest.main()
