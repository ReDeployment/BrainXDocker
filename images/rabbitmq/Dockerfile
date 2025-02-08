# 使用官方 RabbitMQ 镜像，包含管理插件
FROM rabbitmq:management

# 设置环境变量，指定默认的用户名和密码
ENV RABBITMQ_DEFAULT_USER=${RABBITMQ_DEFAULT_USER}
ENV RABBITMQ_DEFAULT_PASS=${RABBITMQ_DEFAULT_PASS}

# 拷贝自定义配置文件到容器内（如果需要的话）
# 如果你有额外的配置文件，可以在此处取消注释并修改路径
COPY ./rabbitmq.conf /etc/rabbitmq/rabbitmq.conf

# 暴露端口
# 5672：AMQP 协议端口
# 15672：RabbitMQ 管理 UI
EXPOSE 5672 15672

RUN rabbitmq-plugins enable rabbitmq_management

# 默认命令：启动 RabbitMQ 服务
CMD ["rabbitmq-server"]