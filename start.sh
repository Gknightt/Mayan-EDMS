#!/bin/bash
set -e

# Railway will provide PORT automatically
export PORT=${PORT:-8000}

# Debug info
echo "=== Mayan EDMS Railway Deployment ==="
echo "Port: $PORT"
echo "MAYAN_DATABASES: $MAYAN_DATABASES"
echo "================================="

# Wait for database to be ready with timeout
echo "Waiting for database..."
timeout=120
attempt=1

while ! python manage.py check --database default 2>&1; do
  echo "Database is unavailable - sleeping (attempt $attempt)"
  sleep 5
  timeout=$((timeout - 5))
  attempt=$((attempt + 1))
  
  if [ $timeout -le 0 ]; then
    echo "Database connection timeout after $attempt attempts"
    python manage.py check --database default
    exit 1
  fi
done

echo "Database connection successful!"

# Run migrations
echo "Running migrations..."
python manage.py migrate --noinput

# Create superuser if it doesn't exist
echo "Setting up initial data..."
python manage.py initialsetup --no-dependencies || echo "Initial setup already completed"

# Collect static files
echo "Collecting static files..."
python manage.py collectstatic --noinput --clear

# Start the application
echo "Starting Mayan EDMS on port $PORT..."
exec gunicorn --bind 0.0.0.0:$PORT --workers 3 --timeout 120 --max-requests 1000 mayan.wsgi:application
