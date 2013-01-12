# -*- coding: utf-8 -*-
#
# crypt.py
# created by giginet on 2013/01/12
#
from mwcrypt.crypt import mwcrypt, MAP_LENGTH

import sys
import array
import struct

class Map(object):
    CRC_BEGIN = 0x9C
    CRC_LENGTH = 4

    def __init__(self, filename, is_encrypted):
        f = open(filename, "rb")
        s = struct.Struct('<i')
        if is_encrypted:
            encrypted_buf = array.array('c', f.read())
            crc = s.unpack(encrypted_buf[self.CRC_BEGIN:self.CRC_BEGIN + self.CRC_LENGTH].tostring())[0]
            crypted = mwcrypt(encrypted_buf[:self.CRC_BEGIN], MAP_LENGTH, crc)
            self.buf = array.array('c', crypted)
        else:
            self.buf = array.array('c', f.read())

    def get_name(self):
        return self.buf[0x001A:0x001F + 1].tostring()

    def check_crt(self):
        pass

    def get_player_position(self):
        return list(str(ord(self.buf[0x000A])))

    def get_player_direction(self):
        return ord(self.buf[0x000B])

    def get_version(self):
        return [s for s in self.buf[0x009A:0x009A + 2]]

    def get_checksum(self):
        return [s for s in self.buf[0x009C:0x009C + 4]]

    def get_matrix(self):
        return [[ord(self.buf[x + y * 16]) for y in xrange(10)] for x in xrange(10)]

    def dump_to_json(self):
        pass

if __name__ == '__main__':
    if len(sys.argv) < 3:
        print "usage %s <filename>" % sys.argv[0]
    else:
        filename = sys.argv[1]
        is_encrypted = sys.argv[2] != 'False'
        m = Map(filename, is_encrypted)
        print m.get_name()
        print m.get_player_direction()
        print m.get_player_position()
        print m.get_version()
        print m.get_checksum()
        matrix = m.get_matrix()
        for y in xrange(10):
            for x in xrange(10):
                print "%3d " % matrix[x][y],
            print
