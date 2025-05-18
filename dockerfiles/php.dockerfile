FROM php:8-fpm-alpine

ARG UID
ARG GID

ENV UID=${UID}
ENV GID=${GID}

# Устанавливаем системные зависимости
RUN apk add --no-cache --virtual .build-deps \
        autoconf \
        g++ \
        make \
        linux-headers \
    && pecl install redis \
    && docker-php-ext-enable redis \
    && apk del .build-deps

# Настраиваем PHP для игнорирования предупреждений
RUN echo "error_reporting = E_ALL & ~E_DEPRECATED & ~E_WARNING & ~E_NOTICE" >> /usr/local/etc/php/conf.d/error_reporting.ini && \
    echo "display_errors = Off" >> /usr/local/etc/php/conf.d/error_reporting.ini && \
    echo "log_errors = On" >> /usr/local/etc/php/conf.d/error_reporting.ini

RUN mkdir -p /var/www/html
WORKDIR /var/www/html

COPY --from=composer:latest /usr/bin/composer /usr/local/bin/composer

# Настройка пользователя
RUN delgroup dialout
RUN addgroup -g ${GID} --system laravel
RUN adduser -G laravel --system -D -s /bin/sh -u ${UID} laravel

# Настройка PHP-FPM
RUN sed -i "s/user = www-data/user = laravel/g" /usr/local/etc/php-fpm.d/www.conf
RUN sed -i "s/group = www-data/group = laravel/g" /usr/local/etc/php-fpm.d/www.conf
RUN echo "php_admin_flag[log_errors] = on" >> /usr/local/etc/php-fpm.d/www.conf

# Установка базовых расширений
RUN docker-php-ext-install pdo pdo_mysql
    
USER laravel

CMD ["php-fpm", "-y", "/usr/local/etc/php-fpm.conf", "-R"]