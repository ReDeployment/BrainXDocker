# makefiles/minio.mk

# 定义变量
MINIO_IMAGE_NAME := x-minio
MINIO_DOCKERFILE_DIR := ./images/minio
MINIO_VERSION := $(shell cat .env | grep DOCKER_IMAGE_MINIO_VERSION | cut -d '=' -f2)
ifeq ($(MINIO_VERSION),)
  MINIO_VERSION := $(DOCKER_IMAGE_VERSION)  # 如果没有从 .env 获取到版本号，默认使用 DOCKER_IMAGE_VERSION
endif

# 使用 .env 中定义的 MinIO 服务端口
MINIO_API_PORT := $(MINIO_API_PORT)
MINIO_CONSOLE_PORT := $(MINIO_CONSOLE_PORT)

MINIO_DATA_PATH := $(if $(MINIO_DATA_PATH),$(MINIO_DATA_PATH),$(PROJECT_DIR)/docker-data/minio)
ABS_MINIO_DATA_PATH := $(call get_absolute_path,$(MINIO_DATA_PATH))


# 打印调试信息（可选）
# $(info DOCKER_IMAGE_VERSION: $(DOCKER_IMAGE_VERSION))
# $(info DOCKER_PLATFORM_FLAG: $(DOCKER_PLATFORM_FLAG))
# $(info MINIO_API_PORT: $(MINIO_API_PORT))
# $(info MINIO_CONSOLE_PORT: $(MINIO_CONSOLE_PORT))

# 构建 MinIO 镜像
build.minio:
	@echo "Building Docker image: $(MINIO_IMAGE_NAME) version $(MINIO_VERSION)"
	docker build -t $(MINIO_IMAGE_NAME):$(MINIO_VERSION) \
	$(MINIO_DOCKERFILE_DIR) \
	$(if $(DOCKER_PLATFORM_FLAG),$(DOCKER_PLATFORM_FLAG),) \
	$(if $(DOCKER_BUILD_OPTS),$(DOCKER_BUILD_OPTS),)

rerun.minio: stop.minio run.minio

# 运行 MinIO 容器
run.minio:
	docker run -d \
		--name $(MINIO_IMAGE_NAME) \
		-p $(MINIO_API_PORT):9000 \
		-p $(MINIO_CONSOLE_PORT):9001 \
		-e MINIO_ROOT_USER=$(MINIO_ROOT_USER) \
		-e MINIO_ROOT_PASSWORD=$(MINIO_ROOT_PASSWORD) \
		-v $(ABS_MINIO_DATA_PATH):/data \
		$(MINIO_IMAGE_NAME):$(MINIO_VERSION)

# 停止 MinIO 容器
stop.minio:
	docker stop $(MINIO_IMAGE_NAME)
	docker rm $(MINIO_IMAGE_NAME)

# 清理 MinIO 镜像
clean.minio:
	docker rmi $(MINIO_IMAGE_NAME):$(MINIO_VERSION)
	@echo "Cleaned up MinIO image."
