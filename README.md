# docker

## how to build

```shell
cd ${dir}
docker build ${image_name}:${tag} .
```

## how to rum 

```shell
docker run -v ${data_dir}:${data_dir} --name ${name} -p ${port}:${port} ${image_name} -d ${run_cmd}
```

more see `docker run`


