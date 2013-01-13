from django.conf.urls import patterns, include, url
from views import IndexView

# Uncomment the next two lines to enable the admin:
from django.contrib import admin
admin.autodiscover()

urlpatterns = patterns('',
    # Examples:
    # url(r'^$', 'Crowd.views.home', name='home'),
    # url(r'^Crowd/', include('Crowd.foo.urls')),

    # Uncomment the admin/doc line below to enable admin documentation:
    # url(r'^admin/doc/', include('django.contrib.admindocs.urls')),

    # Uncomment the next line to enable the admin:
    url(r'^admin/', include(admin.site.urls)),
    url(r'^$', IndexView.as_view(), name='index'),
)

from django.conf import settings
if settings.DEBUG:
    import os.path
    document_root = lambda x: os.path.join(os.path.dirname(__file__), '../static', x)
    urlpatterns += patterns('django.views.static',
                            (r'^favicon.ico$', 'serve', {'document_root': document_root(''), 'path': 'favicon.ico'}),
                            (r'^apple-touch-icon.png$', 'serve', {'document_root': document_root(''), 'path': 'apple-touch-icon.png'}),
                            (r'^css/(?P<path>.*)$', 'serve', {'document_root': document_root('css')}),
                            (r'^javascript/(?P<path>.*)$', 'serve', {'document_root': document_root('javascript')}),
                            (r'^image/(?P<path>.*)$', 'serve', {'document_root': document_root('image')}),
                            (r'^storage/(?P<path>.*)$', 'serve', {'document_root': document_root('storage')}),
    )
