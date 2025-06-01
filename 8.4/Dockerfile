FROM php:8.4-apache

# 1. Install system dependencies for PHP extensions
RUN apt-get update \
 && apt-get install -y \
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
      libc-client-dev \
      libssl-dev \
      libgmp-dev \
      unzip \
      nano \
      iputils-ping \
      git \
 && rm -rf /var/lib/apt/lists/*

# 2. Configure & install built-in PHP extensions in one layer
#    - GD (with freetype, jpeg, webp, xpm)
#    - bcmath, bz2, calendar, exif, gettext, intl, mysqli, opcache,
#      pcntl, pdo, pdo_mysql, shmop, soap, sockets,
#      sysvmsg, sysvsem, sysvshm, tidy, xsl, zip, gmp
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

# 3. Install PECL extensions:
#    - mongodb (PECL)
#    - imagick (PECL)
#    - imap    (PECL, since PHP 8.4 no longer bundles IMAP)
RUN pecl install mongodb imagick imap \
 && docker-php-ext-enable mongodb imagick imap

# 4. Enable Apache rewrite module
RUN a2enmod rewrite

# 5. Copy Composer binary from the official Composer image
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# 6. Fix permissions on /var/www
RUN chown -R www-data:www-data /var/www

EXPOSE 80
