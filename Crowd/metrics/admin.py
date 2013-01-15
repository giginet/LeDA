from django.contrib import admin
from models import Metric

__author__ = 'giginet'

class MetricAdmin(admin.ModelAdmin):

    def state_name(obj):
        return dict(Metric.STATE)[obj.state]

    def turn_count(obj):
        return obj.operations.count()

    def play_time(obj):
        return obj.get_playtime()

    list_display = ('stage', state_name, turn_count, play_time, 'created_at', 'ip_address')

admin.site.register(Metric, MetricAdmin)