# -*- coding: utf-8 -*-
from django.conf.urls.defaults import patterns, url, include
from django.core.urlresolvers import reverse
from django.utils.functional import lazy
from django.views.generic import ListView
from views import LevelDetailView, LevelJsonView
from models import Level
__author__ = 'giginet'
__version__ = '1.0.0'
__date__ = '2011/10/10'

lazy_reverse = lambda name=None, *args : lazy(reverse, str)(name, args=args)

urlpatterns = patterns('',
    url(r'^(?P<pk>\d+)/$', LevelDetailView.as_view(), name="levels_level_detail"),
    url(r'^(?P<pk>\d+)/json/$', LevelJsonView.as_view(), name="levels_level_json"),
)