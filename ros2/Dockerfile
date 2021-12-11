FROM ubuntu:20.04

#set timezone
RUN ln -snf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime 
RUN echo "Asia/Shanghai" > /etc/timezone
RUN echo "export TERM=linux" >> /root/.bashrc

#update the apt
RUN apt-get update
#set language
RUN apt-get install -y zhcon language-pack-zh-hant language-pack-zh-hans
ADD ./locale /etc/default/locale 
RUN locale-gen zh_CN.UTF-8 &&  DEBIAN_FRONTEND=noninteractive dpkg-reconfigure locales
RUN locale-gen zh_CN.UTF-8  
ENV LANG zh_CN.UTF-8  
ENV LANGUAGE zh_CN:zh  
ENV LC_ALL zh_CN.UTF-8

#install soft
RUN apt-get install -y vim openssh-server 
ctags tmux git make pkg-config gdb strace man automake libtool
RUN apt-get install -y psmisc tree iputils-ping libnet-ifconfig-wrapper-perl tig

#config sshd and root passwd
RUN sed -ri 's/^PermitRootLogin\s+.*/PermitRootLogin yes/' /etc/ssh/sshd_config 
RUN sed -ri 's/UsePAM yes/#UsePAM yes/g' /etc/ssh/sshd_config
RUN echo "root:123456" | chpasswd

RUN mkdir /var/run/sshd

# config ROS
RUN apt install curl gnupg2 lsb-release
RUN curl -KsSL https://raw.githubusercontent.com/ros/rosdistro/master/ros.key  -o /usr/share/keyrings/ros-archive-keyring.gpg

RUN echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/ros-archive-keyring.gpg] http://packages.ros.org/ros2/ubuntu $(lsb_release -cs) main" | tee /etc/apt/sources.list.d/ros2.list > /dev/null 

RUN apt update 
RUN apt install -y build-essential cmake git libbullet-dev python3-colcon-common-extensions python3-flake8  python3-pip python3-pytest-cov python3-rosdep python3-setuptools python3-vcstool wget


EXPOSE 22

CMD ["/usr/sbin/sshd -D"]

