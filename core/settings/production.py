import os
import environ

from .base import *

# Change it to your config file path
config_file = "."

env = environ.Env(
    # Set default values for required environment variables
    DEBUG=(bool, False),
    SECRET_KEY=(str, 'default-secret-key-for-development-only'),
    HOST=(str, '159.89.22.211'),
    PUBLIC_DIR=(str, os.path.join(BASE_DIR, 'public'))
)

# Read the .env file
environ.Env.read_env(os.path.join(config_file, ".env"))

DEBUG = env('DEBUG')
SECRET_KEY = env('SECRET_KEY')

HOST = env('HOST')
ALLOWED_HOSTS = [
    HOST,
    'localhost',
    'web',
    '159.89.22.211',
]

SECURE_SSL_REDIRECT = True

LOGGING = {
    'version': 1,
    'disable_existing_loggers': False,
    'handlers': {
        'console': {
            'class': 'logging.StreamHandler',
        },
    },
    'root': {
        'handlers': ['console'],
        'level': 'WARNING',
    },
}

PUBLIC_DIR = env("PUBLIC_DIR")

STATIC_ROOT = os.path.join(PUBLIC_DIR, "crisp_static")
STATIC_URL = "/crisp_static/"

MEDIA_ROOT = os.path.join(PUBLIC_DIR, "crisp_media")
MEDIA_URL = "/crisp_media/"

# settings.py
DATABASES = {
    'default': {
        'ENGINE': 'django.db.backends.mysql',
        'NAME': os.environ.get('MYSQL_DATABASE', 'wda_db'),
        'USER': os.environ.get('MYSQL_USER', 'wda_db_user'),
        'PASSWORD': os.environ.get('MYSQL_PASSWORD', 'wda_db_password'),
        'HOST': os.environ.get('MYSQL_HOST', 'db'),
        'PORT': os.environ.get('MYSQL_PORT', '3306'),
    }
}

CACHES = {
    "default": {
        "BACKEND": "django_redis.cache.RedisCache",
        "LOCATION": "redis://redis:6379/1",
        "OPTIONS": {
            "CLIENT_CLASS": "django_redis.client.DefaultClient",
        },
    }
}

REDIS_PAGE_STATICS_SERVICE_NAME = "codingdz:pages_statistics"

SILENCED_SYSTEM_CHECKS = [
    "captcha.recaptcha_test_key_error",
]

try:
    from .local import *
except ImportError:
    pass
