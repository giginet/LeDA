# -*- coding: utf-8 -*-
#
# crypt.py
# created by giginet on 2013/01/12
#
from mwcrypt.crypt import mwcrypt, MAP_LENGTH
from django.utils import simplejson

import sys
import array
import binascii
import struct

class Map(object):
    CRC_BEGIN = 0x9C
    CRC_LENGTH = 4

    def __init__(self, binary, is_encrypted):
        s = struct.Struct('<i')
        if is_encrypted:
            encrypted_buf = array.array('c', binary)
            crc = s.unpack(encrypted_buf[self.CRC_BEGIN:self.CRC_BEGIN + self.CRC_LENGTH].tostring())[0]
            crypted = mwcrypt(encrypted_buf[:self.CRC_BEGIN], MAP_LENGTH, crc)
            self.buf = array.array('c', crypted)
        else:
            self.buf = array.array('c', binary)

    def get_name(self):
        return self.buf[0x001A:0x001F + 1].tostring()

    def check_crt(self):
        pass

    def get_player_position(self):
        return [n for n in list(str(binascii.b2a_hex(self.buf[0x000A])))]

    def get_player_direction(self):
        return ord(self.buf[0x000B])

    def get_version(self):
        return [s for s in self.buf[0x009A:0x009A + 2]]

    def get_checksum(self):
        return [s for s in self.buf[0x009C:0x009C + 4]]

    def get_matrix(self):
        return [[ord(self.buf[x + y * 16]) for y in xrange(10)] for x in xrange(10)]

    def dump_to_dictionary(self):
        u"""
        stage = {
            name = "TESTCP",
            player = (0, 0, 0),
            map = {
                {0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
                {0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
                {0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
                {0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
                {0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
                {0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
                {0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
                {0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
                {0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
                {0, 0, 0, 0, 0, 0, 0, 0, 0, 0}
            }
        }
        """
        stage = {}
        stage["name"] = self.get_name()
        stage["player"] = list(self.get_player_position())
        stage["player"].append(self.get_player_direction())
        stage["map"] = self.get_matrix()
        return stage

    def dump_to_json(self):
        return simplejson.dumps(self.dump_to_dictionary())