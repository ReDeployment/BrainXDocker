
include makefiles/rabbitmq.mk
include makefiles/brainx/backend-base.mk
include makefiles/brainx/backend.mk
include makefiles/brainx/frontend.mk


build.brainx: build.rabbitmq build.backend build.front
	@echo "Build brainx complete."