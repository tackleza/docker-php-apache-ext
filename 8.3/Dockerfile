FROM php:8.3-apache

# Upgrade Apache independently of the PHP base rebuild cadence.
RUN set -eux; \
    apt-get update; \
    apt-get install -y --no-install-recommends --only-upgrade apache2 apache2-bin apache2-data apache2-utils; \
    for package in apache2 apache2-bin apache2-data apache2-utils; do \
        dpkg --compare-versions "$(dpkg-query -W -f='${Version}' "$package")" ge '2.4.71~'; \
    done; \
    rm -rf /var/lib/apt/lists/*

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

# 3. Install bundled PHP extensions
RUN install-php-extensions \
    bcmath \
    bz2 \
    calendar \
    exif \
    gd \
    gettext \
    gmp \
    imap \
    intl \
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

# 4. Install pinned external extensions with PIE
COPY --from=ghcr.io/php/pie:1.5.2-bin /pie /usr/local/bin/pie
RUN set -eux; \
    apt-get update; \
    apt-get install -y --no-install-recommends $PHPIZE_DEPS libtool libmagickwand-dev; \
    pie install --no-cache imagick/imagick:3.8.1; \
    pie install --no-cache mongodb/mongodb-extension:2.5.5; \
    pie install --no-cache phpredis/phpredis:6.3.0; \
    apt-get purge -y $PHPIZE_DEPS libtool libmagickwand-dev; \
    rm -rf /var/lib/apt/lists/* /root/.cache/composer

# 5. Final Configuration
# Enable Apache Rewrite Module
RUN a2enmod rewrite

# 6. Install Composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# 7. Entrypoint — auto-remaps www-data UID to match mounted volume owner
COPY docker-entrypoint.sh /usr/local/bin/docker-entrypoint.sh
RUN chmod +x /usr/local/bin/docker-entrypoint.sh

EXPOSE 80
ENTRYPOINT ["/usr/local/bin/docker-entrypoint.sh"]
