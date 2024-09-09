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
    PATH="/home/wagtail/.local/bin:${PATH}"

ENV LANG en_US.UTF-8

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
    libapache2-mod-wsgi-py3 && \
    rm -rf /var/lib/apt/lists/*

RUN apt-get update && apt-get install -y locales \
    && locale-gen en_US.UTF-8
# Upgrade pip and setuptools
RUN pip install --upgrade pip setuptools

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

# Enable Apache modules
RUN a2enmod wsgi

# Collect static files
RUN python manage.py collectstatic --noinput --clear

# Runtime command
CMD set -xe; python manage.py migrate --noinput; apache2ctl -D FOREGROUND
