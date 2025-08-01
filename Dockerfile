FROM python:3.9-slim

# Install system dependencies
RUN apt-get update && \
    apt-get install -y gcc libpq-dev tesseract-ocr \
    libsasl2-dev python3-dev libldap2-dev libssl-dev \
    poppler-utils \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app

# Copy requirements first (for better Docker caching)
COPY requirements.txt /app/requirements.txt
COPY requirements/ /app/requirements/

# Install Python dependencies
RUN pip install --upgrade pip && \
    pip install -r requirements.txt

# Copy the entire application
COPY . /app

# Copy and setup start script
COPY start.sh /app/start.sh
RUN chmod +x /app/start.sh

# Create media directory
RUN mkdir -p /app/media

# Expose port
EXPOSE 8000

# Use the start script
CMD ["/app/start.sh"]
