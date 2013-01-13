#! -*- coding: utf-8 -*-
from django.db import models
from django.utils.translation import ugettext as _
from metrics.models import Metric

# Create your models here.

class Operation(models.Model):
    u"""プレイヤーの入力を保持するクラスです"""

    DIRECTIONS = (
        ('left', _('Left')),
        ('right', _('Right'))
    )

    x = models.PositiveSmallIntegerField(_('x'))
    y = models.PositiveSmallIntegerField(_('y'))
    metric = models.ForeignKey(Metric)
    direction = models.CharField(_('direction'), choices=DIRECTIONS, max_length=15)
    created_at = models.DateTimeField(_('Created At'), auto_now_add=True)
