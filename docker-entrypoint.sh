#!/bin/bash
set -euo pipefail

OWNER_PATH="${APACHE_OWNER_PATH:-/var/www}"

if [[ -n "${APACHE_UID:-}" || -n "${APACHE_GID:-}" ]]; then
    if [[ -z "${APACHE_UID:-}" || -z "${APACHE_GID:-}" ]]; then
        echo 'APACHE_UID and APACHE_GID must be set together' >&2
        exit 1
    fi
    TARGET_UID="$APACHE_UID"
    TARGET_GID="$APACHE_GID"
else
    if [[ ! -d "$OWNER_PATH" ]]; then
        echo "Apache owner path does not exist: $OWNER_PATH" >&2
        exit 1
    fi

    TARGET_UID="$(stat -c '%u' "$OWNER_PATH")"
    TARGET_GID="$(stat -c '%g' "$OWNER_PATH")"

    # A multi-site bind mount often has a container-owned /var/www parent,
    # while the actual site directories belong to the host deploy user.
    # Use that owner only when there is one unambiguous non-default candidate.
    if [[ "$OWNER_PATH" == '/var/www' && "$TARGET_UID" =~ ^(0|33)$ ]]; then
        mapfile -t candidates < <(
            find /var/www -mindepth 1 -maxdepth 1 -type d -printf '%U:%G\n' \
                | awk -F: '$1 != 0 && $1 != 33' \
                | sort -u
        )

        if (( ${#candidates[@]} == 1 )); then
            IFS=: read -r TARGET_UID TARGET_GID <<< "${candidates[0]}"
            OWNER_PATH='/var/www/*'
        elif (( ${#candidates[@]} > 1 )); then
            echo 'Multiple non-default /var/www owners detected; set APACHE_UID/APACHE_GID or APACHE_OWNER_PATH' >&2
            printf '  candidate: %s\n' "${candidates[@]}" >&2
            exit 1
        fi
    fi
fi

if [ "$TARGET_UID" != "0" ] && [ "$TARGET_UID" != "33" ]; then
    existing=$(getent passwd "$TARGET_UID" | cut -d: -f1 || true)
    [ -n "$existing" ] && [ "$existing" != "www-data" ] && userdel "$existing"
    existing_grp=$(getent group "$TARGET_GID" | cut -d: -f1 || true)
    [ -n "$existing_grp" ] && [ "$existing_grp" != "www-data" ] && groupdel "$existing_grp"

    # The base image uses /var/www as www-data's home. Move it temporarily so
    # usermod does not recursively chown a bind-mounted document root.
    apache_home="$(getent passwd www-data | cut -d: -f6)"
    if [ "$apache_home" = '/var/www' ]; then
        usermod -d /nonexistent www-data
    fi
    groupmod -g "$TARGET_GID" www-data
    usermod -u "$TARGET_UID" www-data
    usermod -d "$apache_home" www-data
fi

echo "www-data mapped to ${TARGET_UID}:${TARGET_GID} (owner path: ${OWNER_PATH})"

exec apache2-foreground
