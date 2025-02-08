FROM grafana/grafana:latest

USER root

# 复制 Grafana 配置（如果有）
COPY grafana.ini /etc/grafana/grafana.ini
RUN chmod 644 /etc/grafana/grafana.ini
RUN ls -l /etc/grafana

# 切换回 grafana 用户
USER grafana

# 设置默认管理员账号（可选）
ENV GF_SECURITY_ADMIN_USER=${GF_SECURITY_ADMIN_USER:-admin}
ENV GF_SECURITY_ADMIN_PASSWORD=${GF_SECURITY_ADMIN_PASSWORD:-admin}

# 启动 Grafana
CMD [ "/run.sh" ]
