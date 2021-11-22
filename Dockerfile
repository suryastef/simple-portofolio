FROM php:7.3-fpm-alpine
WORKDIR /app
ADD . /app

# Composer instalation
RUN cp .env.example .env && \
    php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');" && \
    php -r "if (hash_file('sha384', 'composer-setup.php') === '906a84df04cea2aa72f40b5f787e49f22d4c2f19492ac310e8cba5b96ac8b64115ac402c8cd292b8a03482574915d1a8') { echo 'Installer verified'; } else { echo 'Installer corrupt'; unlink('composer-setup.php'); } echo PHP_EOL;" && \
    php composer-setup.php && \
    php -r "unlink('composer-setup.php');" && \
    mv composer.phar /usr/local/bin/composer

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