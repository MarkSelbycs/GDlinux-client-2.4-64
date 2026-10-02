#!/usr/bin/env python3
"""Probe ticket.cgi with the full client header set.

Only prints non-sensitive diagnostics: HTTP status, portal Error-Code, body
length and structural tags. No credentials are involved in the ticket step.
"""
import ctypes
import hashlib
import socket
import sys
import datetime

SO = "test/work/protect-captured.so"
UA = "CCTP/Linux64/2.4.64"
ALGO_ID = "45433DCF-9ECA-4BE5-83F2-F92BA0B4F291"
CLIENT_ID = "91aa3b40-3b40-91aa-b5f9-2d8c7fff75f92d8c"
SCHOOL_ID = "1099"
DOMAIN = "sise.cn"
AREA = "020"
HOST = "14.146.227.141"
PORT = 7001
TICKET_PATH = (
    "/ticket.cgi?wlanacip=183.3.151.148&wlanuserip=172.17.104.132"
    "&clientip=172.17.104.132&wlanacname=sise"
    "&clientmac=a4:fa:76:44:ba:e8&paip=10.88.88.88&vlan=100.0"
    "&iarmdst=www.189.cn/&portal_node=http://125.88.59.131:10002"
)


def load_codec():
    lib = ctypes.CDLL(SO)
    lib.Code.restype = ctypes.c_void_p
    lib.Code.argtypes = [ctypes.c_char_p]
    lib.DeCode.restype = ctypes.c_void_p
    lib.DeCode.argtypes = [ctypes.c_char_p]
    lib.FreeResult.restype = None
    lib.FreeResult.argtypes = [ctypes.c_void_p]
    return lib


def code(lib, text):
    ptr = lib.Code(text.encode("utf-8"))
    if not ptr:
        return None
    out = ctypes.string_at(ptr).decode("latin1")
    lib.FreeResult(ptr)
    return out


def decode(lib, data):
    ptr = lib.DeCode(data if isinstance(data, bytes) else data.encode("latin1"))
    if not ptr:
        return None
    out = ctypes.string_at(ptr)
    lib.FreeResult(ptr)
    return out


def http(method, path, body=None, cookie=None, headers=None):
    s = socket.create_connection((HOST, PORT), timeout=8)
    lines = [f"{method} {path} HTTP/1.1", f"Host: {HOST}", "Connection:close"]
    if headers:
        lines.extend(headers)
    if cookie:
        lines.append(f"Cookie: {cookie}")
    raw_body = body.encode("latin1") if body is not None else None
    if raw_body is not None:
        lines.append("Content-Type: text/xml; charset=UTF-8")
        lines.append(f"Content-Length: {len(raw_body)}")
    data = ("\r\n".join(lines) + "\r\n\r\n").encode("latin1") + (raw_body or b"")
    s.sendall(data)
    resp = b""
    while True:
        chunk = s.recv(8192)
        if not chunk:
            break
        resp += chunk
    s.close()
    header, _, rest = resp.partition(b"\r\n\r\n")
    return header.decode("latin1"), rest


def main():
    lib = load_codec()
    now = datetime.datetime.now().strftime("%Y-%m-%d %H:%M:%S")
    request = (
        '<?xml version="1.0" encoding="UTF-8"?><request>'
        f"<host-name>{HOST}</host-name>"
        f"<user-agent>{UA}</user-agent>"
        f"<client-id>{CLIENT_ID}</client-id>"
        "<ipv4>172.17.104.132</ipv4><ipv6></ipv6>"
        "<mac>a4:fa:76:44:ba:e8</mac>"
        f"<local-time>{now}</local-time><ostag></ostag></request>"
    )
    encoded = code(lib, request)
    checksum = hashlib.md5(encoded.encode("latin1")).hexdigest()
    print(f"request_len={len(request)} encoded_len={len(encoded)} checksum={checksum}")

    headers = [
        f"User-Agent:{UA}",
        f"Algo-ID:{ALGO_ID}",
        f"Client-ID:{CLIENT_ID}",
        f"CDC-Checksum:{checksum}",
        f"CDC-SchoolId:{SCHOOL_ID}",
        f"CDC-Domain:{DOMAIN}",
        f"CDC-Area:{AREA}",
    ]
    header, body = http("GET", TICKET_PATH, headers=headers)
    cookie = None
    for line in header.splitlines():
        if line.lower().startswith("set-cookie:"):
            cookie = line.split(":", 1)[1].strip().split(";")[0]
        if line.lower().startswith(("error-code:", "server-tag:")):
            print("GET", line.strip())
    print(f"GET body_len={len(body)}")

    header, body = http("POST", TICKET_PATH, encoded, cookie, headers)
    for line in header.splitlines():
        if line.lower().startswith(("http/", "error-code:", "server-tag:")):
            print("POST", line.strip())
    print(f"POST body_len={len(body)} first={body[:60]!r}")
    decoded = decode(lib, body)
    print(f"decoded={decoded!r}")
    return 0


if __name__ == "__main__":
    sys.exit(main())
