FROM php:8.4-fpm

COPY ./config/www.conf /usr/local/etc/php-fpm.d/www.conf 

# Установка зависимости, Git и unzip (для Composer), библиотека для LDAP, PostgreSQL
RUN apt-get -o Acquire::http::Timeout=60 update && \
    apt-get -o Acquire::http::Timeout=60 install -y --fix-missing \
    git \
    unzip \
    libldap2-dev \
    libsasl2-dev \
    libpq-dev \
    libzip-dev \
    libreoffice \
    libpng-dev \
    libjpeg-dev \
    libfreetype6-dev \
    && rm -rf /var/lib/apt/lists/*

# Установка Composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# Установка расширения Redis
RUN pecl install redis && docker-php-ext-enable redis

# Настройка и установка GD
RUN docker-php-ext-configure gd --with-freetype --with-jpeg
RUN docker-php-ext-install -j$(nproc) gd

# Установка PHP-расширений LDAP PostgreSQL ZIP
RUN docker-php-ext-install \
    pdo pdo_pgsql pgsql \
    ldap \
    zip  

# Создание директории для сокета
RUN mkdir -p /var/run/php

# Копирование конфигурации PHP-FPM
COPY ./config/www.conf /usr/local/etc/php-fpm.d/www.conf

# Команда для запуска PHP-FPM
CMD ["php-fpm"]

# Настройка PHP-FPM для использования Unix сокета
RUN sed -i 's|^listen =.*|listen = /var/run/php/php-fpm.sock|g' /usr/local/etc/php-fpm.d/zz-docker.conf
