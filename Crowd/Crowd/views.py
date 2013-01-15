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
        get = self.request.GET
        print get
        if Level.objects.count() > 0:
            if get.has_key("stage"):
                level = Level.objects.get(pk=get['stage'])
                if not level:
                    level = random.choice(Level.objects.all())
                    context['stage_url'] = level.get_json_url()
                else:
                    context['stage_url'] = level.get_json_url()
            else:
                level = random.choice(Level.objects.all())
                context['stage_url'] = level.get_json_url()
        context['stage_count'] = Level.objects.count()
        return context
