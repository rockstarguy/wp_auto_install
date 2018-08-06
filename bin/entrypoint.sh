#!/bin/bash

sed -i 's/^memory_limit.*$/memory_limit = 768M/g' /etc/php.ini
sed -i 's/^max_execution_time.*$/max_execution_time = 18000/g' /etc/php.ini

if [ ! -h /etc/supervisord.d/server.ini ]
then
    
    ln -s /etc/supervisord.d/nginx.ini.config /etc/supervisord.d/server.ini
fi

exec /usr/bin/supervisord -n -c /etc/supervisord.conf