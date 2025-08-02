# Wait for database to be ready
echo "Waiting for database..."
python manage.py check --database default

# Run migrations
echo "Running migrations..."
python manage.py migrate

# Create superuser if it doesn't exist
echo "Setting up initial data..."
python manage.py initialsetup --no-dependencies

# Collect static files
echo "Collecting static files..."
python manage.py collectstatic --noinput

# Start the application
echo "Starting Mayan EDMS..."
exec gunicorn --bind 0.0.0.0:$PORT --workers 3 --timeout 120 mayan.wsgi
