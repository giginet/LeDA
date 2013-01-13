# -*- coding: utf-8 -*-
#
# views.py
# created by giginet on 2012/12/27
#

import random
from django.views.generic import TemplateView
from levels.models import Level

class IndexView(TemplateView):
    template_name = "index.html"

    def get_context_data(self, *args, **kwargs):
        context = super(IndexView, self).get_context_data(*args, **kwargs)
        level = random.choice(Level.objects.all())
        context['map_url'] = level.get_json_url()
        return context