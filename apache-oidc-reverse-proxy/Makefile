##############################################################################
# Variables

# Version
VERSION := $(shell cat VERSION)


# Parent directory name
PARENT_DIR_NAME := $(shell basename $(dir $(realpath $(firstword $(MAKEFILE_LIST)))))


# Image repository
IMAGE_REPOSITORY := $(PARENT_DIR_NAME)


# Container name
CONTAINER_NAME := $(PARENT_DIR_NAME)


# Extra root CA
ifneq ($(origin EXASTRO_EXTRA_ROOT_CA), undefined)
DOCKER_BUILD_OPT_SECRET := --secret id=extra-root-ca,src=$(EXASTRO_EXTRA_ROOT_CA)
endif


##############################################################################
# Targets

.PHONY: build
build:
	DOCKER_BUILDKIT=1 docker build \
		--tag $(IMAGE_REPOSITORY):$(VERSION) \
		--no-cache \
		--build-arg HTTP_PROXY \
		--build-arg http_proxy \
		--build-arg HTTPS_PROXY \
		--build-arg https_proxy \
		--build-arg NO_PROXY \
		--build-arg no_proxy \
		$(DOCKER_BUILD_OPT_SECRET) \
		.
