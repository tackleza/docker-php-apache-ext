FROM php:8.3-apache

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
 && docker-php-ext-configure imap --with-kerberos --with-imap-ssl \
 && docker-php-ext-install -j"$(nproc)" \
        gd \
        bcmath \
        bz2 \
        calendar \
        exif \
        gettext \
        imap \
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

RUN pecl install https://pecl.php.net/get/mongodb \
                 https://pecl.php.net/get/imagick \
                 https://pecl.php.net/get/redis \
 && docker-php-ext-enable mongodb imagick redis

RUN a2enmod rewrite

COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

COPY docker-entrypoint.sh /usr/local/bin/docker-entrypoint.sh
RUN chmod +x /usr/local/bin/docker-entrypoint.sh

EXPOSE 80
ENTRYPOINT ["/usr/local/bin/docker-entrypoint.sh"]
