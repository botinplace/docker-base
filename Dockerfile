FROM php:8.4-fpm

COPY ./config/www.conf /usr/local/etc/php-fpm.d/www.conf 

# Установка зависимости, Git и unzip (для Composer)
RUN apt-get update && apt-get install -y \
    git \
    unzip \
    && rm -rf /var/lib/apt/lists/*

# Установка Composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# Установка расширения Redis
RUN pecl install redis && docker-php-ext-enable redis


# Создание директории для сокета
RUN mkdir -p /var/run/php

# Копирование конфигурации PHP-FPM
COPY ./config/www.conf /usr/local/etc/php-fpm.d/www.conf

# Команда для запуска PHP-FPM
CMD ["php-fpm"]


#listen = /var/run/php/php-fpm.sock
# Настройка PHP-FPM для использования Unix сокета
RUN sed -i 's|^listen =.*|listen = /var/run/php/php-fpm.sock|g' /usr/local/etc/php-fpm.d/zz-docker.conf
#RUN sed -i 's|^listen =.*|listen = /var/run/php/php-fpm.sock|g' /usr/local/etc/php-fpm.d/www.conf && \
#    echo "listen.owner = www-data" >> /usr/local/etc/php-fpm.d/www.conf && \
#   echo "listen.group = www-data" >> /usr/local/etc/php-fpm.d/www.conf && \
#    echo "listen.mode = 0660" >> /usr/local/etc/php-fpm.d/www.conf

# Создание директории для сокета
#RUN mkdir -p /var/run/php

#RUN mkdir -p /var/run/php \
#    && chown -R www-data:www-data /var/run/php

#RUN mkdir -p /var/log/php-fpm && \
#    touch /var/log/php-fpm/php-fpm.log && \
#    chmod 666 /var/log/php-fpm/php-fpm.log

#RUN mkdir -p /var/run/php && \
    #chown -R www-data:www-data /var/run/php

# Команда для запуска PHP-FPM
#CMD ["php-fpm"]