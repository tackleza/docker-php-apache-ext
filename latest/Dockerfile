FROM php:8.4-apache

# 1. Install system dependencies for PHP extensions
# Replaced libc-client-dev with uw-mailutils
RUN apt-get update \
 && apt-get install -y --no-install-recommends \
      libfreetype-dev \
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
      uw-mailutils \
      libssl-dev \
      libgmp-dev \
      unzip \
      nano \
      iputils-ping \
      git \
 && rm -rf /var/lib/apt/lists/*

# 2. Configure & install built-in PHP extensions
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

# 3. Configure & install IMAP extension using the official helpers
RUN docker-php-ext-configure imap --with-kerberos --with-imap-ssl \
 && docker-php-ext-install -j"$(nproc)" imap

# 4. Install other PECL extensions
RUN pecl install mongodb imagick \
 && docker-php-ext-enable mongodb imagick

# 5. Enable Apache rewrite module
RUN a2enmod rewrite

# 6. Copy Composer binary from the official Composer image
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# 7. Fix permissions on /var/www
RUN chown -R www-data:www-data /var/www

EXPOSE 80
