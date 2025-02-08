FROM grafana/promtail:latest

# 复制 Promtail 配置文件
COPY config.yaml /etc/promtail/promtail-config.yaml

# 启动 Promtail
CMD [ "/usr/bin/promtail", "-config.file=/etc/promtail/promtail-config.yaml" ]
