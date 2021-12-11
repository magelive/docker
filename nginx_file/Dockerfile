FROM ubuntu
RUN apt-get update
RUN apt-get install -y nginx
RUN echo "\ndaemon off;\n" >> /etc/nginx/nginx.conf
RUN mkdir -p /var/www/file
ADD ./default /etc/nginx/sites-enabled/default
ADD ./start.sh /start.sh
RUN chmod 755 /start.sh
RUN chown www-data:www-data -R /var/www/file
EXPOSE 80
CMD ["/start.sh"]
