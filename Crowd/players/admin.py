#! -*- coding: utf-8 -*-
#
# created by giginet on 2013/2/11
#
__author__ = 'giginet'

from django.contrib import admin
from models import Player
from metrics.models import Metric

class PlayerAdmin(admin.ModelAdmin):

    def play_count(obj):
        metrics = Metric.objects.filter(player=obj)
        return metrics.count()

    list_display = ('ip_address', play_count,)
admin.site.register(Player, PlayerAdmin)