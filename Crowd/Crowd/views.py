# -*- coding: utf-8 -*-
#
# views.py
# created by giginet on 2012/12/27
#

from django.views.generic import TemplateView

class IndexView(TemplateView):
    template_name = "index.html"
