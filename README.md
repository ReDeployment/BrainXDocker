# 部署BrainX项目
由于BrainX后端编译的依赖库，基于很多AI的库，包括一些驱动比较大，所以打包也很大

# BrainX的项目

前后端分离，分别是：

* backend是兼容后端的项目编译
* frontend是基于前端的项目编译

## backend
### alembic
请将你在BrainX开发好的数据表migrate的相关配置文件，复制过来，可以直接将alembic文件夹全都复制过来

### alembic.ini
主要配置migrate时的数据库连接，在migrate的时候，使用到

### config.yaml
从config.example.yaml里复制一个出来，作为config.yaml配置文件的基础

### .gitignore
隐藏alembic和config.yaml文件，需要你自己生成它们

### Dockerfile
可以编排backend的镜像，纯启动作用，具体的镜像，需要在BrainX里通过docker buildx 进行编译

### Makefile
用于提供启动服务相关的指令集合

## docker-data
保存容器运行的各种持久化数据

## frontend
### .next
将frontend项目，通过npm run build:docker来获取到.next文件夹，
然后复制到BrainXDocker的frontend下

由于.next里的环境变量，已经在编译的时候处理好了，所以你需要在你的开发项目里，设置.env.production.docker

### Dockerfile
用来编排和编译前端项目的镜像

## gateway
预留模块，暂时可忽略

## .env
该环境变量，可以设置为各自项目编译一个自己的镜像，因为编译的镜像很大，建议参考。env.example里的命名规则

backend的镜像

## gitignore
他会将log，data，等敏感数据忽略在git仓库里


## docker-compose.yaml
启动编排docker镜像

docker-compose up -d

