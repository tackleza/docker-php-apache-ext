FROM php:8.0-apache

# Update the package list and install necessary packages
RUN apt-get update && apt-get install -y \
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
    unzip \
    && docker-php-ext-configure gd --with-freetype --with-jpeg --with-webp --with-xpm \
    && docker-php-ext-configure imap --with-kerberos --with-imap-ssl \
    && docker-php-ext-install -j$(nproc) \
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
    && pecl install mongodb imagick \
    && docker-php-ext-enable mongodb imagick

# Enable Apache mod_rewrite
RUN a2enmod rewrite

# Install Composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# Clean up
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

EXPOSE 80
