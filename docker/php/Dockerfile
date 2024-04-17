### Vendor init composer
FROM composer:latest as vendor
COPY ./../app/composer.json ./../app/composer.lock /app/
RUN composer install --no-dev --optimize-autoloader --ignore-platform-reqs --working-dir=/app

### base
FROM php:8.1-fpm-alpine as base
RUN apk add \
    icu-dev \
    gettext \
    gettext-dev \
    gcc \
    make \
    autoconf \
    && docker-php-ext-install \
    pdo \
    pdo_mysql \
    intl \
    gettext
RUN pecl channel-update pecl.php.net

COPY ./php/default.conf /etc/php/8.1/fpm/pool.d/default.conf
COPY ./php/php.ini /etc/php/8.1/fpm/php.ini
COPY ./php/bin/php-healtcheck.sh /usr/local/bin/php-healtcheck.sh

HEALTHCHECK --interval=30s --timeout=10s --start-period=5s --retries=3 CMD ["/usr/local/bin/php-healtcheck.sh"]

### Stable
FROM base as stable
COPY ./../app/ /var/www/html/
COPY --from=vendor ../app/vendor /var/www/html/vendor
RUN apt-get clean -y && rm -rf /var/lib/apt/lists/*

### Development
FROM base as devel
ARG DIR_LOG
ARG PHP_PORT

RUN apk add --no-cache --virtual .build-deps $PHPIZE_DEPS && \
    apk add --update linux-headers && \ 
    pecl install xdebug-3.1.5 && \ 
    docker-php-ext-enable xdebug

COPY ./php/xdebug.ini /etc/php/8.1/fpm/conf.d/xdebug.ini
RUN sed -i "s|DIR_LOG|${DIR_LOG}|g" /etc/php/8.1/fpm/conf.d/xdebug.ini && \
    sed -i "s|PHP_PORT|${PHP_PORT}|g" /etc/php/8.1/fpm/conf.d/xdebug.ini

### Development
FROM devel as local
