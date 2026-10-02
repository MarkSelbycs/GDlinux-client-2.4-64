#!/usr/bin/env python3
"""Probe ticket.cgi with a properly encoded ticket request.

Only prints non-sensitive diagnostics: status codes, header markers, body
lengths and structural tags. No credentials are involved in the ticket step.
"""
import ctypes
import socket
import sys
import datetime

SO = "test/work/protect-captured.so"
UA = "CCTP/Linux64/2.4.64"
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


def decode(lib, text):
    ptr = lib.DeCode(text.encode("latin1"))
    if not ptr:
        return None
    out = ctypes.string_at(ptr)
    lib.FreeResult(ptr)
    return out


def http(method, path, body=None, cookie=None):
    s = socket.create_connection((HOST, PORT), timeout=8)
    head = (
        f"{method} {path} HTTP/1.1\r\nHost: {HOST}\r\nUser-Agent: {UA}\r\n"
        "Accept: text/html,text/xml,application/xhtml+xml,application/xml,*/*\r\n"
        "Connection: close\r\n"
    )
    if cookie:
        head += f"Cookie: {cookie}\r\n"
    raw_body = body.encode("latin1") if body is not None else None
    if raw_body is not None:
        head += "Content-Type: text/xml; charset=UTF-8\r\n"
        head += f"Content-Length: {len(raw_body)}\r\n"
    head += "\r\n"
    s.sendall(head.encode("latin1") + (raw_body or b""))
    data = b""
    while True:
        chunk = s.recv(8192)
        if not chunk:
            break
        data += chunk
    s.close()
    header, _, rest = data.partition(b"\r\n\r\n")
    return header.decode("latin1"), rest


def main():
    lib = load_codec()
    now = datetime.datetime.now().strftime("%Y-%m-%d %H:%M:%S")
    request = (
        '<?xml version="1.0" encoding="UTF-8"?><request>'
        f"<host-name>{HOST}</host-name>"
        f"<user-agent>{UA}</user-agent>"
        "<client-id>91aa3b40-3b40-91aa-b5f9-2d8c7fff75f92d8c</client-id>"
        "<ipv4>172.17.104.132</ipv4><ipv6></ipv6>"
        "<mac>a4:fa:76:44:ba:e8</mac>"
        f"<local-time>{now}</local-time><ostag></ostag></request>"
    )
    encoded = code(lib, request)
    print(f"request_len={len(request)} encoded_len={len(encoded or '')}")
    header, body = http("GET", TICKET_PATH)
    cookie = None
    for line in header.splitlines():
        if line.lower().startswith("set-cookie:"):
            cookie = line.split(":", 1)[1].strip().split(";")[0]
        if line.lower().startswith(("error-code:", "server-tag:")):
            print("GET", line.strip())
    print(f"GET body_len={len(body)}")

    header, body = http("POST", TICKET_PATH, encoded, cookie)
    for line in header.splitlines():
        if line.lower().startswith(("http/", "error-code:", "server-tag:")):
            print("POST", line.strip())
    print(f"POST body_len={len(body)} first_bytes={body[:40]!r}")
    decoded = decode(lib, body.decode("latin1"))
    print(f"decoded={decoded!r}")
    # roundtrip check
    print(f"roundtrip_ok={decode(lib, encoded.encode('latin1')) == request.encode('utf-8')}")


if __name__ == "__main__":
    sys.exit(main())
