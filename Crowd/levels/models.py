from django.db import models
from django.utils.translation import ugettext as _

# Create your models here.

class Level(models.Model):
    u"""ステージデータを定義するモデルです"""
    title = models.CharField(_('Level Title'), max_length=255)
    stage_data = models.TextField(_('Level Data'))
    optimized_turn = models.IntegerField(_('Optimized '))
    created_at = models.DateTimeField(_('Created At'), auto_now_add=True)
    updated_at = models.DateTimeField(_('Updated At'), auto_now=True)
