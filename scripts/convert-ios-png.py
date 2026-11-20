#!/usr/bin/env python3
"""
[EN] Converts a PNG that Xcode optimized for iOS (a `CgBI` chunk: raw deflate, BGRA, premultiplied alpha) into a standard PNG
     that Android, HarmonyOS and the mini program can read. Standard library only. Usage: convert-ios-png.py in.png out.png
[CN] 把 Xcode 为 iOS 优化过的 PNG（带 `CgBI` 块：原始 deflate、BGRA、预乘 alpha）转换为 Android、HarmonyOS 与小程序都能读取的标准 PNG。
     只使用标准库。用法：convert-ios-png.py in.png out.png
"""
import struct
import sys
import zlib


def chunks(data):
    position = 8
    while position < len(data):
        length, kind = struct.unpack(">I4s", data[position:position + 8])
        yield kind, data[position + 8:position + 8 + length]
        position += 12 + length


def chunk(kind, payload):
    body = kind + payload
    return struct.pack(">I", len(payload)) + body + struct.pack(">I", zlib.crc32(body) & 0xFFFFFFFF)


def unfilter(raw, width, height, bpp):
    stride = width * bpp
    rows, previous = [], bytearray(stride)
    position = 0
    for _ in range(height):
        kind = raw[position]
        line = bytearray(raw[position + 1:position + 1 + stride])
        position += 1 + stride
        for i in range(stride):
            a = line[i - bpp] if i >= bpp else 0
            b = previous[i]
            c = previous[i - bpp] if i >= bpp else 0
            if kind == 1:
                line[i] = (line[i] + a) & 255
            elif kind == 2:
                line[i] = (line[i] + b) & 255
            elif kind == 3:
                line[i] = (line[i] + (a + b) // 2) & 255
            elif kind == 4:
                p = a + b - c
                pa, pb, pc = abs(p - a), abs(p - b), abs(p - c)
                line[i] = (line[i] + (a if pa <= pb and pa <= pc else b if pb <= pc else c)) & 255
        rows.append(line)
        previous = line
    return rows


def convert(source, target):
    data = open(source, "rb").read()
    if data[:8] != b"\x89PNG\r\n\x1a\n":
        raise SystemExit("not a PNG")
    header, idat, cgbi = None, b"", False
    for kind, payload in chunks(data):
        if kind == b"CgBI":
            cgbi = True
        elif kind == b"IHDR":
            header = payload
        elif kind == b"IDAT":
            idat += payload
    width, height, depth, color = struct.unpack(">IIBB", header[:10])
    if depth != 8 or color != 6 or header[12] != 0:
        raise SystemExit("only 8-bit RGBA, not interlaced")
    raw = zlib.decompress(idat, -15 if cgbi else 15)
    out = bytearray()
    for line in unfilter(raw, width, height, 4):
        out.append(0)
        for i in range(0, len(line), 4):
            b, g, r, a = line[i:i + 4] if cgbi else (line[i + 2], line[i + 1], line[i], line[i + 3])
            if cgbi and 0 < a < 255:
                r, g, b = min(255, round(r * 255 / a)), min(255, round(g * 255 / a)), min(255, round(b * 255 / a))
            out += bytes((r, g, b, a))
    png = b"\x89PNG\r\n\x1a\n" + chunk(b"IHDR", header) + chunk(b"IDAT", zlib.compress(bytes(out), 9)) + chunk(b"IEND", b"")
    open(target, "wb").write(png)


if __name__ == "__main__":
    if len(sys.argv) != 3:
        raise SystemExit(__doc__)
    convert(sys.argv[1], sys.argv[2])
