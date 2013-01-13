from django.contrib import admin
from models import Level

__author__ = 'giginet'

class LevelAdmin(admin.ModelAdmin):
    fields = ['stage_file', 'stage_data',]

admin.site.register(Level, LevelAdmin)