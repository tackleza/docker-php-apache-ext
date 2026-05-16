#!/bin/bash
set -e

TARGET_UID="${APACHE_UID:-$(stat -c '%u' /var/www)}"
TARGET_GID="${APACHE_GID:-$(stat -c '%g' /var/www)}"

if [ "$TARGET_UID" != "0" ] && [ "$TARGET_UID" != "33" ]; then
    existing=$(getent passwd "$TARGET_UID" | cut -d: -f1 || true)
    [ -n "$existing" ] && [ "$existing" != "www-data" ] && userdel "$existing"
    existing_grp=$(getent group "$TARGET_GID" | cut -d: -f1 || true)
    [ -n "$existing_grp" ] && [ "$existing_grp" != "www-data" ] && groupdel "$existing_grp"
    groupmod -g "$TARGET_GID" www-data
    usermod -u "$TARGET_UID" www-data
fi

exec apache2-foreground
