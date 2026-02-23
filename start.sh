#!/bin/bash
set -e

echo "=== Starting Application ==="
echo "APP_ENV: $APP_ENV"
echo "APP_DEBUG: $APP_DEBUG"
echo "APP_KEY set: $([ -n "$APP_KEY" ] && echo 'YES' || echo 'NO')"
echo "DB_HOST: $DB_HOST"
echo "DB_PORT: $DB_PORT"
echo "DB_DATABASE: $DB_DATABASE"

# Clear old config cache
php artisan config:clear

# Run migrations
php artisan migrate --force || echo "Migration failed, continuing..."

# Clear log and tail it in background so errors show in deploy logs
> storage/logs/laravel.log
tail -f storage/logs/laravel.log &

# Start server
echo "=== Starting PHP Server on port ${PORT:-8080} ==="
php -S 0.0.0.0:${PORT:-8080} -t public
