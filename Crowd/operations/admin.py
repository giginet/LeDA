__author__ = 'giginet'

from django.contrib import admin
from models import Operation

class OperationAdmin(admin.ModelAdmin):
    list_display = ('metric', 'x', 'y', 'direction', 'created_at')
admin.site.register(Operation, OperationAdmin)