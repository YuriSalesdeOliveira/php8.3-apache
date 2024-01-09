FROM php:8.3-apache

SHELL ["/bin/bash", "-c"]

RUN apt-get update \
    && apt-get install -y libfreetype-dev libjpeg62-turbo-dev libpng-dev libwebp-dev libgif-dev libzip-dev

RUN docker-php-ext-configure gd --with-freetype --with-jpeg \
    && docker-php-ext-install gd bcmath pdo_mysql zip

RUN php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');" \
    && php -r "if (hash_file('sha384', 'composer-setup.php') === 'e21205b207c3ff031906575712edab6f13eb0b361f2085f1f1237b7126d785e826a450292b6cfd1d64d92e6563bbde02') { echo 'Installer verified'; } else { echo 'Installer corrupt'; unlink('composer-setup.php'); } echo PHP_EOL;" \
    && php composer-setup.php \
    && php -r "unlink('composer-setup.php');" \
    && mv composer.phar /usr/local/bin/composer

RUN curl -fsSL https://deb.nodesource.com/setup_14.x | bash - \
    && apt-get install -y nodejs \
    && npm install -g gulp-cli

RUN a2enmod rewrite
RUN a2enmod actions
