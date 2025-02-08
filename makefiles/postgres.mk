# makefiles/postgres.mk

# 定义 PostgreSQL 镜像名称和版本
POSTGRES_IMAGE_NAME := x-postgres
POSTGRES_DOCKERFILE_DIR := ./images/postgres
POSTGRES_VERSION := $(shell cat .env | grep DOCKER_IMAGE_POSTGRES_VERSION | cut -d '=' -f2)
ifeq ($(POSTGRES_VERSION),)
  POSTGRES_VERSION := $(DOCKER_IMAGE_VERSION)  # 如果没有从 .env 获取到版本号，默认使用 DOCKER_IMAGE_VERSION
endif


# 使用 .env 中定义的数据库端口
POSTGRES_PORT := $(DATABSE_PORT)

POSTGRES_DATA_PATH := $(if $(POSTGRES_DATA_PATH),$(POSTGRES_DATA_PATH),$(PROJECT_DIR)/docker-data/postgres)
ABS_POSTGRES_DATA_PATH := $(call get_absolute_path,$(POSTGRES_DATA_PATH))

# 打印调试信息（可选）
# $(info DOCKER_IMAGE_VERSION: $(DOCKER_IMAGE_VERSION))
# $(info DOCKER_PLATFORM_FLAG: $(DOCKER_PLATFORM_FLAG))
# $(info POSTGRES_PORT: $(POSTGRES_PORT))

# 定义 Docker 构建命令
build.postgres:
	@echo "Building Docker image: $(POSTGRES_IMAGE_NAME) version $(POSTGRES_VERSION)"
	docker build -t $(POSTGRES_IMAGE_NAME):$(POSTGRES_VERSION) \
	$(POSTGRES_DOCKERFILE_DIR) \
	$(if $(DOCKER_PLATFORM_FLAG),$(DOCKER_PLATFORM_FLAG),) \
	$(if $(DOCKER_BUILD_OPTS),$(DOCKER_BUILD_OPTS),)

rerun.postgres: stop.postgres run.postgres

# 运行 PostgreSQL 服务，使用动态的数据库端口
run.postgres:
	docker run -d \
		--name $(POSTGRES_IMAGE_NAME) \
		-p $(POSTGRES_PORT):5432 \
		-e POSTGRES_USER=$(POSTGRES_USER) \
		-e POSTGRES_PASSWORD=$(POSTGRES_PASSWORD) \
		-e POSTGRES_DB=$(POSTGRES_DB) \
		-v $(ABS_POSTGRES_DATA_PATH):/var/lib/postgresql/data \
		$(POSTGRES_IMAGE_NAME):$(POSTGRES_VERSION)

stop.postgres:
	docker stop $(POSTGRES_IMAGE_NAME)
	docker rm $(POSTGRES_IMAGE_NAME)

# 清理镜像
clean.postgres:
	docker rmi $(POSTGRES_IMAGE_NAME):$(POSTGRES_VERSION)
	@echo "Cleaned up PostgreSQL image."
