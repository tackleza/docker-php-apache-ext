# php-apache-ext

| Repository | Link |
|-------------|------|
| GitHub | https://github.com/tackleza/docker-php-apache-ext |
| Docker Hub | https://hub.docker.com/r/tackleza/php-apache-ext |

A production-ready PHP + Apache image with a curated set of common PHP extensions pre-installed.

## Available Tags

| Tag | PHP Version | Status |
|-----|------------|--------|
| `8.1` | PHP 8.1 | ⚠️ End-of-Life — security fixes only |
| `8.2` | PHP 8.2 | ✅ Supported |
| `8.3` | PHP 8.3 | ✅ Supported |
| `8.4` | PHP 8.4 | ✅ Supported |
| `8.5` | PHP 8.5 | ✅ Supported |
| `latest` | PHP 8.5 | ✅ Latest |

> PHP 8.6 / 9.0 are not yet available.

## Installed Extensions

| Extension | Description |
|-----------|-------------|
| `bcmath` | Arbitrary precision mathematics |
| `bz2` | Bzip2 compressed file support |
| `calendar` | Calendar conversion |
| `exif` | EXIF metadata in images |
| `gd` | Image creation and manipulation |
| `gettext` | Native language support (GNU gettext) |
| `gmp` | GNU Multiple Precision arithmetic |
| `imagick` | ImageMagick integration |
| `imap` | IMAP email protocol support |
| `intl` | Internationalization (ICU) |
| `mongod` | MongoDB driver |
| `mysqli` | MySQL Improved extension |
| `opcache` | PHP bytecode cache |
| `pcntl` | Process control |
| `pdo_mysql` | PDO MySQL driver |
| `shmop` | Shared memory operations |
| `soap` | SOAP protocol support |
| `sockets` | Low-level socket interface |
| `sysvmsg` | System V message queues |
| `sysvsem` | System V semaphores |
| `sysvshm` | System V shared memory |
| `tidy` | HTML/XML cleaner and repairer |
| `xsl` | XSLT transformations |
| `zip` | ZIP archive support |

## Installed System Tools

- **Composer** — PHP dependency manager
- **curl**, **git**, **nano**, **ping** — common CLI utilities

## Usage

### Basic usage

```bash
docker run -d \
  --name my-site \
  -p 8080:80 \
  -v $(pwd)/websites:/var/www \
  tackleza/php-apache-ext:8.3
```

### With custom PHP settings and Apache config

```bash
docker run -d \
  --name my-site \
  -p 8080:80 \
  -v $(pwd)/apache.conf:/etc/apache2/sites-available/000-default.conf \
  -v $(pwd)/custom-php.ini:/usr/local/etc/php/conf.d/custom-php.ini \
  -v $(pwd)/websites:/var/www \
  tackleza/php-apache-ext:8.3
```

### Debug with container logs

```bash
docker logs my-site
```

## Apache VirtualHost Example

```apache
<VirtualHost *:80>
    ServerName example.com
    DocumentRoot /var/www/example.com

    <Directory /var/www/example.com>
        Options Indexes FollowSymLinks
        AllowOverride All
        Require all granted
    </Directory>

    ErrorLog /var/log/apache2/example.com/error.log
    CustomLog /var/log/apache2/example.com/access.log combined
</VirtualHost>
```

## Custom PHP Configuration

Mount your own `php.ini` or additional `.ini` files:

```bash
-v $(pwd)/custom-php.ini:/usr/local/etc/php/conf.d/custom-php.ini
```

Example `custom-php.ini`:

```ini
memory_limit = 512M
upload_max_filesize = 512M
post_max_size = 512M
extension=gmp
```

## File Permissions

The container automatically remaps `www-data` to match the UID/GID of whoever owns the mounted `/var/www` directory. No manual `chown` needed — PHP can write files and the host user retains full access for `git pull`, deploy scripts, and live code editing.

| Scenario | Behavior |
|----------|----------|
| Mount from `/home/user_a` (uid=1000) | `www-data` remapped to uid=1000 |
| Mount from `/home/user_b` (uid=1001) | `www-data` remapped to uid=1001 |
| Mount from `/root` (uid=0) | No remapping (root owns everything) |

To override the detected UID/GID explicitly:

```bash
docker run -e APACHE_UID=$(id -u) -e APACHE_GID=$(id -g) \
  -v $(pwd)/websites:/var/www \
  tackleza/php-apache-ext:8.3
```

## PHP Version Lifecycle

| Version | Status | EOL Date |
|---------|--------|----------|
| PHP 8.1 | ⚠️ EOL | Nov 2025 |
| PHP 8.2 | ✅ Active | Dec 2026 |
| PHP 8.3 | ✅ Active | Dec 2027 |
| PHP 8.4 | ✅ Active | Dec 2028 |
| PHP 8.5 | ✅ Active | Dec 2029 |
