# makefiles/redis.mk

# 定义 Redis 镜像名称和版本
REDIS_IMAGE_NAME := x-redis
REDIS_DOCKERFILE_DIR := ./images/redis
REDIS_VERSION := $(shell cat .env | grep DOCKER_IMAGE_REDIS_VERSION | cut -d '=' -f2)
ifeq ($(REDIS_VERSION),)
  REDIS_VERSION := $(DOCKER_IMAGE_VERSION)  # 如果没有从 .env 获取到版本号，默认使用 DOCKER_IMAGE_VERSION
endif

# 打印调试信息（可选）
# $(info DOCKER_IMAGE_VERSION: $(DOCKER_IMAGE_VERSION))
# $(info DOCKER_PLATFORM_FLAG: $(DOCKER_PLATFORM_FLAG))
# $(info POSTGRES_PORT: $(POSTGRES_PORT))

# 定义 Docker 构建命令
build.redis:
	@echo "Building Docker image: $(REDIS_IMAGE_NAME) REDIS_VERSION $(REDIS_VERSION)"
	docker build -t $(REDIS_IMAGE_NAME):$(REDIS_VERSION) $(REDIS_DOCKERFILE_DIR) $(DOCKER_PLATFORM_FLAG)

# 运行 Redis 服务
run.redis:
	docker run -d --name $(REDIS_IMAGE_NAME) -p $(REDIS_PORT):6379 $(REDIS_IMAGE_NAME):$(REDIS_VERSION)

stop.log:
	docker stop $(REDIS_IMAGE_NAME)
	docker rm $(REDIS_IMAGE_NAME)

# 清理镜像
clean.redis:
	docker rmi $(REDIS_IMAGE_NAME):$(REDIS_VERSION)
	@echo "Cleaned up Redis image."
