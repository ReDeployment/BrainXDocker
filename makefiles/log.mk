# makefiles/log.mk

# 定义变量
LOG_IMAGE_NAME := x-log
LOG_DOCKERFILE_DIR := ./images/log
LOG_VERSION := $(shell cat .env | grep DOCKER_IMAGE_LOG_VERSION | cut -d '=' -f2)
ifeq ($(LOG_VERSION),)
  LOG_VERSION := $(DOCKER_IMAGE_VERSION)  # 如果没有从 .env 获取到版本号，默认使用 DOCKER_IMAGE_VERSION
endif

# 使用 .env 中定义的端口
GRAFANA_PORT := $(GRAFANA_PORT)
LOKI_PORT := $(LOKI_PORT)
PROMTAIL_PORT := $(PROMTAIL_PORT)

# 打印调试信息（可选）
# $(info DOCKER_IMAGE_VERSION: $(DOCKER_IMAGE_VERSION))
# $(info DOCKER_PLATFORM_FLAG: $(DOCKER_PLATFORM_FLAG))
# $(info GRAFANA_PORT: $(GRAFANA_PORT))
# $(info LOKI_PORT: $(LOKI_PORT))
# $(info PROMTAIL_PORT: $(PROMTAIL_PORT))

# 构建日志镜像
build.logs:
	@echo "Building Docker image: $(LOG_IMAGE_NAME) version $(LOG_VERSION)"
	docker build -t $(LOG_IMAGE_NAME):$(LOG_VERSION) $(LOG_DOCKERFILE_DIR) $(DOCKER_PLATFORM_FLAG)

# 运行日志容器
run.logs:
	docker run -d \
		--name $(LOG_IMAGE_NAME) \
		-p $(GRAFANA_PORT):3000 \
		-p $(LOKI_PORT):3100 \
		-p $(PROMTAIL_PORT):9080 \
		-e GRAFANA_PORT=$(GRAFANA_PORT) \
		-e LOKI_PORT=$(LOKI_PORT) \
		-e PROMTAIL_PORT=$(PROMTAIL_PORT) \
		$(LOG_IMAGE_NAME):$(LOG_VERSION)

# 停止日志容器
stop.logs:
	docker stop $(LOG_IMAGE_NAME)
	docker rm $(LOG_IMAGE_NAME)

# 清理日志镜像
clean.logs:
	docker rmi $(LOG_IMAGE_NAME):$(LOG_VERSION)
	@echo "Cleaned up log image."
