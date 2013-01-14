# Create your views here.
from django import http
from django.views.generic.base import View
from django.views.generic.detail import BaseDetailView, DetailView

from Crowd.views import JSONResponseMixin
from models import Level

class LevelDetailView(DetailView):
    model = Level

class LevelBaseDetailView(BaseDetailView):
    def get_object(self, queryset=None):
        instance = super(BaseDetailView, self).get_object(queryset)
        return instance.model.objects.get(pk=instance.pk)

class LevelJsonView(JSONResponseMixin, BaseDetailView):
    model = Level
    def render_to_response(self, context):
        return self.get_json_response(self.get_object().stage_data)