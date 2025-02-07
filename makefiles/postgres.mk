
# makefiles/postgres.mk

# 定义 PostgreSQL 镜像名称和版本
IMAGE_NAME := x-postgres
DOCKERFILE_DIR := ./images/postgres
VERSION := $(shell cat .env | grep DOCKER_IMAGE_VERSION | cut -d '=' -f2)

# 定义 Docker 构建命令
build:
	@echo "Building Docker image: $(IMAGE_NAME) version $(VERSION)"
	docker build -t $(IMAGE_NAME):$(VERSION) $(DOCKERFILE_DIR) $(DOCKER_PLATFORM_FLAG)

# 运行 PostgreSQL 服务
run:
	docker run -d --name $(IMAGE_NAME) -p 5432:5432 $(IMAGE_NAME):$(VERSION)

# 清理镜像
clean:
	docker rmi $(IMAGE_NAME):$(VERSION)
	@echo "Cleaned up PostgreSQL image."
