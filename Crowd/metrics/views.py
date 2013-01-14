# Create your views here.
from django.views.generic.edit import CreateView
from models import Metric
from django.http import QueryDict

class MetricCreateView(CreateView):
    model = Metric
    success_url = "/"

    def get_form_kwargs(self):
        kwargs = super(MetricCreateView, self).get_form_kwargs()
        qd = kwargs["data"].copy()
        qd.update({"ip_address" : self.request.META['REMOTE_ADDR']})
        kwargs["data"] = qd
        return kwargs
