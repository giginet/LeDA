from django.contrib import admin
from models import Metric

__author__ = 'giginet'

class MetricAdmin(admin.ModelAdmin):
    pass

admin.site.register(Metric, MetricAdmin)