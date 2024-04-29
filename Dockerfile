FROM php:7.4-apache
RUN apt-get update && apt-get install -y \
    libapache2-mod-php7.4 \
    php7.4-mysql \
    default-mysql-client \
    curl \
    sudo \
    && docker-php-ext-install pdo_mysql

# Installation de WordPress
WORKDIR /var/www/html
RUN curl -O https://wordpress.org/latest.tar.gz \
    && tar -xzf latest.tar.gz \
    && mv wordpress/* ./ \
    && rm -rf wordpress latest.tar.gz \
    && chown -R www-data:www-data /var/www/html

# Configuration Apache
RUN a2enmod rewrite
COPY 000-default.conf /etc/apache2/sites-available/000-default.conf

# Installation de WooCommerce
COPY woocommerce-installer.php /var/www/html
RUN php woocommerce-installer.php

# Exposer le port 80
EXPOSE 80
