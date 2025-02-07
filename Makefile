# 主 Makefile

# 包含 makefiles 目录下的所有 .mk 文件
include makefiles/postgres.mk
include makefiles/redis.mk
# 可以继续添加其他服务的 mk 文件

# 设置默认目标
.DEFAULT_GOAL := build

ifdef DOCKER_IMAGE_PLATFORM
	DOCKER_PLATFORM_FLAG = --platform $(DOCKER_IMAGE_PLATFORM)
else
	DOCKER_PLATFORM_FLAG =
endif

export DOCKER_PLATFORM_FLAG

# 构建 PostgreSQL 镜像的默认目标
postgres_build:
	@$(MAKE) -f makefiles/postgres.mk build

# 构建 Redis 镜像的默认目标
redis_build:
	@$(MAKE) -f makefiles/redis.mk build

# 总构建目标，依赖 PostgreSQL 和 Redis
build: postgres_build redis_build
	@echo "Build complete."

# 运行所有服务
run: postgres_run redis_run
	@echo "Services are running."

# 清理所有服务
clean:
	@$(MAKE) -f makefiles/postgres.mk clean
	@$(MAKE) -f makefiles/redis.mk clean
	@echo "Clean complete."
