#!/bin/sh

echo "PHP_VERSION: ${PHP_VERSION}"

if [ -d /www/storage ]; then
    echo "Creating log just in case laravel needs it"
    mkdir -p /www/storage/logs
    chmod 777 /www/storage/logs
fi

echo "Configuring XDebug"
/xdebug.sh

echo "Executing application entrypoint '$@'"
exec "$@"
