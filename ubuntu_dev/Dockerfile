FROM ubuntu:16.04

#set timezone
RUN ln -snf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime 
RUN echo "Asia/Shanghai" > /etc/timezone
RUN echo "export TERM=linux" >> /root/.bashrc

#update the apt
ADD ./apt_proxy /etc/apt/
RUN apt-get update -c /etc/apt/apt_proxy
#set language
RUN apt-get install -y zhcon language-pack-zh-hant language-pack-zh-hans -c /etc/apt/apt_proxy
ADD ./locale /etc/default/locale 
RUN locale-gen zh_CN.UTF-8 &&  DEBIAN_FRONTEND=noninteractive dpkg-reconfigure locales
RUN locale-gen zh_CN.UTF-8  
ENV LANG zh_CN.UTF-8  
ENV LANGUAGE zh_CN:zh  
ENV LC_ALL zh_CN.UTF-8

#install soft
RUN apt-get install -y vim openssh-server ctags tmux git make pkg-config gdb strace man automake libtool
RUN apt-get install -y psmisc tree iputils-ping libnet-ifconfig-wrapper-perl tig

#config sshd and root passwd
RUN sed -ri 's/^PermitRootLogin\s+.*/PermitRootLogin yes/' /etc/ssh/sshd_config 
RUN sed -ri 's/UsePAM yes/#UsePAM yes/g' /etc/ssh/sshd_config
RUN echo "root:123456" | chpasswd

RUN mkdir /var/run/sshd

#set soft config
ADD ./vimrc.local /etc/vim/vimrc.local
ADD ./tmux.conf /root/.tmux.conf

#add vim plugin
ADD ./vim_plugin/plugin/*.vim /usr/share/vim/vim74/plugin/ 
ADD ./vim_plugin/autoload/*.vim /usr/share/vim/vim74/autoload/

EXPOSE 22

CMD ["/usr/sbin/sshd -D"]

