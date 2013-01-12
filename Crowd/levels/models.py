#! -*- coding: utf-8 -*-
import os
from django.db import models
from django.utils.translation import ugettext as _

# Create your models here.

class Level(models.Model):
    u"""ステージデータを定義するモデルです"""

    def _get_upload_path(self, filename):
        path = u'storage/levels/'
        return os.path.join(path, filename)

    title = models.CharField(_('Level Title'), max_length=255)
    stage_data = models.TextField(_('Level Data'))
    stage_file = models.FileField(upload_to=_get_upload_path)
    optimized_turn = models.IntegerField(_('Optimized '))
    created_at = models.DateTimeField(_('Created At'), auto_now_add=True)
    updated_at = models.DateTimeField(_('Updated At'), auto_now=True)

    def get_json(self):
        u"""ステージデータをJSONとして取り出します"""
        pass