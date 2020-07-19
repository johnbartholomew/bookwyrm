#!/bin/bash

set -e

podman pod create --name 'pod-bookwyrm' --hostname='bookwyrm' -p '1333:1333'

podman volume create vol-bookwyrm-postgres
podman volume create vol-bookwyrm-redis
podman volume create vol-bookwyrm-media
podman volume create vol-bookwyrm-static

podman container create \
  --env-file=.env \
  --pod=pod-bookwyrm \
  --volume=vol-bookwyrm-postgres:/var/lib/postgresql/data \
  --name=c-bookwyrm-postgres \
  postgres

podman container create \
  --env-file=.env \
  --pod=pod-bookwyrm \
  --volume=vol-bookwyrm-redis:/data \
  --name=c-bookwyrm-redis \
  redis

podman container create \
  --env-file=.env \
  --pod=pod-bookwyrm \
  --volume=.:/app \
  --name=c-bookwyrm-celery-worker \
  localhost/bookwyrm-main \
  celery -A fr_celery worker -l info

podman container create \
  --env-file=.env \
  --pod=pod-bookwyrm \
  --volume=.:/app \
  --volume=vol-bookwyrm-media:/app/images \
  --volume=vol-bookwyrm-static:/app/static \
  --name=c-bookwyrm-web \
  localhost/bookwyrm-main \
  python manage.py runserver 0.0.0.0:8000

podman container create \
  --env-file=.env \
  --pod=pod-bookwyrm \
  --volume=vol-bookwyrm-media:/app/images \
  --volume=vol-bookwyrm-static:/app/static \
  --name=c-bookwyrm-nginx \
  localhost/bookwyrm-nginx
