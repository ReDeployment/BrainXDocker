# makefiles/brainx.mk

# 定义变量
BRAINX_IMAGE_NAME := brainx-backend
# BRAINX_VERSION := $(shell cat .env | grep DOCKER_IMAGE_BRAINX_VERSION | cut -d '=' -f2)
ifeq ($(BRAINX_VERSION),)
	BRAINX_VERSION := $(DOCKER_IMAGE_VERSION)  # 如果没有从 .env 获取到版本号，默认使用 DOCKER_IMAGE_VERSION
endif

# 使用 .env 中定义的端口

ABS_BRAINX_BACKEND_DOCKERFILE:= $(call get_absolute_path,$(BRAINX_BACKEND_DOCKERFILE))
ABS_BRAINX_BACKEND_DIR:= $(call get_absolute_path,$(BRAINX_BACKEND_DIR))


BRAINX_BACKEND_CONFIG_FOLDER := $(if $(BRAINX_BACKEND_CONFIG_FOLDER),$(BRAINX_BACKEND_CONFIG_FOLDER),$(PROJECT_DIR)/docker-data/brainx/backend/etc)
ABS_BRAINX_BACKEND_CONFIG_FOLDER := $(call get_absolute_path,$(BRAINX_BACKEND_CONFIG_FOLDER))

BRAINX_BACKEND_LOG_PATH := $(if $(BRAINX_BACKEND_LOG_PATH),$(BRAINX_BACKEND_LOG_PATH),$(PROJECT_DIR)/docker-data/brainx/backend/logs)
ABS_BRAINX_BACKEND_LOG_PATH := $(call get_absolute_path,$(BRAINX_BACKEND_LOG_PATH))

# 打印调试信息（可选）
# $(info DOCKER_IMAGE_VERSION: $(DOCKER_IMAGE_VERSION))
# $(info DOCKER_PLATFORM_FLAG: $(DOCKER_PLATFORM_FLAG))
# $(info BRAINX_PORT: $(BRAINX_PORT))
# $(info BRAINX_MANAGEMENT_PORT: $(BRAINX_MANAGEMENT_PORT))

# 构建日志镜像
build.brainx.backend.base:
	@echo "Building Docker image: $(BRAINX_IMAGE_NAME) version $(BRAINX_VERSION)"
	docker build -t $(BRAINX_IMAGE_NAME):$(BRAINX_VERSION) \
	-f $(ABS_BRAINX_BACKEND_DOCKERFILE) \
	$(if $(DOCKER_PLATFORM_FLAG),$(DOCKER_PLATFORM_FLAG),) \
	$(if $(DOCKER_BUILD_OPTS),$(DOCKER_BUILD_OPTS),) \
	${ABS_BRAINX_BACKEND_DIR}

rerun.brainx.backend.base: stop.brainx.backend.base run.brainx.backend.base

# 运行日志容器
run.brainx.backend.base:
	docker run -d \
		--name $(BRAINX_IMAGE_NAME) \
		-v ${ABS_BRAINX_BACKEND_CONFIG_FOLDER}:/app/etc \
		-v ${ABS_BRAINX_BACKEND_LOG_PATH}:/app/logs \
		$(BRAINX_IMAGE_NAME):$(BRAINX_VERSION) \
		tail -f /dev/null

# 停止日志容器
stop.brainx.backend.base:
	docker stop $(BRAINX_IMAGE_NAME)
	docker rm $(BRAINX_IMAGE_NAME)

# 清理日志镜像
clean.brainx.backend.base:
	docker rmi $(BRAINX_IMAGE_NAME):$(BRAINX_VERSION)
	@echo "Cleaned up brainx image."
