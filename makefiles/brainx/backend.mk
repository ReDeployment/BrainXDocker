# makefiles/brainx.mk

# 定义变量
BRAINX_BACKEND_IMAGE_NAME := brainx-backend
BRAINX_BACKEND_TASK_NAME := brainx-task
BRAINX_BACKEND_TASK_RAG_NAME := brainx-task-rag

BRAINX_BACKEND_DOCKERFILE := ${BRAINX_BACKEND_DOCKERFILE}
BRAINX_BACKEND_VERSION := $(shell cat .env | grep DOCKER_IMAGE_BRAINX_BACKEND_VERSION | cut -d '=' -f2)
ifeq ($(BRAINX_BACKEND_VERSION),)
	BRAINX_BACKEND_VERSION := $(DOCKER_IMAGE_VERSION)  # 如果没有从 .env 获取到版本号，默认使用 DOCKER_IMAGE_VERSION
endif

# 使用 .env 中定义的端口
BRAINX_PORT := $(BRAINX_BACKEND_PORT)


ABS_BRAINX_BACKEND_DIR:= $(call get_absolute_path,$(BRAINX_BACKEND_DIR))

BRAINX_BACKEND_CONFIG_FOLDER := $(if $(BRAINX_BACKEND_CONFIG_FOLDER),$(BRAINX_BACKEND_CONFIG_FOLDER),$(PROJECT_DIR)/docker-data/brainx/backend/etc)
ABS_BRAINX_BACKEND_CONFIG_FOLDER := $(call get_absolute_path,$(BRAINX_BACKEND_CONFIG_FOLDER))

BRAINX_BACKEND_LOG_PATH := $(if $(BRAINX_BACKEND_LOG_PATH),$(BRAINX_BACKEND_LOG_PATH),$(PROJECT_DIR)/docker-data/brainx/backend/logs)
ABS_BRAINX_BACKEND_LOG_PATH := $(call get_absolute_path,$(BRAINX_BACKEND_LOG_PATH))

BRAINX_CACHE_FOLDER := $(if $(BRAINX_CACHE_FOLDER),$(BRAINX_CACHE_FOLDER),$(PROJECT_DIR)/docker-data/brainx/backend/cache)
ABS_BRAINX_CACHE_FOLDER := $(call get_absolute_path,$(BRAINX_CACHE_FOLDER))

BRAINX_MODEL_FOLDER := $(if $(BRAINX_MODEL_FOLDER),$(BRAINX_MODEL_FOLDER),$(PROJECT_DIR)/docker-data/brainx/backend/model)
ABS_BRAINX_MODEL_FOLDER := $(call get_absolute_path,$(BRAINX_MODEL_FOLDER))


# 打印调试信息（可选）
# $(info DOCKER_IMAGE_VERSION: $(DOCKER_IMAGE_VERSION))
# $(info DOCKER_PLATFORM_FLAG: $(DOCKER_PLATFORM_FLAG))
# $(info BRAINX_BACKEND_PORT: $(BRAINX_BACKEND_PORT))
# $(info BRAINX_BACKEND_MANAGEMENT_PORT: $(BRAINX_BACKEND_MANAGEMENT_PORT))

rerun.brainx.backend: stop.brainx.backend run.brainx.backend

# 运行后台服务容器
run.brainx.backend:
	docker run -d \
		--name $(BRAINX_BACKEND_IMAGE_NAME) \
		-p $(BRAINX_PORT):8000 \
		-v ${ABS_BRAINX_BACKEND_CONFIG_FOLDER}:/app/etc \
		-v ${ABS_BRAINX_BACKEND_LOG_PATH}:/app/logs \
		-v ${ABS_BRAINX_CACHE_FOLDER}:/root/.cache \
		-v ${ABS_BRAINX_MODEL_FOLDER}:/root/brainx/model \
		$(BRAINX_BACKEND_IMAGE_NAME):$(BRAINX_BACKEND_VERSION) \
		make -f /app/docker/Makefile-py.mk -C /app app-init

run.brainx.backend.build:
	docker run -d \
		--name $(BRAINX_BACKEND_IMAGE_NAME) \
		-p $(BRAINX_PORT):8000 \
		-v ${ABS_BRAINX_BACKEND_CONFIG_FOLDER}:/app/etc \
		-v ${ABS_BRAINX_BACKEND_LOG_PATH}:/app/logs \
		-v ${ABS_BRAINX_CACHE_FOLDER}:/root/.cache \
		-v ${ABS_BRAINX_MODEL_FOLDER}:/root/brainx/model \
		$(BRAINX_BACKEND_IMAGE_NAME):$(BRAINX_BACKEND_VERSION) \
		make -f /app/docker/Makefile-build.mk -C /app app-init

# 运行后台任务服务容器
run.brainx.task:
	docker run -d \
		--name $(BRAINX_BACKEND_TASK_RAG_NAME) \
		-v ${ABS_BRAINX_BACKEND_CONFIG_FOLDER}:/app/etc \
		$(BRAINX_BACKEND_IMAGE_NAME):$(BRAINX_BACKEND_VERSION) \
		make -f /app/docker/Makefile-py.mk -C /app task-run

run.brainx.task.build:
	docker run -d \
		--name $(BRAINX_BACKEND_TASK_NAME) \
		-v ${ABS_BRAINX_BACKEND_CONFIG_FOLDER}:/app/etc \
		$(BRAINX_BACKEND_IMAGE_NAME):$(BRAINX_BACKEND_VERSION) \
		make -f /app/docker/Makefile-build.mk -C /app task-run

# 运行后台RAG任务服务容器
run.brainx.task.rag:
	docker run -d \
		--name $(BRAINX_BACKEND_TASK_RAG_NAME) \
		-v ${ABS_BRAINX_BACKEND_CONFIG_FOLDER}:/app/etc \
		$(BRAINX_BACKEND_IMAGE_NAME):$(BRAINX_BACKEND_VERSION) \
		make -f /app/docker/Makefile-py.mk -C /app task-rag-run

run.brainx.task.rag.build:
	docker run -d \
		--name $(BRAINX_BACKEND_TASK_RAG_NAME) \
		-v ${ABS_BRAINX_BACKEND_CONFIG_FOLDER}:/app/etc \
		$(BRAINX_BACKEND_IMAGE_NAME):$(BRAINX_BACKEND_VERSION) \
		make -f /app/docker/Makefile-build.mk -C /app task-rag-run



# 停止后台容器
stop.brainx.backend:
	docker stop $(BRAINX_BACKEND_IMAGE_NAME)
	docker rm $(BRAINX_BACKEND_IMAGE_NAME)

# 清理后台镜像
clean.brainx.backend:
	docker rmi $(BRAINX_BACKEND_IMAGE_NAME):$(BRAINX_BACKEND_VERSION)
	@echo "Cleaned up brainx image."
