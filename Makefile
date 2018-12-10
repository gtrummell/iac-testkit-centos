.PHONY: help
.DEFAULT_GOAL := help

# Self-documenting makefile compliments of François Zaninotto http://bit.ly/2PYuVj1

distros ?= $(shell find images/ -maxdepth 1 -type d -exec basename {} \; | grep -v images)

help:
	@echo "Make targets for IAC Test Kit:"
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

build-image: test-dockerfile ## Build the IAC Test Kit from Dockerfile
	@for distro in $(distros); do \
		cd images/$$distro ; \
		version = $(shell grep VERSION Dockerfile | cut -d\  -f 3) ; \
		docker build . -t gtrummell/iac-testkit-$$distro:$$version -t gtrummell/iac-testkit-$$distro:latest ; \
	done

clean: ## Sanitize the workspace
	@for distro in $(distros); do \
		cd images/$$distro ; \
		version = $(shell grep VERSION Dockerfile | cut -d\  -f 3) ; \
		-docker rmi -f gtrummell/iac-testkit-$$distro:latest ; \
		-docker rmi -f gtrummell/iac-testkit-$$distro:$$version ; \
		cd ../.. ; \
	done

getdeps: ## Retrieve dependencies
	@for distro in $(distros); do \
		cd images/$$distro ; \
		version = $(shell grep VERSION Dockerfile | cut -d\  -f 3) ; \
		docker pull $$distro:$$version ; \
		cd ../.. ; \
	done

list-distros: ## List available distributions
	for distro in $(distros) ; do \
		echo $$distro ; \
		version := $(shell grep VERSION images/$$distro/Dockerfile | cut -d\  -f 3) ; \
		echo $$version ; \
	done

push-image: ## Push the IAC Test Kit to Dockerhub
	@for distro in $(distros); do \
		cd images/$distro ; \
		version = $(shell grep VERSION Dockerfile | cut -d\  -f 3) ; \
		docker push gtrummell/iac-testkit-$$distro:latest ; \
		docker push gtrummell/iac-testkit-$$distro:$$version ; \
	done

test-dockerfile: getdeps ## Test the IAC Test Kit Dockerfile
	@for distro in $(distros); do \
		cd images/$$distro ; \
		version = $(shell grep VERSION Dockerfile | cut -d\  -f 3) ; \
		docker run -i --rm hadolint/hadolint < ./Dockerfile ; \
	done
