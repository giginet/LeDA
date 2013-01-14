from django.contrib import admin
from models import Metric

__author__ = 'giginet'

class MetricAdmin(admin.ModelAdmin):
    list_display = ('stage', 'created_at', 'ip_address')

admin.site.register(Metric, MetricAdmin)