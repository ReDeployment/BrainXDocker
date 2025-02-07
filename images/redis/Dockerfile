# 使用官方 Redis 镜像作为基础镜像
FROM redis:latest

# 如果需要进行定制，比如修改配置，可以在这里操作
# 例如，使用自定义的 Redis 配置文件
# COPY ./redis.conf /usr/local/etc/redis/redis.conf

# 设置 Redis 端口，Redis 默认端口为 6379
EXPOSE 6379

# 如果需要自定义初始化脚本或其他配置，可以通过 COPY 操作进行复制
# COPY ./init.sh /docker-entrypoint-initdb.d/

# 默认运行命令，启动 Redis 服务
CMD ["redis-server"]
