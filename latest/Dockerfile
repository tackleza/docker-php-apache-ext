FROM php:8.4-apache

RUN set -eux; \
    apt-get update; \
    apt-get install -y --no-install-recommends \
        libfreetype6-dev \
        libjpeg62-turbo-dev \
        libpng-dev \
        libwebp-dev \
        libxpm-dev \
        libzip-dev \
        libicu-dev \
        libkrb5-dev \
        libldap2-dev \
        libtidy-dev \
        libxslt1-dev \
        zlib1g-dev \
        libmagickwand-dev \
        libssl-dev \
        libgmp-dev \
        unzip \
        nano \
        iputils-ping \
        git; \
    \
    # Add old Debian repo for libc-client-dev
    echo "deb http://archive.debian.org/debian buster main" > /etc/apt/sources.list.d/buster.list; \
    apt-get update; \
    apt-get install -y --no-install-recommends libc-client-dev; \
    rm /etc/apt/sources.list.d/buster.list; \
    apt-get update; \
    \
    rm -rf /var/lib/apt/lists/*

RUN docker-php-ext-configure gd \
        --with-freetype \
        --with-jpeg \
        --with-webp \
        --with-xpm \
 && docker-php-ext-install -j"$(nproc)" \
        gd \
        bcmath \
        bz2 \
        calendar \
        exif \
        gettext \
        intl \
        mysqli \
        opcache \
        pcntl \
        pdo \
        pdo_mysql \
        shmop \
        soap \
        sockets \
        sysvmsg \
        sysvsem \
        sysvshm \
        tidy \
        xsl \
        zip \
        gmp

RUN pecl install mongodb imagick imap \
 && docker-php-ext-enable mongodb imagick imap

RUN a2enmod rewrite

COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

RUN chown -R www-data:www-data /var/www

EXPOSE 80
