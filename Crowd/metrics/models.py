#! -*- coding: utf-8 -*-
from django.db import models
from levels.models import Level
from django.utils.translation import ugettext as _

# Create your models here.

class Metric(models.Model):
    u"""プレイヤーの１プレイを保持するクラスです"""

    STATE = (
        (0, _('Playing')),
        (1, _('Clear')),
        (2, _('GameOver'))
    )

    stage = models.ForeignKey(Level)
    pre_metric = models.ForeignKey('Metric', null=True, blank=True)
    ip_address = models.IPAddressField(_('IP Address'), blank=True, null=False)
    state = models.SmallIntegerField(_('State'), default=0, choices=STATE, editable=False)
    created_at = models.DateTimeField(_('Created At'), auto_now_add=True)

    def __unicode__(self):
        return self.stage.title