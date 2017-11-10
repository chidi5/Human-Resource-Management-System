from django.conf.urls import url
from . import views

urlpatterns = [
    url(r'^$', views.log_in),
    url(r'^login/$', views.log_in, name = 'login'),
    url(r'^auth/$', views.auth, name = 'auth'),
    url(r'^home/$', views.home, name = 'home'),
    url(r'^make_payment/$', views.make_payment, name = 'make_payment'),
    url(r'^payment/$', views.payment, name = 'payment'),
    url(r'^employees/$', views.employees, name = 'employees'),
    url(r'^update_employee/$', views.update_employee, name = 'update_employee'),
    url(r'^contracts/$', views.contracts, name = 'contracts'),
    url(r'^leave/$', views.leave, name = 'leave'),
    url(r'^loan/$', views.loan, name = 'loan'),
    url(r'^orders/$', views.orders, name = 'orders'),
    url(r'^transfers/$', views.transfers, name = 'transfers'),
    url(r'^logout/$', views.deauth, name='deauth'),
]
