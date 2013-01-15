#! -*- coding: utf-8 -*-
from django.db import models
from django.utils.translation import ugettext as _
from metrics.models import Metric

# Create your models here.

class Operation(models.Model):
    u"""プレイヤーの入力を保持するクラスです"""

    DIRECTIONS = (
        (0, _('Left')),
        (1, _('Right'))
    )

    x = models.PositiveSmallIntegerField(_('x'))
    y = models.PositiveSmallIntegerField(_('y'))
    metric = models.ForeignKey(Metric, related_name='operations')
    direction = models.SmallIntegerField(_('Direction'), choices=DIRECTIONS)
    created_at = models.DateTimeField(_('Created At'), auto_now_add=True)
