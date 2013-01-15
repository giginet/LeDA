# -*- coding: utf-8 -*-
from django.views.generic.edit import CreateView, UpdateView
from models import Metric
from django.http import QueryDict
from django.forms.models import model_to_dict
from Crowd.views import JSONResponseMixin

class MetricCreateView(CreateView, JSONResponseMixin):
    model = Metric
    success_url = "/"

    def get_form_kwargs(self):
        u"""ip_addressにIPアドレスを格納します"""
        kwargs = super(MetricCreateView, self).get_form_kwargs()
        if kwargs.has_key('data'):
            qd = kwargs["data"].copy()
            qd.update({"ip_address" : self.request.META['REMOTE_ADDR']})
            qd.update({"state" : 0})
            kwargs["data"] = qd
        return kwargs

    def form_valid(self, form):
        u"""成功時、オブジェクトの状態をJSONで返却します"""
        super(MetricCreateView, self).form_valid(form)
        d = model_to_dict(self.object)
        d.update({'pk' : self.object.pk})
        return self.get_json_response(self.convert_context_to_json(d))

class MetricUpdateView(UpdateView, JSONResponseMixin):
    model = Metric
    success_url = "/"

    def get_form_kwargs(self):
        u"""ステージ番号を格納します"""
        kwargs = super(MetricUpdateView, self).get_form_kwargs()
        if kwargs.has_key('data'):
            qd = kwargs["data"].copy()
            qd.update({"ip_address" : self.request.META['REMOTE_ADDR']})
            qd.update({"stage" : self.object.stage.pk})
            if self.object.pre_metric:
                qd.update({"pre_metric" : self.object.pre_metric.pk})
            kwargs["data"] = qd
        return kwargs

    def form_valid(self, form):
        u"""成功時、オブジェクトの状態をJSONで返却します"""
        super(MetricUpdateView, self).form_valid(form)
        d = model_to_dict(self.object)
        d.update({'pk' : self.object.pk})
        return self.get_json_response(self.convert_context_to_json(d))
