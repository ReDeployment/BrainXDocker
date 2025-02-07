# 使用 Alpine 作为基础镜像
FROM alpine:latest

# 安装所需的包
RUN apk update && apk add --no-cache \
    curl \
    bash \
    supervisor \
    openjdk11 \
    && rm -rf /var/cache/apk/*

# 安装 Grafana
RUN curl -sSL https://dl.grafana.com/oss/release/grafana-8.4.3.linux-amd64.tar.gz | tar -xz -C /opt/ && ln -s /opt/grafana-*/bin/grafana-server /usr/local/bin/grafana-server

# 安装 Loki
RUN curl -sSL https://github.com/grafana/loki/releases/download/v2.7.1/loki-linux-amd64.zip -o loki.zip \
    && unzip loki.zip -d /opt \
    && ln -s /opt/loki-linux-amd64 /usr/local/bin/loki \
    && rm loki.zip

# 安装 Promtail
RUN curl -sSL https://github.com/grafana/loki/releases/download/v2.7.1/promtail-linux-amd64.zip -o promtail.zip \
    && unzip promtail.zip -d /opt \
    && ln -s /opt/promtail-linux-amd64 /usr/local/bin/promtail \
    && rm promtail.zip

# 创建日志目录
RUN mkdir -p /etc/grafana /etc/loki /etc/promtail /var/log/grafana /var/log/loki /var/log/promtail

# 复制配置文件到容器中
COPY grafana.ini /etc/grafana/grafana.ini
COPY loki-config.yaml /etc/loki/loki-config.yaml
COPY promtail-config.yaml /etc/promtail/promtail-config.yaml

# 配置 supervisord 来启动多个进程
COPY supervisord.conf /etc/supervisord.conf

# 暴露必要的端口
EXPOSE 3000 3100 9080

# 启动 supervisord
CMD ["supervisord", "-c", "/etc/supervisord.conf"]
