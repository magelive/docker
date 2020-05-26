FROM ubuntu
RUN apt-get update
RUN apt-get install openjdk-8-jdk

ADD ./start.sh /start.sh
RUN chmod 755 /start.sh
CMD ["/start.sh"]
