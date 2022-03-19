ARG BUILD_PHP=8.0
ARG BUILD_DATE="develop"
ARG VCS_REF="develop"
ARG APP_ENV=prod
ARG RUN_COMPOSER=true

FROM php:${BUILD_PHP}-fpm-alpine

# The maintainer list
LABEL authors="Ben Smiley <ben@chatsdk.co>"
LABEL org.label-schema.build-date=$BUILD_DATE
LABEL org.label-schema.vcs-ref=$VCS_REF

RUN echo "PHP VERSION: ${PHP_VERSION}"

RUN set -ex && apk --no-cache add postgresql-dev $PHPIZE_DEPS

RUN docker-php-ext-install pdo pdo_pgsql opcache

RUN pecl install xdebug && docker-php-ext-enable xdebug

COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# Add configuration for the phpfpm container
COPY php.ini /usr/local/etc/php/php.ini

# the zzz in the filename, is to make sure this file is loaded last into the configuration
COPY phpfpm.conf /usr/local/etc/php-fpm.d/zzz_phpfpm.conf

# Configure XDEBUG extension and configuration
COPY xdebug.ini /usr/local/etc/php/conf.d/xdebug.ini

# Copy the container entrypoint
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

# Copy the XDebug configuration
COPY xdebug.sh /xdebug.sh
RUN chmod +x /xdebug.sh

EXPOSE 9000
ENTRYPOINT ["/entrypoint.sh"]
CMD ["php-fpm"]

