FROM python:3.12-slim-bullseye AS builder

ENV PYTHONDONTWRITEBYTECODE 1
ENV PYTHONUNBUFFERED 1

RUN apt-get update \
    && apt-get install -y build-essential libpq-dev \
    && apt-get clean

RUN python -m venv /opt/venv

COPY requirements.txt .
RUN /opt/venv/bin/pip install --upgrade pip \
    && /opt/venv/bin/pip install --no-cache-dir -r requirements.txt

FROM python:3.12-slim-bullseye AS final


ENV PYTHONDONTWRITEBYTECODE 1
ENV PYTHONUNBUFFERED 1


RUN addgroup --system django \
    && adduser --system --ingroup django django

COPY --from=builder /opt/venv /opt/venv


WORKDIR /app
COPY . .
RUN chown -R django:django /app


USER django


EXPOSE 8000


CMD ["/opt/venv/bin/python", "-m", "gunicorn", "gts_django.wsgi:application", "--bind", "0.0.0.0:8000", "--workers", "4", "--log-level", "info"]