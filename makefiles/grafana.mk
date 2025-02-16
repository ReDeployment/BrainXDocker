# makefiles/grafana.mk

# 定义变量
GRAFANA_IMAGE_NAME := x-grafana
GRAFANA_DOCKERFILE_DIR := ./images/grafana
# GRAFANA_VERSION := $(shell cat .env | grep DOCKER_IMAGE_GRAFANA_VERSION | cut -d '=' -f2)
ifeq ($(GRAFANA_VERSION),)
  GRAFANA_VERSION := $(DOCKER_IMAGE_VERSION)  # 如果没有从 .env 获取到版本号，默认使用 DOCKER_IMAGE_VERSION
endif

# 使用 .env 中定义的端口
GRAFANA_PORT := $(GF_SERVER_HTTP_PORT)


GF_DATA_PATH := $(if $(GF_DATA_PATH),$(GF_DATA_PATH),$(PROJECT_DIR)/docker-data/grafana)
ABS_GF_DATA_PATH := $(call get_absolute_path,$(GF_DATA_PATH))
# GF_CONFIG_PATH := $(if $(GF_CONFIG_PATH),$(GF_CONFIG_PATH),$(PROJECT_DIR)/docker-data/grafana/conf)
# ABS_GF_CONFIG_PATH := $(call get_absolute_path,$(GF_CONFIG_PATH))


# 打印调试信息（可选）
# $(info DOCKER_IMAGE_VERSION: $(DOCKER_IMAGE_VERSION))
# $(info DOCKER_PLATFORM_FLAG: $(DOCKER_PLATFORM_FLAG))
# $(info GRAFANA_PORT: $(GF_SERVER_HTTP_PORT))
# $(info ABS_GF_DATA_PATH: $(ABS_GF_DATA_PATH))
# $(info ABS_GF_CONFIG_PATH: $(ABS_GF_CONFIG_PATH))

# 构建日志镜像
build.grafana:
	@echo "Building Docker image: $(GRAFANA_IMAGE_NAME) version $(GRAFANA_VERSION)"
	docker build -t $(GRAFANA_IMAGE_NAME):$(GRAFANA_VERSION) \
	$(GRAFANA_DOCKERFILE_DIR) \
	$(if $(DOCKER_PLATFORM_FLAG),$(DOCKER_PLATFORM_FLAG),) \
	$(if $(DOCKER_BUILD_OPTS),$(DOCKER_BUILD_OPTS),)

rerun.grafana: stop.grafana run.grafana

# 运行日志容器
run.grafana:
	docker run -d \
		--name $(GRAFANA_IMAGE_NAME) \
		-p $(GF_SERVER_HTTP_PORT):3000 \
		-e GF_SECURITY_ADMIN_USER=$(GF_SECURITY_ADMIN_USER) \
		-e GF_SECURITY_ADMIN_PASSWORD=$(GF_SECURITY_ADMIN_PASSWORD) \
		-v $(ABS_GF_DATA_PATH):/var/lib/grafana \
		$(GRAFANA_IMAGE_NAME):$(GRAFANA_VERSION)

# 停止日志容器
stop.grafana:
	docker stop $(GRAFANA_IMAGE_NAME)
	docker rm $(GRAFANA_IMAGE_NAME)

# 清理日志镜像
clean.grafana:
	docker rmi $(GRAFANA_IMAGE_NAME):$(GRAFANA_VERSION)
	@echo "Cleaned up grafana image."
