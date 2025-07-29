FROM python:3.9-slim

# Install system dependencies
RUN apt-get update && \
    apt-get install -y gcc libpq-dev tesseract-ocr && \
    rm -rf /var/lib/apt/lists/*

# Set work directory
WORKDIR /app

# Copy requirements
COPY ../requirements.txt /app/requirements.txt
COPY ../requirements /app/requirements

# Install Python dependencies
RUN pip install --upgrade pip && \
    pip install -r requirements.txt

# Copy project files
COPY .. /app

# Expose port
EXPOSE 8000

# Default command (adjust if you use a different entrypoint)
CMD ["gunicorn", "--bind", "0.0.0.0:8000", "mayan.wsgi"]
