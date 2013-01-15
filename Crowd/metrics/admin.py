from django.contrib import admin
from models import Metric

__author__ = 'giginet'

class MetricAdmin(admin.ModelAdmin):

    def state_name(obj):
        return dict(Metric.STATE)[obj.state]

    list_display = ('stage', state_name, 'created_at', 'ip_address')

admin.site.register(Metric, MetricAdmin)