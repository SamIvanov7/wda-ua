from django.urls import path
from . import models

urlpatterns = [
    path('', models.ProjectIndex.as_view(), name='projects'),  # Make sure name is 'projects'
]