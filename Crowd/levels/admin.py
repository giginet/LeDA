from django.contrib import admin
from models import Level

__author__ = 'giginet'

class LevelAdmin(admin.ModelAdmin):
    fields = ['title', 'stage_file',]

admin.site.register(Level, LevelAdmin)