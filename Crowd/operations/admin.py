__author__ = 'giginet'

from django.contrib import admin
from models import Operation

class OperationAdmin(admin.ModelAdmin):
    pass
admin.site.register(Operation, OperationAdmin)