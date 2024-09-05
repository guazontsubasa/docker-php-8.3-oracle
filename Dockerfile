FROM php:8.3-apache
# servidor para desarrollo 
# crear docker-compose.yml, 
# y una carpeta ssl dentro con los certificados con nombre 'server.crt' y 'server.key'
# creados con mkcert o openssl
#
# services:
  #   app:
  #     container_name: server
  #     image: server
  #     ports:
  #       - 80:80
  #       - 443:443
  #     volumes:
  #       - ../:/var/www/html/public
  #       - ./ssl:/etc/apache2/ssl/cert


LABEL maintainer="Leandro Pocai <leandropocai@gmail.com>"

ADD oracle/instantclient-basic-linux.x64-12.2.0.1.0.tar.gz /usr/local
ADD oracle/instantclient-sdk-linux.x64-12.2.0.1.0.tar.gz /usr/local
ADD oracle/instantclient-sqlplus-linux.x64-12.2.0.1.0.tar.gz /usr/local

RUN apt-get update && apt-get -y install libzip-dev \
  && ln -s /usr/local/instantclient_12_2 /usr/local/instantclient \
  && ln -s /usr/local/instantclient/libclntsh.so.* /usr/local/instantclient/libclntsh.so \
  && ln -s /usr/local/instantclient/lib* /usr/lib \
  && ln -s /usr/local/instantclient/sqlplus /usr/bin/sqlplus \
  && chmod 755 -R /usr/local/instantclient \
  && docker-php-ext-configure oci8 --with-oci8=instantclient,/usr/local/instantclient \
  && docker-php-ext-install oci8 \
  && docker-php-ext-install pdo_mysql exif opcache \
  && apt-get install -y libicu-dev libaio-dev libxml2-dev libjpeg-dev libpng-dev libfreetype6-dev \
  && apt-get install -y curl git \
  && docker-php-ext-install intl soap dom \
  && docker-php-ext-configure gd --with-freetype --with-jpeg \
  && docker-php-ext-install gd \
  && docker-php-ext-install zip \
  && curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer \
  && apt-get install -y micro \
  && docker-php-ext-install sockets \
  && apt-get install -y imagemagick \
  && apt-get purge -y --auto-remove \
  && apt-get clean -y \
  && rm -rf /var/lib/apt/lists/* \
  && mkdir -p /var/www/html/public \
  && mkdir -p /etc/apache2/ssl/cert \
  && a2enmod ssl \  
  && a2enmod headers rewrite

WORKDIR /var/www/html

COPY apache/000-default.conf /etc/apache2/sites-available/000-default.conf
COPY apache/charset.conf /etc/apache2/conf-available/charset.conf
COPY php/timezone.ini /usr/local/etc/php/conf.d/timezone.ini
COPY php/vars-pro.ini /usr/local/etc/php/conf.d/vars.ini

RUN a2ensite 000-default.conf

RUN cp -f "/usr/local/etc/php/php.ini-production" /usr/local/etc/php/php.ini
