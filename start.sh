#!/bin/bash
set -e  # Exit on any error

# Wait for database to be ready with timeout
echo "Waiting for database..."
timeout=60
while ! python manage.py check --database default 2>/dev/null; do
  echo "Database is unavailable - sleeping"
  sleep 2
  timeout=$((timeout - 2))
  if [ $timeout -le 0 ]; then
    echo "Database connection timeout"
    exit 1
  fi
done

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
