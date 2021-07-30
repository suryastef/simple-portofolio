# Alpine linux preparation
apk update && apk add git --no-cache
docker-php-ext-install mysqli pdo pdo_mysql
cd /root && git clone --depth=1 https://github.com/suryastef/simple-portofolio.git

# Composer instalation
php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');"
php -r "if (hash_file('sha384', 'composer-setup.php') === '756890a4488ce9024fc62c56153228907f1545c228516cbf63f885e036d37e9a59d27d63f46af1d4d07ee0f76181c7d3') { echo 'Installer verified'; } else { echo 'Installer corrupt'; unlink('composer-setup.php'); } echo PHP_EOL;"
php composer-setup.php
php -r "unlink('composer-setup.php');"
mv composer.phar /usr/local/bin/composer

# Repo instalation
cd /root/simple-portfolio && cp .env.example .env
composer install
php artisan optimize:clear
php artisan key:generate
php artisan migrate
php artisan db:seed

# Running the web service
php artisan serve --host=0.0.0.0 --port=8000