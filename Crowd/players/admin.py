#! -*- coding: utf-8 -*-
#
# created by giginet on 2013/2/11
#
__author__ = 'giginet'

from django.contrib import admin
from models import Player

class PlayerAdmin(admin.ModelAdmin):

    list_display = ('ip_address',)
admin.site.register(Player, PlayerAdmin)