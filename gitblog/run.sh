#!/bin/bash 

gitblog_dir=gitblog
MDfile_dir=${PWD}/MDfile_dir
port=0.0.0.0:8888
usage()
{
	echo "usage: $0 <-g gitblog_dir> <-m mdfile_dir>";
	echo "		$0 <--gitblog gitblog_dir> <--mdfile MDfile_dir>";
}

eval set -- `getopt -o g:m:p:h -al gitblog:,mdfile:,port:,help -- "$@"`
while [ -n "$1" ]
do
	case "$1" in
		-g|--gitblog) 
			gitblog_dir=$2;shift 2;;
		-m|--mdfile) 
			MDfile_dir=$2;shift 2;;
		-p|--port)
			port=$2;shift 2;;	
		-h|--help)
			usage;exit 0;;
		--)
			break;;
	esac
done

#echo $gitblog_dir
#echo $MDfile_dir

if [ ! -d $gitblog_dir ] 
then
	git clone git@github.com:jockchou/gitblog.git 
	gitblog_dir=gitblog
fi

#build Dockerfile
echo "FROM ubuntu:16.04" > ./Dockerfile

echo "RUN apt-get update" >> ./Dockerfile
echo "RUN apt-get install -y openssh-server nginx php php7.0-mbstring" >> ./Dockerfile
echo "RUN echo \"\ndaemon off;\n\" >> /etc/nginx/nginx.conf" >> ./Dockerfile

echo "ADD ./gitblog/ /var/www/gitblog/" >> ./Dockerfile
echo "ADD ./conf.yaml /var/www/gitblog/" >> ./Dockerfile
echo "ADD ./default /etc/nginx/sites-enabled/default" >> ./Dockerfile
echo "ADD ./start.sh /start.sh" >> ./Dockerfile
echo "RUN chmod 755 /start.sh" >> ./Dockerfile
echo "RUN chown www-data:www-data -R /var/www/gitblog" >> ./Dockerfile
#echo "VOLUME [\"$MDfile_dir\"]" >>./Dockerfile
echo "EXPOSE 80" >> ./Dockerfile

echo "CMD [\"/start.sh\"]" >> ./Dockerfile

#build start.sh
echo "#!/bin/sh" > ./start.sh
echo "/etc/init.d/php7.0-fpm start" >> ./start.sh
echo "/usr/sbin/nginx" >> ./start.sh 

#build nginx conf default

echo "server {" > ./default
echo "	listen 80 default_server;">>./default
echo "	listen [::]:80 default_server;">>./default

echo "	root /var/www/gitblog;">>./default

echo "	index index.php index.html index.htm index.nginx-debian.html;">>./default

echo "	server_name _;">>./default

echo "	location / {">>./default
echo "		try_files \$uri \$uri/ =404;">>./default
echo "	}">>./default

echo "	location ~ \\.php$ {">>./default
echo "		include snippets/fastcgi-php.conf;">>./default
echo "		fastcgi_pass unix:/run/php/php7.0-fpm.sock;">>./default
echo "	}">>./default

echo "	location ~ /\\.ht {">>./default
echo "		deny all;">>./default
echo "	}">>./default
echo "}">>./default


docker build -t gitblog .

mf=`readlink -f $MDfile_dir`

docker run -p $port:80 -v $mf:/var/www/gitblog/blog/myblog -d gitblog /start.sh

rm ./default ./Dockerfile ./start.sh
