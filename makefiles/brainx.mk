# makefiles/brainx.mk

# 定义变量
BRAINX_IMAGE_NAME := brainx
BRAINX_DOCKERFILE_DIR := ./images/brainx
BRAINX_VERSION := $(shell cat .env | grep DOCKER_IMAGE_BRAINX_VERSION | cut -d '=' -f2)
ifeq ($(BRAINX_VERSION),)
  BRAINX_VERSION := $(DOCKER_IMAGE_VERSION)  # 如果没有从 .env 获取到版本号，默认使用 DOCKER_IMAGE_VERSION
endif

# 使用 .env 中定义的端口
BRAINX_PORT := $(BRAINX_PORT)

BRAINX_DATA_PATH := $(if $(BRAINX_DATA_PATH),$(BRAINX_DATA_PATH),$(PROJECT_DIR)/docker-data/brainx)
ABS_BRAINX_DATA_PATH := $(call get_absolute_path,$(BRAINX_DATA_PATH))


# 打印调试信息（可选）
# $(info DOCKER_IMAGE_VERSION: $(DOCKER_IMAGE_VERSION))
# $(info DOCKER_PLATFORM_FLAG: $(DOCKER_PLATFORM_FLAG))
# $(info BRAINX_PORT: $(BRAINX_PORT))
# $(info BRAINX_MANAGEMENT_PORT: $(BRAINX_MANAGEMENT_PORT))

# 构建日志镜像
build.brainx:
	@echo "Building Docker image: $(BRAINX_IMAGE_NAME) version $(BRAINX_VERSION)"
	docker build -t $(BRAINX_IMAGE_NAME):$(BRAINX_VERSION) \
	$(BRAINX_DOCKERFILE_DIR) \
	$(if $(DOCKER_PLATFORM_FLAG),$(DOCKER_PLATFORM_FLAG),) \
	$(if $(DOCKER_BUILD_OPTS),$(DOCKER_BUILD_OPTS),)

rerun.brainx: stop.brainx run.brainx

# 运行日志容器
run.brainx:
	docker run -d \
		--name $(BRAINX_IMAGE_NAME) \
		-p $(BRAINX_PORT):5672 \
		-p $(BRAINX_MANAGEMENT_PORT):15672 \
		-v $(ABS_BRAINX_DATA_PATH):/brainx \
		$(BRAINX_IMAGE_NAME):$(BRAINX_VERSION)

# 停止日志容器
stop.brainx:
	docker stop $(BRAINX_IMAGE_NAME)
	docker rm $(BRAINX_IMAGE_NAME)

# 清理日志镜像
clean.brainx:
	docker rmi $(BRAINX_IMAGE_NAME):$(BRAINX_VERSION)
	@echo "Cleaned up brainx image."
