import os
import sys

from django.core.wsgi import get_wsgi_application

# Add the app directory to the Python path
app_path = os.path.abspath(os.path.join(os.path.dirname(os.path.abspath(__file__)), '..'))
sys.path.append(app_path)

os.environ.setdefault("DJANGO_SETTINGS_MODULE", "core.settings.production")

application = get_wsgi_application()
