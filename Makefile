# 主 Makefile

# 通过 shell 命令手动加载环境变量
ifneq ($(wildcard .env),)
  include .env
  export
endif

# 设置默认目标
.DEFAULT_GOAL := build

# $(info DOCKER_IMAGE_PLATFORM: $(DOCKER_IMAGE_PLATFORM))
ifdef DOCKER_IMAGE_PLATFORM
	DOCKER_PLATFORM_FLAG = --platform $(DOCKER_IMAGE_PLATFORM)
else
	DOCKER_PLATFORM_FLAG =
endif
export DOCKER_PLATFORM_FLAG


# 包含 makefiles 目录下的所有 .mk 文件
include makefiles/postgres.mk
include makefiles/redis.mk
include makefiles/minio.mk
include makefiles/log.mk
# 可以继续添加其他服务的 mk 文件


# 总构建目标，依赖 PostgreSQL 和 Redis
build: build.postgres build.redis build.logs build.minio
	@echo "Build complete."

# 运行所有服务
run: run.postgres run.redis run.logs run.minio
	@echo "Services are running."

stop: stop.postgres stop.redis stop.logs stop.minio
	@echo "Services are stop."

# 清理所有服务
clean:
	clean.postgres clean.redis clean.logs clean.minio
	@echo "Clean complete."
