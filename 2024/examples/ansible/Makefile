VENV_DIR := .venv
VENDOR_DIR := .vendor
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
	@echo -e "\n--> You should now activate the python3 venv with:"
	@echo -e "source $(VENV_DIR)/bin/activate"

install-molecule: ## Install all necessary tools for molecule testing
	$(MAKE)	venv
	$(MAKE) install-pip-packages-molecule
	@echo -e "\n--> You should now activate the python3 venv with:"
	@echo -e "source $(VENV_DIR)/bin/activate"

install-mitogen: ## Install all necessary tools for fast deployment (mitogen)
	$(MAKE)	venv
	$(MAKE) install-pip-packages-mitogen
	$(MAKE) install-galaxy
	@echo -e "\n--> You should now activate the python3 venv with:"
	@echo -e "source $(VENV_DIR)/bin/activate"

venv: ## Create python3 venv if it does not exists
	$(info --> Create python virtual env ($(VENV_DIR)))
	[[ -d $(VENV_DIR) ]] || $(shell command -v uv) venv $(VENV_DIR)

install-pip-packages: ## Install python3 requirements
	$(info --> Install requirements via `uv pip`)
	uv pip install -r requirements.txt

install-pip-packages-molecule: ## Install python3 requirements for molecule testing
	$(info --> Install requirements via `uv pip`)
	uv pip install -r requirements_molecule.txt

install-pip-packages-mitogen: ## Install python3 requirements for fast deployment (mitogen)
	$(info --> Install requirements via `uv pip`)
	uv pip install -r requirements_mitogen.txt

install-galaxy: ## Install galaxy requirements
	$(info --> Install galaxy roles)
	ansible-galaxy collection install -r requirements.yml --force -p $(VENDOR_DIR)/collections
	ansible-galaxy role install -r requirements.yml --force -p $(VENDOR_DIR)/roles

molecule-test: ## Run molecule tests on all roles
	bash ci/role_test -a

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
