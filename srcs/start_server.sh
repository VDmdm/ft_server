#!/usr/bin/env bash

if [ "$AUTOINDEX" == "1" ];
then
	sed -i 's/autoindex off/autoindex on/' /etc/nginx/sites-available/localhost;
elif [ "$AUTOINDEX" == "0" ];
then
	sed -i 's/autoindex on/autoindex off/' /etc/nginx/sites-available/localhost;
fi;

nginx
service mysql start
service php7.3-fpm start

while true;
	do sleep 1;
done
