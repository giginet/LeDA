# -*- coding: utf-8 -*-
# Create your views here.
import random
from django import http
from django.views.generic.base import View
from django.forms.models import model_to_dict
from django.utils import simplejson
from django.views.generic.detail import BaseDetailView, DetailView
from django.views.generic.list import BaseListView
from metrics.views import get_metric_dict

from Crowd.views import JSONResponseMixin
from models import Level

class LevelDetailView(DetailView):
    model = Level

class LevelBaseDetailView(BaseDetailView):
    def get_object(self, queryset=None):
        instance = super(BaseDetailView, self).get_object(queryset)
        return instance.model.objects.get(pk=instance.pk)

class LevelJSONView(JSONResponseMixin, BaseDetailView):
    model = Level

    def render_to_response(self, context):
        d = {'pk' : self.object.pk, 'stage_data' : simplejson.loads(self.object.stage_data)}
        return self.get_json_response(self.convert_context_to_json(d))

class LevelRandomJSONView(JSONResponseMixin, BaseDetailView):
    model = Level

    def get_object(self, queryset=None):
        if self.request.GET.has_key('ignore'):
            ignore = self.request.GET['ignore']
            return random.choice(Level.objects.exclude(pk=ignore))
        return random.choice(Level.objects.all())

    def render_to_response(self, context):
        d = {'pk' : self.object.pk, 'stage_data' : simplejson.loads(self.object.stage_data)}
        return self.get_json_response(self.convert_context_to_json(d))

class LevelMetricsJSONView(JSONResponseMixin, BaseDetailView):
    model = Level

    def render_to_response(self, context):
        level = self.get_object()
        metrics_dict = [get_metric_dict(metric) for metric in self.object.metrics.all()]
        print metrics_dict
        return self.get_json_response(self.convert_context_to_json(metrics_dict))
