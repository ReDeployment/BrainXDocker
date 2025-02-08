# makefiles/rabbitmq.mk

# 定义变量
RABBITMQ_IMAGE_NAME := x-rabbitmq
RABBITMQ_DOCKERFILE_DIR := ./images/rabbitmq
RABBITMQ_VERSION := $(shell cat .env | grep DOCKER_IMAGE_RABBITMQ_VERSION | cut -d '=' -f2)
ifeq ($(RABBITMQ_VERSION),)
  RABBITMQ_VERSION := $(DOCKER_IMAGE_VERSION)  # 如果没有从 .env 获取到版本号，默认使用 DOCKER_IMAGE_VERSION
endif

# 使用 .env 中定义的端口
RABBITMQ_PORT := $(RABBITMQ_PORT)

RABBITMQ_DATA_PATH := $(if $(RABBITMQ_DATA_PATH),$(RABBITMQ_DATA_PATH),$(PROJECT_DIR)/docker-data/rabbitmq)
ABS_RABBITMQ_DATA_PATH := $(call get_absolute_path,$(RABBITMQ_DATA_PATH))


# 打印调试信息（可选）
# $(info DOCKER_IMAGE_VERSION: $(DOCKER_IMAGE_VERSION))
# $(info DOCKER_PLATFORM_FLAG: $(DOCKER_PLATFORM_FLAG))
# $(info RABBITMQ_PORT: $(RABBITMQ_PORT))
# $(info RABBITMQ_MANAGEMENT_PORT: $(RABBITMQ_MANAGEMENT_PORT))

# 构建日志镜像
build.rabbitmq:
	@echo "Building Docker image: $(RABBITMQ_IMAGE_NAME) version $(RABBITMQ_VERSION)"
	docker build -t $(RABBITMQ_IMAGE_NAME):$(RABBITMQ_VERSION) \
	$(RABBITMQ_DOCKERFILE_DIR) \
	$(if $(DOCKER_PLATFORM_FLAG),$(DOCKER_PLATFORM_FLAG),) \
	$(if $(DOCKER_BUILD_OPTS),$(DOCKER_BUILD_OPTS),)

rerun.rabbitmq: stop.rabbitmq run.rabbitmq

# 运行日志容器
run.rabbitmq:
	docker run -d \
		--name $(RABBITMQ_IMAGE_NAME) \
		-p $(RABBITMQ_PORT):5672 \
		-p $(RABBITMQ_MANAGEMENT_PORT):15672 \
		-v $(ABS_RABBITMQ_DATA_PATH):/rabbitmq \
		$(RABBITMQ_IMAGE_NAME):$(RABBITMQ_VERSION)

# 停止日志容器
stop.rabbitmq:
	docker stop $(RABBITMQ_IMAGE_NAME)
	docker rm $(RABBITMQ_IMAGE_NAME)

# 清理日志镜像
clean.rabbitmq:
	docker rmi $(RABBITMQ_IMAGE_NAME):$(RABBITMQ_VERSION)
	@echo "Cleaned up rabbitmq image."
