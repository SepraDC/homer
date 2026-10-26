.DEFAULT_GOAL := help

dev: ## Start dev server (http://localhost:3000) with the prod config
	cp deploy/assets/config.yml public/assets/config.yml
	pnpm dev

build-push: ## Build the ARM64 image (with deploy/assets config) and push it to registry.sepradc.ovh
	./build-and-push.sh

sync-upstream: ## Fetch bastienwirtz/homer and merge its latest release tag
	git fetch upstream --tags
	git merge $$(git describe --tags --abbrev=0 upstream/main)

help: ## Display this help
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' Makefile | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-20s\033[0m %s\n", $$1, $$2}'
