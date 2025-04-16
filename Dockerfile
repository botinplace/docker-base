FROM php:8.4-fpm

COPY ./config/www.conf /usr/local/etc/php-fpm.d/www.conf 

# Установка зависимости, Git и unzip (для Composer), библиотека для LDAP
RUN apt-get update && apt-get install -y \
    git \
    unzip \
    libldap2-dev \
    libsasl2-dev \
    && rm -rf /var/lib/apt/lists/*

# Установка Composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# Установка расширения Redis
RUN pecl install redis && docker-php-ext-enable redis

# Установка расширения LDAP
#RUN docker-php-ext-configure ldap --with-ldap=/usr/include/ && \
#    docker-php-ext-install ldap

# Установка расширения LDAP
RUN docker-php-ext-install ldap

# Создание директории для сокета
RUN mkdir -p /var/run/php

# Копирование конфигурации PHP-FPM
COPY ./config/www.conf /usr/local/etc/php-fpm.d/www.conf

# Команда для запуска PHP-FPM
CMD ["php-fpm"]

# Настройка PHP-FPM для использования Unix сокета
RUN sed -i 's|^listen =.*|listen = /var/run/php/php-fpm.sock|g' /usr/local/etc/php-fpm.d/zz-docker.conf
