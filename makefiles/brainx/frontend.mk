# makefiles/brainx.mk

# 定义变量
BRAINX_FRONTEND_IMAGE_NAME := brainx-frontend
BRAINX_FRONTEND_DOCKERFILE := ${BRAINX_FRONTEND_DOCKERFILE}
# BRAINX_FRONTEND_VERSION := $(shell cat .env | grep DOCKER_IMAGE_BRAINX_FRONTEND_VERSION | cut -d '=' -f2)
ifeq ($(BRAINX_FRONTEND_VERSION),)
	BRAINX_FRONTEND_VERSION := $(DOCKER_IMAGE_VERSION)  # 如果没有从 .env 获取到版本号，默认使用 DOCKER_IMAGE_VERSION
endif

# 使用 .env 中定义的端口
BRAINX_FRONTEND_PORT := $(BRAINX_FRONTEND_PORT)

BRAINX_FRONTEND_DATA_PATH := $(if $(BRAINX_FRONTEND_DATA_PATH),$(BRAINX_FRONTEND_DATA_PATH),$(PROJECT_DIR)/docker-data/brainx)
ABS_BRAINX_FRONTEND_DATA_PATH := $(call get_absolute_path,$(BRAINX_FRONTEND_DATA_PATH))

ABS_BRAINX_FRONTEND_DIR:= $(call get_absolute_path,$(BRAINX_FRONTEND_DIR))

# 打印调试信息（可选）
# $(info DOCKER_IMAGE_VERSION: $(DOCKER_IMAGE_VERSION))
# $(info DOCKER_PLATFORM_FLAG: $(DOCKER_PLATFORM_FLAG))
# $(info BRAINX_FRONTEND_PORT: $(BRAINX_FRONTEND_PORT))
# $(info BRAINX_FRONTEND_MANAGEMENT_PORT: $(BRAINX_FRONTEND_MANAGEMENT_PORT))

# 构建日志镜像
build.brainx.frontend:
	@echo "Building Docker image: $(BRAINX_FRONTEND_IMAGE_NAME) version $(BRAINX_FRONTEND_VERSION)"
	docker build -t $(BRAINX_FRONTEND_IMAGE_NAME):$(BRAINX_FRONTEND_VERSION) \
	-f $(BRAINX_FRONTEND_DOCKERFILE) \
	--build-arg TARGET_ARCH=$(TARGET_ARCH) \
	$(if $(DOCKER_PLATFORM_FLAG),$(DOCKER_PLATFORM_FLAG),) \
	$(if $(DOCKER_BUILD_OPTS),$(DOCKER_BUILD_OPTS),) \
	${ABS_BRAINX_FRONTEND_DIR}

rerun.brainx.frontend: stop.brainx.frontend run.brainx.frontend

# 运行日志容器
run.brainx.frontend:
	docker run -d \
		--name $(BRAINX_FRONTEND_IMAGE_NAME) \
		-p $(BRAINX_FRONTEND_PORT):3000 \
		$(BRAINX_FRONTEND_IMAGE_NAME):$(BRAINX_FRONTEND_VERSION) \

# 停止日志容器
stop.brainx.frontend:
	docker stop $(BRAINX_FRONTEND_IMAGE_NAME)
	docker rm $(BRAINX_FRONTEND_IMAGE_NAME)

# 清理日志镜像
clean.brainx.frontend:
	docker rmi $(BRAINX_FRONTEND_IMAGE_NAME):$(BRAINX_FRONTEND_VERSION)
	@echo "Cleaned up brainx image."
