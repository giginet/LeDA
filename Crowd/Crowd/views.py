# -*- coding: utf-8 -*-
#
# views.py
# created by giginet on 2012/12/27
#

import random
from django import http
from django.utils import simplejson as json
from django.views.generic import TemplateView, View
from levels.models import Level

class JSONResponseMixin(object):
    def get_json_response(self, content, **httpresponse_kwargs):
        return http.HttpResponse(content,
            content_type='application/json',
            **httpresponse_kwargs)

    def convert_context_to_json(self, context):
        return json.dumps(context)


class JSONView(JSONResponseMixin, View):
    pass

class IndexView(TemplateView):
    template_name = "index.html"

    def get_context_data(self, *args, **kwargs):
        context = super(IndexView, self).get_context_data(*args, **kwargs)
        level = random.choice(Level.objects.all())
        context['map_url'] = level.get_json_url()
        return context