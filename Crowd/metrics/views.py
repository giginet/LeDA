# -*- coding: utf-8 -*-
from django.views.generic.detail import DetailView
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

class MetricJSONView(JSONResponseMixin, DetailView):
    model = Metric

    def render_to_response(self, context, **response_kwargs):
        u"""
        Metric再生用のJSONを返却します
        """
        begin = self.object.created_at
        def create_operation_dict(operation):
            operation_dict = model_to_dict(operation)
            delta = operation.created_at - begin
            operation_dict.update({'offset' : float(delta.total_seconds())}) # ゲーム開始からの開始時間を秒で格納します
            return operation_dict
        operations = [create_operation_dict(operation) for operation in self.object.operations.order_by('created_at')]
        metric_dict = {'id' : self.object.pk, 'stage' : self.object.stage.pk, 'operations' : operations}
        return self.get_json_response(self.convert_context_to_json(metric_dict))

class MetricDetailView(DetailView):
    model = Metric

    def get_context_data(self, **kwargs):
        context = super(MetricDetailView, self).get_context_data()
        context["stage_url"] = self.object.stage.get_json_url()
        return context