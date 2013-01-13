from django.db import models
from levels.models import Level
from django.utils.translation import ugettext as _

# Create your models here.

class Metric(models.Model):
    u"""プレイヤーの１プレイを保持するクラスです"""

    stage = models.ForeignKey(Level)
    pre_metric = models.ForeignKey('Metric', null=True, blank=True)
    ip_address = models.IPAddressField(_('IP Address'), editable=False, blank=True, null=False)
    is_cleared = models.BooleanField(_('isCleared'), default=False)
    created_at = models.DateTimeField(_('Created At'), auto_now_add=True)