# 第一阶段
FROM node:21.6.2 AS frontend


# 拷贝项目文件到容器中
WORKDIR /app

# COPY ./dashboard/dist /app/dist
COPY ./ /app/


# 暴露3000端口
EXPOSE 3000

# 启动nextjs
CMD [ "npm", "run", "start" ]
