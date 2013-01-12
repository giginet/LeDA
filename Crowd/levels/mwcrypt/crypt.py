# -*- coding: utf-8 -*-
#
# crypt.py
# created by giginet on 2013/01/12
#
import sys
import array
import struct

KEY = 0xa8f73061
TABLE = [0xF582320C, 0xEE6A3CE5, 0xBC2DADAB, 0x648BCFCD]
MAP_LENGTH = 0x9C

def round_order(hx):
    if hx < 0:
        hx += 0x100000000
    if hx > 0xFFFFFFFF:
         hx -= 0x100000000
    return hx

def mwcrypt(buf, length, crc):
    s = struct.Struct(str(length / 4) + 'i')
    unpacked = s.unpack(buf)
    crypt = crc
    crypted = []
    for i in xrange(length / 4):
        crypt = round_order(crypt + KEY)
        crypt = round_order(crypt + TABLE[i % 4])
        xor = round_order(unpacked[i] ^ crypt)
        crypted.append(xor)
    crypted_struct = struct.Struct('<' + str(length / 4) + "L")
    result = crypted_struct.pack(*crypted)
    return result

def mwcrc(buf, length):
    table = []
    for cnt in xrange(256):
        c = cnt
        for j in xrange(8):
            if c & 1:
                c = (((c >> 1) & 0x7FFFFFFF) ^ 0xEDB88320)
            else:
                c = ((c >> 1) & 0x7FFFFFFF)
        table.append(c)
    crc = 0xFFFFFFFF
    for i in xrange(length):
        crc = (((crc >> 8) & 0xFFFFFF) ^ table[(crc ^ ord(buf[i])) & 0xff])
    return crc ^ 0xFFFFFFFF ^ KEY

if __name__ == '__main__':
    if len(sys.argv) < 2:
        print "usage %s <filename>" % sys.argv[0]
    else:
        filename = sys.argv[1]
        f = open(filename, "rb")
        original = f.read()
        buf = array.array('c', original)
        s = struct.Struct('<i')
        crc = s.unpack(buf[0x9C:0x9C + 4].tostring())[0]
        encrypt = mwcrypt(buf[:0x9C], MAP_LENGTH, crc)
        ANS = 'output1.mwm'
        ans = open(ANS, 'rb')
        ans_buf = ans.read()
