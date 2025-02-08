# export.mk

EXPORT_PATH ?= ./export/images

# 镜像名称和标签
REPOSITORIES = \
    x-grafana:${DOCKER_IMAGE_VERSION} \
    x-loki:${DOCKER_IMAGE_VERSION} \
    x-redis:${DOCKER_IMAGE_VERSION} \
    x-postgres:${DOCKER_IMAGE_VERSION} \
    x-minio:${DOCKER_IMAGE_VERSION} \


# 导出镜像
.PHONY: export.images
export.images:
	@echo "Exporting images..."
	@for repo in $(REPOSITORIES); do \
		image_name=$$(echo $$repo | cut -d ':' -f 1); \
		image_tag=$$(echo $$repo | cut -d ':' -f 2); \
		echo "Saving image: $$repo to $(EXPORT_PATH)/$$image_name-$$image_tag.tar"; \
		docker save -o $(EXPORT_PATH)/$$image_name-$$image_tag.tar $$repo; \
	done
	@echo "All images exported successfully!"

export.image.grafana:
	@echo "Exporting grafana image..."
	@docker save -o $(EXPORT_PATH)/x-grafana-$(DOCKER_IMAGE_VERSION).tar x-grafana:$(DOCKER_IMAGE_VERSION)

export.image.loki:
	@echo "Exporting loki image..."
	@docker save -o $(EXPORT_PATH)/x-loki-$(DOCKER_IMAGE_VERSION).tar x-loki:$(DOCKER_IMAGE_VERSION)

export.image.redis:
	@echo "Exporting redis image..."
	@docker save -o $(EXPORT_PATH)/x-redis-$(DOCKER_IMAGE_VERSION).tar x-redis:$(DOCKER_IMAGE_VERSION)

export.image.postgres:
	@echo "Exporting postgres image..."
	@docker save -o $(EXPORT_PATH)/x-postgres-$(DOCKER_IMAGE_VERSION).tar x-postgres:$(DOCKER_IMAGE_VERSION)

export.image.minio:
	@echo "Exporting minio image..."
	@docker save -o $(EXPORT_PATH)/x-minio-$(DOCKER_IMAGE_VERSION).tar x-minio:$(DOCKER_IMAGE_VERSION)

# export.image.promtail:
# 	@echo "Exporting promtail image..."
# 	@docker save -o $(EXPORT_PATH)/x-promtail-$(DOCKER_IMAGE_VERSION).tar x-promtail:$(DOCKER_IMAGE_VERSION)

