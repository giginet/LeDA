from django.db import models

# Create your models here.

class Player(models.Model):
    ip_address = models.IPAddressField(_('IP Address'), blank=True, null=False, unique=True)

    class Meta:
        verbose_name = u"プレイヤー"
        verbose_name_plural = verbose_name

    def __unicode__(self):
        return self.ip_address