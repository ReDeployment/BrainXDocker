
include makefiles/rabbitmq.mk
include makefiles/brainx/backend-base.mk
include makefiles/brainx/backend.mk
include makefiles/brainx/frontend.mk


build.brainx: build.rabbitmq build.brainx.backend build.brainx.frontend
	@echo "Build brainx complete."