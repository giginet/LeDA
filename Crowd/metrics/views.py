# -*- coding: utf-8 -*-
from django.views.generic.detail import DetailView
from django.views.generic.edit import CreateView, UpdateView
from models import Metric
from django.http import QueryDict
from django.forms.models import model_to_dict
from django.core.urlresolvers import reverse
from Crowd.views import JSONResponseMixin

from players.models import Player

class MetricCreateView(CreateView, JSONResponseMixin):
    model = Metric
    success_url = "/"

    def get_form_kwargs(self):
        u"""PlayerにIPアドレスを格納します"""
        kwargs = super(MetricCreateView, self).get_form_kwargs()
        if kwargs.has_key('data'):
            qd = kwargs["data"].copy()
            player = Player.objects.get_or_create(ip_address=self.request.META['REMOTE_ADDR'])[0]
            qd.update({"player" : player.pk})
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
            player = Player.objects.get_or_create(ip_address=self.request.META['REMOTE_ADDR'])[0]
            qd.update({"player" : player.pk})
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

def get_metric_dict(metric):
    u"""Metricのmodelをdict化します"""
    begin = metric.created_at
    def create_operation_dict(operation):
        operation_dict = model_to_dict(operation)
        delta = operation.created_at - begin
        operation_dict.update({'offset' : float(delta.total_seconds())}) # ゲーム開始からの開始時間を秒で格納します
        return operation_dict
    operations = [create_operation_dict(operation) for operation in metric.operations.order_by('created_at')]
    metric_dict = {'id' : metric.pk, 'stage' : metric.stage.pk, 'operations' : operations}
    return metric_dict


class MetricJSONView(JSONResponseMixin, DetailView):
    model = Metric

    def render_to_response(self, context, **response_kwargs):
        u"""
        Metric再生用のJSONを返却します
        """
        return self.get_json_response(self.convert_context_to_json(get_metric_dict(self.object)))

class MetricDetailView(DetailView):
    model = Metric

    def get_context_data(self, **kwargs):
        context = super(MetricDetailView, self).get_context_data()
        context["stage_url"] = self.object.stage.get_json_url()
        context["metric_url"] = reverse("metrics_metric_json", args=[self.object.pk])
        return context