# php-apache-ext

| Repository | Link |
|-------------|------|
| GitHub | https://github.com/tackleza/docker-php-apache-ext |
| Docker Hub | https://hub.docker.com/r/tackleza/php-apache-ext |

A production-ready PHP + Apache image with a curated set of common PHP extensions pre-installed.

## Available Tags

| Tag | PHP Version | Status |
|-----|------------|--------|
| `8.1` | PHP 8.1 | ⚠️ End-of-life — no new image releases |
| `8.2` | PHP 8.2 | ✅ Supported |
| `8.3` | PHP 8.3 | ✅ Supported |
| `8.4` | PHP 8.4 | ✅ Supported |
| `8.5` | PHP 8.5 | ✅ Supported |
| `latest` | PHP 8.5 | ✅ Latest |

> PHP 8.6 is a release candidate and is not intended for production. The existing `8.1` tag is retained for compatibility but is no longer rebuilt.

## October 2026 PHP security update

The supported tags (`8.2`, `8.3`, `8.4`, `8.5`, and `latest`) are rebuilt from official PHP images containing the fixes for [CVE-2026-109618 and CVE-2026-109619](https://www.php.net/archive/2026.php). The release build checks the PHP version, installed extensions, and Apache configuration before publication.

| Tag | Fixed PHP version |
|-----|-------------------|
| `8.2` | 8.2.35 |
| `8.3` | 8.3.36 |
| `8.4` | 8.4.27 |
| `8.5`, `latest` | 8.5.12 |

Pull the updated tag and recreate your containers to use the fixed runtime. Existing running containers do not update automatically. You can check a pulled image with `docker run --rm --entrypoint php tackleza/php-apache-ext:8.5 -r 'echo PHP_VERSION, PHP_EOL;'`.

PHP 8.1 is end of life and its existing tag does not receive this fix. Upgrade to a supported tag.

## Extension installation

Supported images install external extensions with [PHP PIE](https://github.com/php/pie), pinned to version 1.5.2. Imagick 3.8.1, MongoDB 2.5.5, and Redis 6.3.0 come from version-pinned packages on [Packagist](https://packagist.org/extensions). PHP 8.4 and 8.5 also install the maintained IMAP package `sirlouen/imap` 1.1.2 through PIE; PHP 8.2 and 8.3 use their bundled IMAP extension. Other bundled extensions continue to use `install-php-extensions`.

Extension versions are intentionally pinned for repeatable builds. A PIE release or package update requires a new image build and validation; existing containers must be recreated after pulling an updated tag.

For PHP 8.4 and 8.5, the Debian 13 base needs archived Debian 12 `libc-client2007e` packages to build IMAP because Debian 13 no longer provides c-client. Keep this dependency in mind when updating the base image.

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
| `mongodb` | MongoDB driver |
| `mysqli` | MySQL Improved extension |
| `opcache` | PHP bytecode cache |
| `pcntl` | Process control |
| `pdo_mysql` | PDO MySQL driver |
| `redis` | Redis in-memory data store client |
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

The container automatically remaps `www-data` to match the UID/GID of whoever owns the mounted `/var/www` directory. For a multi-site mount where `/var/www` itself is container-owned, it uses the single unambiguous non-default owner of the first-level site directories. No manual `chown` needed — PHP can write files and the host user retains full access for `git pull`, deploy scripts, and live code editing.

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

For a multi-site mount with different owners, set the owner path or explicit IDs:

```bash
docker run \
  -e APACHE_OWNER_PATH=/var/www/example.com \
  -v $(pwd)/websites:/var/www \
  tackleza/php-apache-ext:8.3
```

`APACHE_UID` and `APACHE_GID` must be provided together and take precedence over automatic detection. If multiple non-default site owners are detected without an override, the container exits with an actionable error instead of selecting the wrong user.

## PHP Version Lifecycle

| Version | Status | EOL Date |
|---------|--------|----------|
| PHP 8.1 | ⚠️ EOL | Nov 2025 |
| PHP 8.2 | ✅ Active | Dec 2026 |
| PHP 8.3 | ✅ Active | Dec 2027 |
| PHP 8.4 | ✅ Active | Dec 2028 |
| PHP 8.5 | ✅ Active | Dec 2029 |

## November 2026 Apache security update

Supported tags explicitly upgrade Apache packages and reject Apache older than 2.4.71, including the fix for CVE-2026-119618. This is independent of PHP base image rebuild timing. PHP versions, extensions and entrypoint behavior remain unchanged. Build individual variants for local validation: `build-all.sh` also publishes images.

References: https://httpd.apache.org/security/vulnerabilities_24.html and https://security-tracker.debian.org/tracker/CVE-2026-119618.
