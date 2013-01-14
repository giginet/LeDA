# Create your views here.
from django.views.generic.edit import CreateView
from models import Metric
from django.http import QueryDict
from django.forms.models import model_to_dict
from Crowd.views import JSONResponseMixin

class MetricCreateView(CreateView, JSONResponseMixin):
    model = Metric
    success_url = "/"

    def get_form_kwargs(self):
        kwargs = super(MetricCreateView, self).get_form_kwargs()
        qd = kwargs["data"].copy()
        qd.update({"ip_address" : self.request.META['REMOTE_ADDR']})
        kwargs["data"] = qd
        return kwargs

    def form_valid(self, form):
        super(MetricCreateView, self).form_valid(form)
        d = model_to_dict(self.object)
        d.update({'pk' : self.object.pk})
        return self.get_json_response(self.convert_context_to_json(d))