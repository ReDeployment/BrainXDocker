# 使用官方 PostgreSQL 镜像作为基础镜像
FROM pgvector/pgvector:pg16

# 设置时区，避免默认时区问题
ENV TZ=UTC

# 设置数据库的默认用户名、密码和数据库
ENV POSTGRES_USER=${POSTGRES_USER}
ENV POSTGRES_PASSWORD=${POSTGRES_PASSWORD}
ENV POSTGRES_DB=${POSTGRES_DB}

# 如果需要可以拷贝初始化脚本或数据库文件
# COPY ./init.sql /docker-entrypoint-initdb.d/

# 端口映射，默认 PostgreSQL 使用 5432 端口
EXPOSE 5432

# 默认命令
CMD ["postgres"]
