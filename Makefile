TYPST ?= typst
PACKAGE_NAME := shine-notes
PACKAGE_VERSION := 0.1.0
LOCAL_PACKAGE_PATH := $(CURDIR)/build/typst-packages
LOCAL_PACKAGE_DIR := $(LOCAL_PACKAGE_PATH)/preview/$(PACKAGE_NAME)/$(PACKAGE_VERSION)
TEMPLATE_CHECK_DIR := build/template-check

.PHONY: stage-package template-check clean

stage-package:
	rm -rf $(LOCAL_PACKAGE_DIR)
	mkdir -p $(LOCAL_PACKAGE_DIR)
	cp typst.toml lib.typ LICENSE README.md $(LOCAL_PACKAGE_DIR)/
	cp -R src template $(LOCAL_PACKAGE_DIR)/

template-check: stage-package
	rm -rf $(TEMPLATE_CHECK_DIR)
	$(TYPST) init --package-path $(LOCAL_PACKAGE_PATH) @preview/$(PACKAGE_NAME):$(PACKAGE_VERSION) $(TEMPLATE_CHECK_DIR)
	cd $(TEMPLATE_CHECK_DIR) && TYPST_PACKAGE_PATH=$(LOCAL_PACKAGE_PATH) $(MAKE)

clean:
	rm -rf build
