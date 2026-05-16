FROM php:8.5-apache

# 1. Install the "Magic" Installer Script
COPY --from=mlocati/php-extension-installer /usr/bin/install-php-extensions /usr/local/bin/

# 2. Install System Utilities (Linux Tools)
# These are the tools you asked for: curl, ping, nano, git, unzip
RUN set -eux; \
    apt-get update; \
    apt-get install -y --no-install-recommends \
        curl \
        git \
        iputils-ping \
        nano \
        unzip \
        zip \
        # 'cron' is often useful if you use scheduler, but optional
        cron; \
    rm -rf /var/lib/apt/lists/*

# 3. Install ALL PHP Extensions
# This single command installs all the libraries (libicu, libpng, libc-client, etc.)
# AND the PHP extensions themselves.
RUN install-php-extensions \
    bcmath \
    bz2 \
    calendar \
    exif \
    gd \
    gettext \
    gmp \
    imagick \
    imap \
    intl \
    mongodb \
    mysqli \
    opcache \
    pcntl \
    pdo_mysql \
    shmop \
    soap \
    sockets \
    sysvmsg \
    sysvsem \
    sysvshm \
    tidy \
    xsl \
    zip

# 4. Final Configuration
# Enable Apache Rewrite Module
RUN a2enmod rewrite

# 5. Install Composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# 6. Entrypoint — auto-remaps www-data UID to match mounted volume owner
COPY docker-entrypoint.sh /usr/local/bin/docker-entrypoint.sh
RUN chmod +x /usr/local/bin/docker-entrypoint.sh

EXPOSE 80
ENTRYPOINT ["/usr/local/bin/docker-entrypoint.sh"]
