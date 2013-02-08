from django.contrib import admin
from django.db import models
from models import Level
from django.db.models.query import QuerySet

__author__ = 'giginet'

class LevelAdmin(admin.ModelAdmin):

    def gameover_rate(obj):
        return str(obj.gameover_rate) + "%"

    def clear_rate(obj):
        return str(obj.clear_rate) + "%"

    def defection_rate(obj):
        return str(obj.defection_rate) + "%"

    fields = ['stage_file', 'stage_data',]
    list_display = ('title', gameover_rate, clear_rate, defection_rate)

admin.site.register(Level, LevelAdmin)