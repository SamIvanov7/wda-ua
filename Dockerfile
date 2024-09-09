# Use an official Python runtime based on Debian 10 "buster" as a parent image.
FROM python:3.9.1-slim-buster

# Add user that will be used in the container.
RUN useradd wagtail

# Port used by this container to serve HTTP.
EXPOSE 80

# Set environment variables.
ENV PYTHONUNBUFFERED=1 \
    PORT=80 \
    PIPENV_VENV_IN_PROJECT=1 \
    PIPENV_IGNORE_VIRTUALENVS=1 \
    PATH="/home/wagtail/.local/bin:${PATH}" \
    PYTHONPATH="/usr/local/lib/python3.8/site-packages:${PYTHONPATH}"

# Install system packages required by Wagtail and Django.
RUN apt-get update --yes --quiet && apt-get install --yes --quiet --no-install-recommends \
    build-essential \
    libpq-dev \
    libmariadbclient-dev \
    libjpeg62-turbo-dev \
    zlib1g-dev \
    libwebp-dev \
    default-libmysqlclient-dev \
    gcc \
    curl \
    pkg-config \
    apache2 \
    apache2-dev \
    libapache2-mod-wsgi-py3 \
    && rm -rf /var/lib/apt/lists/*

RUN pip install --upgrade pip
RUN pip install --upgrade setuptools
# Install pipenv
RUN pip install pipenv

# Use /app folder as a directory where the source code is stored.
WORKDIR /app

# Copy Pipfile and Pipfile.lock
COPY Pipfile Pipfile.lock ./

# Install dependencies using Pipenv
RUN pipenv install --deploy --system

# Install backports.zoneinfo for Python 3.8
RUN pip install backports.zoneinfo

# Create necessary directories and set permissions
RUN mkdir -p /app/public /var/log/apache2 /var/run/apache2 /home/wagtail && \
    chown -R wagtail:wagtail /app /var/log/apache2 /var/run/apache2 /etc/apache2 /home/wagtail && \
    chmod 755 /app /var/log/apache2 /var/run/apache2 /home/wagtail

# Copy the source code of the project into the container.
COPY --chown=wagtail:wagtail . .

# Copy Apache configuration
COPY apache2.conf /etc/apache2/sites-available/000-default.conf

# Enable Apache modules
RUN a2enmod wsgi

# Collect static files.
RUN python manage.py collectstatic --noinput --clear

# Runtime command
CMD set -xe; python manage.py migrate --noinput; apache2ctl -D FOREGROUND
