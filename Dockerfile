FROM debian:buster

#base install
RUN apt-get update && apt-get -y upgrade
RUN apt-get install -y dialog apt-utils
RUN apt-get -y install nginx
RUN apt-get -y install mariadb-server
RUN apt-get -y install php7.3-fpm php7.3-mysql php7.3-curl php7.3-gd php7.3-intl php7.3-mbstring php7.3-soap php7.3-xml php7.3-xmlrpc php7.3-zip php7.3-json php7.3-mbstring

#copy file
RUN mkdir /var/www/localhost/
RUN mkdir /var/www/phpmyadmin/
COPY ./srcs/localhost.tar /tmp/
COPY ./srcs/phpmyadmin.tar /tmp/
COPY ./srcs/nginx-localhost /etc/nginx/sites-available/localhost
RUN tar -xf /tmp/localhost.tar -C /var/www/localhost/
RUN tar -xf /tmp/phpmyadmin.tar -C /var/www/
RUN chown -R www-data:www-data /var/www/*
RUN chmod 755 -R /var/www/*
RUN ln -s /etc/nginx/sites-available/localhost /etc/nginx/sites-enabled/
RUN unlink /etc/nginx/sites-enabled/default
RUN ln -s /var/www/phpmyadmin /var/www/localhost/phpmyadmin

#openssl
RUN openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout /etc/ssl/private/nginx-selfsigned.key -out /etc/ssl/certs/nginx-selfsigned.crt -subj "/C=RU/ST=-/L=-/O=-/OU=-/CN=ft_server.ru/emailAddress=admin@ft_server.com"

#mysql
COPY ./srcs/mysql.sql /tmp/
COPY  ./srcs/phpmyadmin.sql /tmp/
COPY  ./srcs/wordpress.sql /tmp/
RUN service mysql start && mysql -u root mysql < /tmp/mysql.sql && mysql -u root wordpress < /tmp/wordpress.sql &&  mysql -u root phpmyadmin < /tmp/phpmyadmin.sql

#start
COPY  ./srcs/start_server.sh /tmp/
EXPOSE 80 443
ENV AUTOINDEX=1
CMD ["/tmp/start_server.sh"]