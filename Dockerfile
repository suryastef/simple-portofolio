FROM php:7.3-fpm-alpine
WORKDIR /app
ADD . /app

# Composer instalation
COPY --from=composer /usr/bin/composer /usr/bin/composer

# preparing project
RUN docker-php-ext-install mysqli pdo pdo_mysql && \
    composer install && \
    php artisan optimize:clear && \
    php artisan key:generate

# Running the web service
EXPOSE 80
COPY run.sh /tmp
RUN ["chmod", "+x", "/tmp/run.sh"]
ENTRYPOINT ["/tmp/run.sh"]