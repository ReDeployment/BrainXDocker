# 使用 MinIO 官方镜像作为基础镜像
FROM minio/minio:RELEASE.2024-03-05T04-48-44Z

# 设置 MinIO 的环境变量
# ENV MINIO_ROOT_USER=${MINIO_ROOT_USER}
# ENV MINIO_ACCESS_KEY=${MINIO_ACCESS_KEY}
# ENV MINIO_SECRET_KEY=${MINIO_SECRET_KEY}
# ENV MINIO_ROOT_PASSWORD=${MINIO_ROOT_PASSWORD}

# 默认启动命令，使用 MinIO 存储路径
CMD ["server", "--address", "0.0.0.0:9000", "--console-address", "0.0.0.0:9001", "/data"]

# 暴露 MinIO 服务的端口
EXPOSE 9000 9001
