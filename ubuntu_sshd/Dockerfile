FROM ubuntu:20.04

RUN apt-get update
#install soft
RUN apt-get install -y vim openssh-server

#config sshd and root passwd
RUN sed -ri 's/^PermitRootLogin\s+.*/PermitRootLogin yes/' /etc/ssh/sshd_config 
RUN sed -ri 's/UsePAM yes/#UsePAM yes/g' /etc/ssh/sshd_config
RUN echo "root:jiangxin" | chpasswd

RUN mkdir /var/run/sshd
EXPOSE 22

CMD ["/usr/sbin/sshd -D"]

