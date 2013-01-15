#! -*- coding: utf-8 -*-
import datetime
from django.db import models
from levels.models import Level
from django.utils.translation import ugettext as _
from django.db.models import Max

# Create your models here.

class Metric(models.Model):
    u"""プレイヤーの１プレイを保持するクラスです"""

    STATE = (
        (0, _('Playing')),
        (1, _('Clear')),
        (2, _('GameOver'))
    )

    stage = models.ForeignKey(Level, related_name='metrics')
    pre_metric = models.ForeignKey('Metric', null=True, blank=True)
    ip_address = models.IPAddressField(_('IP Address'), blank=True, null=False)
    state = models.SmallIntegerField(_('State'), default=0, choices=STATE, blank=True, null=False)
    created_at = models.DateTimeField(_('Created At'), auto_now_add=True)

    def __unicode__(self):
        return self.stage.title

    def get_playtime(self):
        begin = self.created_at
        if self.operations.count() == 0:
            return datetime.timedelta(0)
        end = self.operations.order_by('-created_at')[0].created_at
        return end - begin

    def get_state_name(self):
        return dict(self.STATE)[self.state]

    @models.permalink
    def get_absolute_url(self):
        return ('metrics_metric_detail', (), { 'pk' : self.pk })