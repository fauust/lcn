VENV_DIR := .venv
VENDOR_DIR := .vendor
SHELL := /usr/bin/env bash
.DEFAULT_GOAL := help
.SHELLFLAGS := -eu -o pipefail -c
PATH := $(VENV_DIR)/bin:$(PATH)
export PATH

help:
	@grep -E '^[a-zA-Z1-9_-]+:.*?## .*$$' $(MAKEFILE_LIST) \
		| awk 'BEGIN { FS = ":.*?## " }; { printf "\033[36m%-30s\033[0m %s\n", $$1, $$2 }'

install: ## Install all necessary tools
	$(MAKE)	venv
	$(MAKE) install-pip-packages
	$(MAKE) install-galaxy
	$(MAKE) install-azure
	@echo -e "\n--> You should now activate the python3 venv with:"
	@echo -e "source $(VENV_DIR)/bin/activate"

venv: ## Create python3 venv if it does not exists
	$(info --> Create python virtual env ($(VENV_DIR)))
	[[ -d $(VENV_DIR) ]] || $(shell command -v virtualenv) $(VENV_DIR)

install-pip-packages: ## Install python3 requirements
	$(info --> Install requirements via `pip`)
	pip install -r requirements.txt

install-galaxy: ## Install galaxy requirements
	$(info --> Install galaxy roles)
	ansible-galaxy collection install -r requirements.yml --force -p $(VENDOR_DIR)/collections
	ansible-galaxy role install -r requirements.yml --force -p $(VENDOR_DIR)/roles

install-azure: ## Install azure deps
	$(info --> Install azure deps)
	pip install -r .vendor/collections/ansible_collections/azure/azcollection/requirements.txt

clean: ## Clean venv
	[[ ! -d $(VENV_DIR) ]] || rm -rf $(VENV_DIR)
	[[ ! -d $(VENDOR_DIR) ]] || rm -rf $(VENDOR_DIR)

pre-commit-install: ## Install pre-commit hooks
	pre-commit install

pre-commit-run: ## Run pre-commit hooks with $PRE_COMMIT_ARGS default to (diff master...[current_branch])
	pre-commit run $(PRE_COMMIT_ARGS)

lint: ## Run linters on the whole repository
	PRE_COMMIT_ARGS=--all-files \
	$(MAKE) pre-commit-run
