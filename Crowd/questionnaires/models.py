from django.db import models

# Create your models here.

class Questionnaire(models.Model):

    class Meta:
        verbose_name = u"アンケート"
        verbose_name_plural = verbose_name