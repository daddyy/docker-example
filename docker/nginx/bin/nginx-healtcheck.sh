#!/usr/bin/env sh
set -e

response=$(curl -s -o /dev/null -w "%{http_code}" http://localhost)

if [ "$response" -ne 200 ]; then
    echo "Nginx is not responding"
    exit 1
fi

echo "Nginx is up and running"
exit 0
