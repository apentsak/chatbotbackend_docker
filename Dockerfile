FROM php:8-apache

RUN apt-get update

#INSTALL LIBRARIES
RUN apt-get install -y \
        libfreetype6-dev \
        libmcrypt-dev \
        libssl-dev \
        libz-dev \
        libzip-dev \
        libonig-dev \
        libpq-dev

#INSTALL APPLICATIONS
RUN apt-get install -y \
        dos2unix \
        curl \
        git \
        ssh \
        unzip \
        nano

#CLEAR LEFTOUT FILES
RUN apt-get autoremove -y \
    && apt-get clean -y \
    && rm -rf /var/lib/apt/lists/* \
        /tmp/* \
        /var/tmp/*

#INSTALL PHP-EXTENSIONS
RUN pecl install xdebug \
    && docker-php-ext-enable xdebug
RUN docker-php-ext-install \
        pdo_mysql \
        mysqli \
        mbstring \
        bcmath \
        zip \
        gd

WORKDIR /application

#SETUP CONFIGS
COPY config/backend/php/php.ini /usr/local/etc/php/conf.d/
COPY config/backend/php/opcache/opcache.local.ini /usr/local/etc/php/conf.d/opcache.ini

#INSTALL COMPOSER
RUN php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');" \
            && php composer-setup.php --install-dir=/usr/local/bin --filename=composer \
                && rm -rf composer-setup.php
                
RUN a2enmod rewrite
