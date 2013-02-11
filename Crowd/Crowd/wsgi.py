"""
WSGI config for Crowd project.

This module contains the WSGI application used by Django's development server
and any production WSGI deployments. It should expose a module-level variable
named ``application``. Django's ``runserver`` and ``runfcgi`` commands discover
this application via the ``WSGI_APPLICATION`` setting.

Usually you will have the standard Django WSGI application here, but it also
might make sense to replace the whole Django WSGI application with a custom one
that later delegates to the Django one. For example, you could introduce WSGI
middleware here, or combine a Django application with an application of another
framework.

"""
import os
import sys
# Activate virtualenv
virtualenv = os.path.join(os.path.dirname(__file__), '../env')
if os.path.exists(virtualenv):
    activate_this = os.path.join(virtualenv, 'bin/activate_this.py')
    execfile(activate_this, dict(__file__=activate_this))

# Append Kawaz to the PYTHONPATH
path_list = [
    os.path.dirname(__file__),
    os.path.join(os.path.dirname(__file__), '../'),
    os.path.join(os.path.dirname(__file__), '../../'),
]
for path in path_list:
    if path not in sys.path:
        sys.path.append(path)

# import django.core.handlers.wsgi
# application = django.core.handlers.wsgi.WSGIHandler()

os.environ.setdefault("DJANGO_SETTINGS_MODULE", "Crowd.settings")

# This application object is used by any WSGI server configured to use this
# file. This includes Django's development server, if the WSGI_APPLICATION
# setting points here.
from django.core.wsgi import get_wsgi_application
application = get_wsgi_application()

# Apply WSGI middleware here.
# from helloworld.wsgi import HelloWorldApplication
# application = HelloWorldApplication(application)
