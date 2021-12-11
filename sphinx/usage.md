
# build

```shell
docker build -t sphinx .
```

# run

1. first run
```shell
docker run -v /home/jiangxin/tmp/How_to_write_docs/:/mnt/docs --name "docs_build" sphinx make html -C /mnt/docs
```

2. other time build docs 

```shell
docker start -i docs_build
```
