#! -*- coding: utf-8 -*-
from django.db import models
from django.utils.translation import ugettext as _

# Create your models here.

class Player(models.Model):
    ip_address = models.IPAddressField(_('IP Address'), blank=True, null=False, unique=True)

    class Meta:
        verbose_name = u"プレイヤー"
        verbose_name_plural = verbose_name

    def __unicode__(self):
        return self.ip_address