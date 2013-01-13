# Create your views here.
from django import http
from django.utils import simplejson as json
from django.views.generic.base import View
from django.views.generic.detail import BaseDetailView, DetailView
from models import Level

class JSONResponseMixin(object):
    def get_json_response(self, content, **httpresponse_kwargs):
        return http.HttpResponse(content,
            content_type='application/json',
            **httpresponse_kwargs)

    def convert_context_to_json(self, context):
        return json.dumps(context)


class JSONView(JSONResponseMixin, View):
    pass

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