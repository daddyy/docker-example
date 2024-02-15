#!/usr/bin/env sh
set -e

if ! pgrep -f php-fpm >/dev/null; then
    echo "php-fpm is not running"
    exit 1
fi

echo "php-fpm is running"
