FROM php:8.4-fpm

# Установка зависимости, Git и unzip (для Composer)
RUN apt-get update && apt-get install -y \
    git \
    unzip \
    && rm -rf /var/lib/apt/lists/*

# Установка Composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# Установка расширения Redis
RUN pecl install redis && docker-php-ext-enable redis