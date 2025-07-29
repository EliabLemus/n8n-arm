# Configuración
REGISTRY := docker.io
USER := eliablemus
IMAGE := n8n-arm64
VERSION := $(shell cat version.txt)
TAGS := latest $(VERSION)
IMAGE_FULL := $(REGISTRY)/$(USER)/$(IMAGE)

.PHONY: all build tag push login clean show check-node-version

all: build tag push

check-node-version: ## ✅ Verifica que Node >= 20 está en el Dockerfile
	@echo "🔍 Validando versión mínima de Node.js..."
	@if ! grep -q "node:20" Dockerfile; then \
		echo "❌ ERROR: El Dockerfile no usa node:20-alpine (requerido)"; \
		exit 1; \
	else \
		echo "✅ Dockerfile usa Node.js 20+ correctamente."; \
	fi

build: check-node-version ## 🔨 Build image (ARM64, no push)
	@echo "🔨 Building image for ARM64 (tag: build)"
	docker buildx build \
		--platform linux/arm64 \
		--load \
		-t $(IMAGE_FULL):build \
		.

tag: ## 🏷️ Tag build with: latest and version
	@echo "🏷️ Tagging image with: $(TAGS)"
	@$(foreach tag,$(TAGS), \
		docker tag $(IMAGE_FULL):build $(IMAGE_FULL):$(tag) ; )

push: ## 📤 Push all tags to Docker Hub
	@echo "📤 Pushing image tags to Docker Hub..."
	@$(foreach tag,$(TAGS), \
		docker push $(IMAGE_FULL):$(tag) ; )

login: ## 🔐 Docker login
	docker login $(REGISTRY)

clean: ## 🧹 Remove local tags
	@docker image rm $(foreach tag,$(TAGS),$(IMAGE_FULL):$(tag)) || true
	@docker image rm $(IMAGE_FULL):build || true

show: ## 👀 Show image and tags
	@echo "🔧 Image:     $(IMAGE_FULL)"
	@echo "🔧 Tags:      $(TAGS)"
