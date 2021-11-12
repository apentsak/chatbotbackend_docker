# cp .env.example .env
# printf '\n%s\n' 'APP_ENV=local' >> .env
# printf '\n%s\n' 'APP_DEBUG=true' >> .env

#chown -R www-data:www-data /application
#for dev usage
#chmod -R 777 /application

composer install -n

# php artisan migrate
# php artisan optimize:clear
php artisan key:generate
php artisan migrate
php artisan db:seed

# Keep php-process alive
# exec supervisord -c /etc/supervisor/sv.conf


# Apache gets grumpy about PID files pre-existing
rm -f /var/run/apache2/apache2.pid

# Start Apache in foreground
/usr/sbin/apachectl -DFOREGROUND
