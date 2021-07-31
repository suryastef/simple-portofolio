FROM php:7.3-fpm-alpine
WORKDIR /app
ADD . /app

# Composer instalation
RUN cp .env.example .env && \
    php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');" && \
    php -r "if (hash_file('sha384', 'composer-setup.php') === '756890a4488ce9024fc62c56153228907f1545c228516cbf63f885e036d37e9a59d27d63f46af1d4d07ee0f76181c7d3') { echo 'Installer verified'; } else { echo 'Installer corrupt'; unlink('composer-setup.php'); } echo PHP_EOL;" && \
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
COPY ./run.sh /tmp
ENTRYPOINT ["/tmp/run.sh"]