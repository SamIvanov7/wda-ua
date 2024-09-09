# Use an official Python runtime based on Debian 10 "buster" as a parent image.
FROM python:3.8.1-slim-buster

# Add user that will be used in the container.
RUN useradd wagtail

# Port used by this container to serve HTTP.
EXPOSE 8000

# Set environment variables.
ENV PYTHONUNBUFFERED=1 \
    PORT=8000 \
    PIPENV_VENV_IN_PROJECT=1 \
    PIPENV_IGNORE_VIRTUALENVS=1 \
    PATH="/home/wagtail/.local/bin:${PATH}"

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
    && rm -rf /var/lib/apt/lists/*

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

# Explicitly install gunicorn
RUN pip install gunicorn

# Create public directory and set permissions
RUN mkdir -p /app/public && chown wagtail:wagtail /app/public && chmod 777 /app/public

# Set this directory to be owned by the "wagtail" user.
RUN chown wagtail:wagtail /app

# Copy the source code of the project into the container.
COPY --chown=wagtail:wagtail . .

# Use user "wagtail" to run the build commands below and the server itself.
USER wagtail

# Collect static files.
RUN python manage.py collectstatic --noinput --clear

# Runtime command
CMD set -xe; python manage.py migrate --noinput; gunicorn core.wsgi:application
