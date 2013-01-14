# Create your views here.
from django.views.generic.edit import CreateView
from models import Operation
from django.forms.models import model_to_dict
from Crowd.views import JSONResponseMixin

class OperationCreateView(JSONResponseMixin, CreateView):
    model = Operation
    success_url = "/"

    def form_valid(self, form):
        super(OperationCreateView, self).form_valid(form)
        d = model_to_dict(self.object)
        d.update({'pk' : self.object.pk})
        return self.get_json_response(self.convert_context_to_json(d))
