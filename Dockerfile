# Use an official Python runtime as a parent image
FROM python:3.11-slim-buster

# Add user for the application
RUN useradd wagtail

# Expose the application on port 80
EXPOSE 80

# Set environment variables
ENV PYTHONUNBUFFERED=1 \
    PIPENV_VENV_IN_PROJECT=1 \
    PIPENV_IGNORE_VIRTUALENVS=1 \
    LANG=en_US.UTF-8 \
    PATH="/home/wagtail/.local/bin:${PATH}"

# Install system dependencies
RUN apt-get update --yes --quiet && \
    apt-get install --yes --quiet --no-install-recommends \
    build-essential \
    libpq-dev \
    libmariadb-dev-compat \
    libjpeg62-turbo-dev \
    zlib1g-dev \
    libwebp-dev \
    default-libmysqlclient-dev \
    gcc \
    curl \
    pkg-config \
    apache2 \
    apache2-dev \
    locales && \
    rm -rf /var/lib/apt/lists/* && \
    locale-gen en_US.UTF-8

# Upgrade pip and setuptools
RUN pip install --upgrade pip setuptools

# Install mod_wsgi from source to ensure compatibility with Python 3.11
RUN pip install mod_wsgi

# Install pipenv
RUN pip install pipenv

# Set working directory
WORKDIR /app

# Copy Pipfile and Pipfile.lock
COPY Pipfile Pipfile.lock ./

# Install dependencies using Pipenv
RUN pipenv install --deploy --system

# Copy the source code of the project into the container
COPY --chown=wagtail:wagtail . .

# Copy Apache configuration
COPY apache2.conf /etc/apache2/sites-available/000-default.conf

# Enable Apache modules and configure mod_wsgi
RUN mod_wsgi-express install-module > /etc/apache2/mods-available/wsgi.load && \
    a2enmod wsgi

# Collect static files
RUN python manage.py collectstatic --noinput --clear

# Runtime command
CMD ["sh", "-c", "set -xe; python manage.py migrate --noinput; apache2ctl -D FOREGROUND"]
