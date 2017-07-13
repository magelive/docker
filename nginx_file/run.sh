#!/bin/bash 

file=${PWD}
port=0.0.0.0:8889
usage()
{
	echo "usage: $0 <-f|--file file_dir>";
	echo "			<-p|--port port>";
	echo "			<-h|--help>";
}

eval set -- `getopt -o f:p:h -al file:,port:,help -- "$@"`
while [ -n "$1" ]
do
	case "$1" in
		-f|--file) 
			file=$2;shift 2;;
		-p|--port)
			port=$2;shift 2;;	
		-h|--help)
			usage;exit 0;;
		--)
			break;;
	esac
done

#build Dockerfile
echo "FROM ubuntu:16.04" > ./Dockerfile

echo "RUN apt-get update" >> ./Dockerfile
echo "RUN apt-get install -y nginx" >> ./Dockerfile
echo "RUN echo \"\ndaemon off;\n\" >> /etc/nginx/nginx.conf" >> ./Dockerfile
echo "RUN mkdir -p /var/www/file" >> ./Dockerfile
echo "ADD ./default /etc/nginx/sites-enabled/default" >> ./Dockerfile
echo "ADD ./start.sh /start.sh" >> ./Dockerfile
echo "RUN chmod 755 /start.sh" >> ./Dockerfile
echo "RUN chown www-data:www-data -R /var/www/file" >> ./Dockerfile
#echo "VOLUME [\"$file\"]" >>./Dockerfile
echo "EXPOSE 80" >> ./Dockerfile

echo "CMD [\"/start.sh\"]" >> ./Dockerfile

#build start.sh
echo "#!/bin/sh" > ./start.sh
echo "/usr/sbin/nginx" >> ./start.sh 

#build nginx conf default
echo "server {" > ./default
echo "	listen 80 default_server;" >> ./default
echo "	listen [::]:80 default_server;" >> ./default
echo "    client_max_body_size 4G;" >> ./default
echo "	root /var/www/file;" >> ./default
echo "	index index.html index.htm index.nginx-debian.html;" >> ./default
echo "	location / {" >> ./default
echo "        autoindex on;" >> ./default
echo "        sendfile on;" >> ./default
echo "        autoindex_exact_size on;" >> ./default
echo "        autoindex_localtime on;" >> ./default
echo "        dav_methods PUT;" >> ./default
echo "        dav_access user:rw group:rw all:r;" >> ./default
echo "	}" >> ./default
echo "}" >> ./default

#docker run
docker build -t file_server .

mf=`readlink -f $file`

docker run -p $port:80 -v $file:/var/www/file -d file_server /start.sh

rm ./default ./Dockerfile ./start.sh

