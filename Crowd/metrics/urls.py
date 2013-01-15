#! -*- coding: utf-8 -*-
#
# created by giginet on 2013/1/15
#
from django.conf.urls.defaults import patterns, url, include
from django.core.urlresolvers import reverse
from django.utils.functional import lazy
from django.views.generic import ListView
from models import Level
from metrics.views import MetricCreateView, MetricUpdateView, MetricJSONView

__author__ = 'giginet'

lazy_reverse = lambda name=None, *args : lazy(reverse, str)(name, args=args)

urlpatterns = patterns('',
    url(r'^create$', MetricCreateView.as_view(), name='metrics_metric_create'),
    url(r'^(?P<pk>\d+)/update$', MetricUpdateView.as_view(), name='metrics_metric_update'),
    url(r'^(?P<pk>\d+)/json', MetricJSONView.as_view(), name='metrics_metric_json'),
)