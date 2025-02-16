# 使用 MinIO 官方镜像作为基础镜像
FROM minio/minio:RELEASE.2024-03-05T04-48-44Z


# 默认启动命令，使用 MinIO 存储路径
CMD ["server", "--address", "0.0.0.0:9000", "--console-address", "0.0.0.0:9001", "/data"]

# 暴露 MinIO 服务的端口
EXPOSE 9000 9001
