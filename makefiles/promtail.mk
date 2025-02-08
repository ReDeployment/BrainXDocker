# makefiles/promtail.mk

# 定义变量
PROMTAIL_IMAGE_NAME := x-promtail
PROMTAIL_DOCKERFILE_DIR := ./images/promtail
PROMTAIL_VERSION := $(shell cat .env | grep DOCKER_IMAGE_PROMTAIL_VERSION | cut -d '=' -f2)
ifeq ($(PROMTAIL_VERSION),)
  PROMTAIL_VERSION := $(DOCKER_IMAGE_VERSION)  # 如果没有从 .env 获取到版本号，默认使用 DOCKER_IMAGE_VERSION
endif

# 使用 .env 中定义的端口
PROMTAIL_PORT := $(PROMTAIL_PORT)

# 打印调试信息（可选）
# $(info DOCKER_IMAGE_VERSION: $(DOCKER_IMAGE_VERSION))
# $(info DOCKER_PLATFORM_FLAG: $(DOCKER_PLATFORM_FLAG))
# $(info PROMTAIL_PORT: $(GF_SERVER_HTTP_PORT))

# 构建日志镜像
build.promtail:
	@echo "Building Docker image: $(PROMTAIL_IMAGE_NAME) version $(PROMTAIL_VERSION)"
	docker build -t $(PROMTAIL_IMAGE_NAME):$(PROMTAIL_VERSION) \
	$(PROMTAIL_DOCKERFILE_DIR) \
	$(if $(DOCKER_PLATFORM_FLAG),$(DOCKER_PLATFORM_FLAG),) \
	$(if $(DOCKER_BUILD_OPTS),$(DOCKER_BUILD_OPTS),)

rerun.promtail: stop.promtail run.promtail

# 运行日志容器
run.promtail:
	docker run -d \
		--name $(PROMTAIL_IMAGE_NAME) \
		-p $(PROMTAIL_PORT):9080 \
		-v $(if $(PROMTAIL_CONFIG_PATH),$(PROMTAIL_CONFIG_PATH),$(PROJECT_DIR)/docker-data/promtail/promtail-config.yaml):/etc/promtail/promtail-config.yaml \
		$(PROMTAIL_IMAGE_NAME):$(PROMTAIL_VERSION)

# 停止日志容器
stop.promtail:
	docker stop $(PROMTAIL_IMAGE_NAME)
	docker rm $(PROMTAIL_IMAGE_NAME)

# 清理日志镜像
clean.promtail:
	docker rmi $(PROMTAIL_IMAGE_NAME):$(PROMTAIL_VERSION)
	@echo "Cleaned up promtail image."
