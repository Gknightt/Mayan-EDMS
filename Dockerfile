FROM python:3.9-slim

RUN apt-get update && \
    apt-get install -y gcc libpq-dev tesseract-ocr \
    libsasl2-dev python3-dev libldap2-dev libssl-dev \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app

COPY /requirements.txt /app/requirements.txt
COPY /requirements /app/requirements

RUN pip install --upgrade pip && \
    pip install -r requirements.txt

COPY .. /app

RUN python manage.py collectstatic --noinput || true

EXPOSE 8000

CMD ["gunicorn", "--bind", "0.0.0.0:8000", "mayan.wsgi"]
