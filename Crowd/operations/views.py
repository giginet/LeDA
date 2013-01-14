# Create your views here.
from django.views.generic.edit import CreateView
from models import Operation

class OperationCreateView(CreateView):
    model = Operation