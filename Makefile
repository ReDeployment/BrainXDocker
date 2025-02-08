# 主 Makefile

PROJECT_DIR := $(shell pwd)

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

export PROJECT_DIR
export DOCKER_PLATFORM_FLAG


# 包含 makefiles 目录下的所有 .mk 文件
include makefiles/utils.mk

include makefiles/postgres.mk
include makefiles/redis.mk
include makefiles/minio.mk
include makefiles/loki.mk
include makefiles/grafana.mk
include makefiles/composer.mk
include makefiles/export.mk
# include makefiles/promtail.mk
# 可以继续添加其他服务的 mk 文件


# 总构建目标，依赖 PostgreSQL 和 Redis
build: build.postgres build.redis build.minio build.grafana build.loki
	@echo "Build complete."

# 运行所有服务
run: run.postgres run.redis run.minio run.grafana run.loki
	@echo "Services are running."

stop: stop.postgres stop.redis stop.minio stop.grafana stop.loki
	@echo "Services are stop."

# 清理所有服务
clean: clean.postgres clean.redis clean.minio clean.grafana clean.loki
	@echo "Clean complete."


prune.builder:
	@echo "Pruning unused Docker resources..."
	docker builder prune -a -f
	@echo "Pruned all images, containers, networks, and volumes."

prune.system:
	@echo "Pruning unused Docker resources..."
	docker system prune -a -f
	@echo "Pruned all images, containers, networks, and volumes."