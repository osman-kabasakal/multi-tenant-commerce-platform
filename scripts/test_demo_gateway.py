"""Exercise the actual demo gateway over owned loopback sockets; no Keycloak or cloud credentials."""
import base64
import hashlib
import http.client
from http.server import BaseHTTPRequestHandler, ThreadingHTTPServer
import secrets
import socket
import threading
import unittest
from unittest.mock import patch
import gateway

class Upstream(BaseHTTPRequestHandler):
    protocol_version='HTTP/1.1'
    received=[]
    def log_message(self,*args):pass
    def do_GET(self):
        type(self).received.append(dict(self.headers))
        if self.headers.get('Upgrade','').lower()!='websocket':
            body=b'owned-http-response'
            self.send_response(200);self.send_header('Content-Length',str(len(body)));self.end_headers();self.wfile.write(body);return
        if self.headers.get('Authorization')!='Bearer local-fixture':
            self.send_response(401);self.send_header('Content-Length','0');self.end_headers();return
        accept=base64.b64encode(hashlib.sha1((self.headers['Sec-WebSocket-Key']+'258EAFA5-E914-47DA-95CA-C5AB0DC85B11').encode()).digest()).decode()
        # Deliberately send the first frame in the same write as HTTP headers.
        headers=('HTTP/1.1 101 Switching Protocols\r\nConnection: Upgrade\r\nUpgrade: websocket\r\nSec-WebSocket-Accept: '+accept+'\r\nSec-WebSocket-Protocol: stale-cache-websocket-protocol\r\n\r\n').encode()
        self.connection.sendall(headers+b'\x81\x05hello')
        self.close_connection=True
        while data:=self.rfile.read1(65536):
            self.connection.sendall(data)

class GatewayTransportTests(unittest.TestCase):
    def setUp(self):
        Upstream.received=[]
        self.upstream=ThreadingHTTPServer(('127.0.0.1',0),Upstream)
        self.gateway=ThreadingHTTPServer(('127.0.0.1',0),gateway.Handler)
        self.upstream.daemon_threads=self.gateway.daemon_threads=True
        self.patches=[patch.object(gateway,'UPSTREAM_PORT',self.upstream.server_port),patch.object(gateway,'token',return_value='server-only-fixture')]
        for item in self.patches:item.start()
        for server in (self.upstream,self.gateway):threading.Thread(target=server.serve_forever,daemon=True).start()
    def tearDown(self):
        for server in (self.gateway,self.upstream):server.shutdown();server.server_close()
        for item in self.patches:item.stop()
    def request(self,path='/api/ws/fcm',host='demo-a.localhost',authorization='Bearer local-fixture'):
        client=socket.create_connection(('127.0.0.1',self.gateway.server_port),timeout=3)
        nonce=base64.b64encode(secrets.token_bytes(16)).decode()
        headers=f'GET {path} HTTP/1.1\r\nHost: {host}\r\nConnection: Upgrade\r\nUpgrade: websocket\r\nSec-WebSocket-Key: {nonce}\r\nSec-WebSocket-Version: 13\r\nAuthorization: {authorization}\r\nx-store-token: must-not-forward\r\nx-forwarded-host: foreign.invalid\r\n\r\n'
        client.sendall(headers.encode());reader=client.makefile('rb');status=reader.readline()
        result={}
        while line:=reader.readline():
            if line==b'\r\n':break
            key,value=line.decode().split(':',1);result[key.lower()]=value.strip()
        return client,reader,status,result
    def test_upgrade_keeps_the_first_frame_and_bidirectional_bytes_without_exposing_store_credentials(self):
        client,reader,status,headers=self.request()
        try:
            self.assertIn(b'101',status);self.assertEqual(headers['sec-websocket-protocol'],'stale-cache-websocket-protocol')
            self.assertEqual(reader.read(7),b'\x81\x05hello')
            data=b'\x82'+bytes([126])+b'\x04\x00'+b'x'*1024
            client.sendall(data);self.assertEqual(reader.read(len(data)),data)
            received={key.lower():value for key,value in Upstream.received[-1].items()}
            self.assertEqual(received['x-store-token'],'server-only-fixture')
            self.assertEqual(received['host'],'demo-a.localhost:18090')
            self.assertNotIn('x-forwarded-host',received);self.assertNotIn('x-store-token',headers)
        finally:client.shutdown(socket.SHUT_RDWR);reader.close();client.close()
    def test_an_unknown_tenant_is_rejected_before_upstream_authentication(self):
        client,reader,status,_=self.request(host='foreign.invalid')
        try:self.assertIn(b'400',status);self.assertEqual(Upstream.received,[])
        finally:reader.close();client.close()
    def test_upstream_customer_authentication_failure_is_preserved(self):
        client,reader,status,_=self.request(authorization='Bearer invalid-fixture')
        try:self.assertIn(b'401',status)
        finally:reader.close();client.close()
    def test_other_upgrade_paths_are_not_tunneled(self):
        client,reader,status,_=self.request(path='/admin')
        try:self.assertIn(b'400',status);self.assertEqual(Upstream.received,[])
        finally:reader.close();client.close()
    def test_ordinary_http_requests_still_use_server_owned_tenant_routing(self):
        client=http.client.HTTPConnection('127.0.0.1',self.gateway.server_port,timeout=3)
        try:
            client.request('GET','/catalog',headers={'Host':'demo-b.localhost'})
            response=client.getresponse();self.assertEqual(response.status,200);self.assertEqual(response.read(),b'owned-http-response')
            self.assertEqual(Upstream.received[-1]['Host'],'demo-b.localhost:18090')
        finally:client.close()

if __name__=='__main__':unittest.main()
