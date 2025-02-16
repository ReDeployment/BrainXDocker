# makefiles/loki.mk

# 定义变量
LOKI_IMAGE_NAME := x-loki
LOKI_DOCKERFILE_DIR := ./images/loki
# LOKI_VERSION := $(shell cat .env | grep DOCKER_IMAGE_LOKI_VERSION | cut -d '=' -f2)
ifeq ($(LOKI_VERSION),)
  LOKI_VERSION := $(DOCKER_IMAGE_VERSION)  # 如果没有从 .env 获取到版本号，默认使用 DOCKER_IMAGE_VERSION
endif

# 使用 .env 中定义的端口
LOKI_PORT := $(LOKI_PORT)

LOKI_DATA_PATH := $(if $(LOKI_DATA_PATH),$(LOKI_DATA_PATH),$(PROJECT_DIR)/docker-data/loki)
ABS_LOKI_DATA_PATH := $(call get_absolute_path,$(LOKI_DATA_PATH))


# 打印调试信息（可选）
# $(info DOCKER_IMAGE_VERSION: $(DOCKER_IMAGE_VERSION))
# $(info DOCKER_PLATFORM_FLAG: $(DOCKER_PLATFORM_FLAG))
# $(info LOKI_PORT: $(GF_SERVER_HTTP_PORT))

# 构建日志镜像
build.loki:
	@echo "Building Docker image: $(LOKI_IMAGE_NAME) version $(LOKI_VERSION)"
	docker build -t $(LOKI_IMAGE_NAME):$(LOKI_VERSION) \
	$(LOKI_DOCKERFILE_DIR) \
	$(if $(DOCKER_PLATFORM_FLAG),$(DOCKER_PLATFORM_FLAG),) \
	$(if $(DOCKER_BUILD_OPTS),$(DOCKER_BUILD_OPTS),)

rerun.loki: stop.loki run.loki

# 运行日志容器
run.loki:
	docker run -d \
		--name $(LOKI_IMAGE_NAME) \
		-p $(LOKI_PORT):3100 \
		-v $(ABS_LOKI_DATA_PATH):/loki \
		$(LOKI_IMAGE_NAME):$(LOKI_VERSION)

# 停止日志容器
stop.loki:
	docker stop $(LOKI_IMAGE_NAME)
	docker rm $(LOKI_IMAGE_NAME)

# 清理日志镜像
clean.loki:
	docker rmi $(LOKI_IMAGE_NAME):$(LOKI_VERSION)
	@echo "Cleaned up loki image."
