__author__ = 'giginet'

from django.contrib import admin
from models import Operation

class OperationAdmin(admin.ModelAdmin):

    def position(obj):
        return (obj.x, obj.y)

    def direction(obj):
        return dict(Operation.DIRECTIONS)[obj.direction]

    list_display = ('metric', position, direction, 'created_at')
admin.site.register(Operation, OperationAdmin)