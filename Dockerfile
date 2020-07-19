FROM python:3
ENV  PYTHONUNBUFFERED 1
RUN mkdir /app /app/static /app/images
WORKDIR /app
COPY requirements.txt /app/
RUN pip install -r requirements.txt
COPY ./fedireads /app
COPY ./fr_celery /app
