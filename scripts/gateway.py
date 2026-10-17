#!/usr/bin/env python3
"""Loopback-only demo gateway. Keycloak service credentials never enter browser/mobile bundles."""
from http.server import BaseHTTPRequestHandler, ThreadingHTTPServer
import http.client
import socket
import json
import re
import threading
import time
import urllib.parse
import urllib.request
from pathlib import Path
ROOT=Path(__file__).resolve().parents[1]
LOCAL=ROOT/'.local'
UPSTREAM_PORT=18082
TOKEN_URL='http://localhost:18080/realms/commerce-demo/protocol/openid-connect/token'
TENANTS={'demo-a.localhost':'demo-a','demo-b.localhost':'demo-b','localhost':'demo-a','127.0.0.1':'demo-a'}
HOP={'connection','keep-alive','proxy-authenticate','proxy-authorization','te','trailer','transfer-encoding','upgrade'}
_cache={};_lock=threading.Lock()
def token(slug):
    with _lock:
        cached=_cache.get(slug)
        if cached and cached[0]>time.monotonic():return cached[1]
        payload=urllib.parse.urlencode({'grant_type':'client_credentials','client_id':slug,
            'client_secret':(LOCAL/'secrets'/('ClientSecret-'+slug)).read_text()}).encode()
        with urllib.request.urlopen(TOKEN_URL,data=payload,timeout=10) as response:
            data=json.load(response)
        _cache[slug]=(time.monotonic()+max(1,int(data['expires_in'])-30),data['access_token'])
        return data['access_token']
class Handler(BaseHTTPRequestHandler):
    protocol_version='HTTP/1.1'
    def log_message(self,fmt,*args):pass # URLs may contain authentication data.
    def proxy(self):
        host=self.headers.get('Host','').split(':')[0].lower()
        slug=TENANTS.get(host)
        if slug is None and host.endswith('.localhost'):
            candidate=host.removesuffix('.localhost')
            if re.fullmatch(r'[a-z][a-z0-9-]{1,38}[a-z0-9]',candidate) and (LOCAL/'routes'/(candidate+'.json')).is_file():
                route=json.loads((LOCAL/'routes'/(candidate+'.json')).read_text())
                if route.get('slug')==candidate:slug=candidate
        if slug is None or not self.path.startswith('/') or self.path.startswith('//'):
            self.send_error(400,'Unknown demo host');return
        if self.headers.get('Transfer-Encoding'):
            self.send_error(400,'Chunked uploads are not supported in the local demo');return
        try:length=int(self.headers.get('Content-Length','0'))
        except ValueError:self.send_error(400);return
        if length<0 or length>10*1024*1024:self.send_error(413);return
        websocket=self.headers.get('Upgrade','').lower()=='websocket'
        if websocket and (self.command!='GET' or urllib.parse.urlsplit(self.path).path!='/api/ws/fcm' or length):
            self.send_error(400,'Unsupported demo WebSocket request');return
        connection=http.client.HTTPConnection('127.0.0.1',UPSTREAM_PORT,timeout=60)
        try:
            headers={k:v for k,v in self.headers.items() if k.lower() not in HOP|{'host','x-store-token','forwarded'} and not k.lower().startswith('x-forwarded-')}
            headers['Host']=slug+'.localhost:18090'
            headers['x-store-token']=token(slug)
            headers['Connection']='Upgrade' if websocket else 'close'
            if websocket:headers['Upgrade']='websocket'
            body=self.rfile.read(length) if length else None
            connection.request(self.command,self.path,body=body,headers=headers)
            response=connection.getresponse()
            if websocket and response.status==101:
                self.send_response(101)
                for k,v in response.getheaders():
                    if k.lower() not in HOP|{'content-length'}:self.send_header(k,v)
                self.send_header('Connection','Upgrade');self.send_header('Upgrade','websocket');self.end_headers();self.wfile.flush()
                self.close_connection=True
                self.relay_websocket(connection.sock,response.fp)
                return
            data=response.read()
            self.send_response(response.status)
            for k,v in response.getheaders():
                if k.lower() not in HOP|{'content-length'}:self.send_header(k,v)
            self.send_header('Content-Length',str(len(data)));self.end_headers()
            if self.command!='HEAD':self.wfile.write(data)
        except Exception:
            self.send_error(502,'Local commerce service unavailable; see .local/logs')
        finally:connection.close()
    def relay_websocket(self,upstream,reader):
        # Read buffered streams: an upstream can send its first frame with the upgrade headers.
        upstream.settimeout(None)
        stopped=threading.Event()
        def close_both():
            if stopped.is_set():return
            stopped.set()
            for peer in (self.connection,upstream):
                try:peer.shutdown(socket.SHUT_RDWR)
                except OSError:pass
        def copy(source,target):
            try:
                while not stopped.is_set():
                    data=source.read1(65536)
                    if not data:break
                    target.sendall(data)
            except OSError:pass
            finally:close_both()
        downstream=threading.Thread(target=copy,args=(reader,self.connection),daemon=True)
        downstream.start()
        copy(self.rfile,upstream)
        downstream.join(timeout=2)

    do_GET=do_POST=do_PUT=do_DELETE=do_PATCH=do_OPTIONS=do_HEAD=proxy
if __name__=='__main__':
    print('Demo gateway: http://demo-a.localhost:18090 and http://demo-b.localhost:18090',flush=True)
    ThreadingHTTPServer(('127.0.0.1',18090),Handler).serve_forever()
