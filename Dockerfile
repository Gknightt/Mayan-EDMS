FROM python:3.10-slim

# System dependencies
RUN apt-get update && apt-get install -y \
    gcc \
    libpq-dev \
    curl \
    python3-dev \
    libmagic1 \
    tesseract-ocr \
    ghostscript \
    libjpeg-dev \
    zlib1g-dev \
    libffi-dev \
    libssl-dev \
    poppler-utils \
    && rm -rf /var/lib/apt/lists/*

# Set workdir
WORKDIR /app

# Copy your Mayan EDMS source code (cloned from GitHub)
COPY . /app

# Install dependencies
RUN pip install --upgrade pip
RUN pip install -r requirements.txt

# Environment setup
ENV MAYAN_MEDIA_ROOT=/var/lib/mayan
ENV DJANGO_SETTINGS_MODULE=mayan.settings.production

# Port exposure
EXPOSE 8000

# Run migrations and launch
CMD ["sh", "-c", "python manage.py migrate && python manage.py runserver 0.0.0.0:8000"]
