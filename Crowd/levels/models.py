#! -*- coding: utf-8 -*-
import os
from django.db import models
from django.utils.translation import ugettext as _
from django.conf import settings

# Create your models here.

class Level(models.Model):
    u"""ステージデータを定義するモデルです"""

    def _get_upload_path(self, filename):
        path = u'static/storage/levels/'
        return os.path.join(path, filename)

    title = models.CharField(_('Level Title'), max_length=255)
    stage_data = models.TextField(_('Level Data'), blank=True, null=True, editable=False)
    stage_file = models.FileField(upload_to=_get_upload_path, blank=False, null=False)
    optimized_turn = models.IntegerField(_('Optimized '), null=True, blank=True, editable=False)
    created_at = models.DateTimeField(_('Created At'), auto_now_add=True)
    updated_at = models.DateTimeField(_('Updated At'), auto_now=True)

    def get_json(self):
        u"""ステージデータをJSONとして取り出します"""
        pass


from django.db.models.signals import pre_save
from map import Map

from django.conf import settings

def load_binary(sender, instance, **kwargs):
    if not instance.stage_data:
        file = instance.stage_file
        print instance._get_upload_path(file.name)
        map = Map(file.read(), True)
        instance.stage_data = map.dump_to_json()
        print instance.stage_data
pre_save.connect(load_binary, sender=Level)