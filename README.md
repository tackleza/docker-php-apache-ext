# PHP Apache Docker
## Same as the official PHP repository, but installed an additional extension.
Docker hub: https://hub.docker.com/r/tackleza/php-apache-ext

This docker can run as standalone php web server

## How to get Started: here are some Examples

This example shows how to mount your website, logs, and configuration to the host
This is mapped to port 8080 on host `http://localhost:8080`

    docker run -d \
      --name apache \
      -p 8080:80 \
      -v $(pwd)/apache.conf:/etc/apache2/sites-available/000-default.conf \
      -v $(pwd)/custom-php.ini:/usr/local/etc/php/conf.d/custom-php.ini \
      -v $(pwd)/websites:/var/www \
      -v $(pwd)/logs:/var/log/apache2 \
      tackleza/php-apache-ext:8.2

Make sure that you have dir "logs/example.com" exists in host. otherwise docker will failed to start up
For more future problem you can debug your docker container by view docker logs by

    docker logs apache

## Example of apache.conf

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

## Example of custom-php.ini
    memory_limit = 512M
    upload_max_filesize = 512M
    post_max_size = 512M

    extension=gmp

## List of installed extentions
- **PDO**: PHP Data Objects, a database access layer providing a uniform method of access to multiple databases.
- **PDO** MySQL: PDO driver for MySQL.
- **GD**: Library for creating and manipulating images.
- **OPcache**: Bytecode cache for PHP, which improves performance.
- **Intl**: Internationalization extension for PHP.
- **bz2**: Extension for reading and writing bzip2-compressed files.
- **SOAP**: Simple Object Access Protocol extension.
- **XSL**: XML Stylesheet Language Transformation extension.
- **ZIP**: ZIP file management extension.
- **Calendar**: Calendar conversion support.
- **EXIF**: Exchangeable image file format support.
- **BCMath**: Arbitrary precision mathematics.
- **Sockets**: Low-level interface to the socket communication functions.
- **gettext**: Native language support through the GNU gettext.
- **shmop**: Shared memory operations.
- **sysvmsg**: System V message queue support.
- **sysvsem**: System V semaphore support.
- **sysvshm**: System V shared memory support.
- **Tidy**: Clean and repair HTML and XML documents.
- **mysqli**: MySQL Improved Extension.
- **PCNTL**: Process Control support.
- **IMAP**: Internet Message Access Protocol extension.
- **MongoDB (>=7.4)**: MongoDB driver for PHP.
- **Imagick**: ImageMagick extension for creating and modifying images.
- **GMP (>=7.0)**: library supported in PHP that allows you to do mathematical operations on signed integers

## List of installed system utils
- **curl**: CURL is used in command lines or scripts to transfer data
- **ping**: ping command use for test the ability of the source computer to reach
- **nano**: nano is a small editor for on the terminal
- **git**: Git is a DevOps tool used for source code management
- **Composer**: A Dependency Manager for PHP.

## Custom php.ini

You can mount your custom php settings. Please look at the example above

      -v $(pwd)/custom-php.ini:/usr/local/etc/php/conf.d/custom-php.ini \

## I've fixed permissions for www-data
When php code is executed, it's run as user `www-data` to simply fix some permission problem. I've changed the owner of "/var/www" to `www-data:www-data` otherwise, this can cause a permission problem, such as when creating or modifying a file. For example, some of your application need to write something to file
