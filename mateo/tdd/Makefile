VENV_DIR := .venv
SHELL := /usr/bin/env bash
.DEFAULT_GOAL := help
.SHELLFLAGS := -eu -o pipefail -c
PATH := $(VENV_DIR)/bin:$(PATH)
PYTHON := python3
PYTEST_ARGS := -v
SRC_DIRS := .
export PATH

.PHONY: help venv install install-pytest test test-coverage lint format clean run

help: ## Affiche cette aide
	@grep -E '^[a-zA-Z1-9_-]+:.*?## .*$$' $(MAKEFILE_LIST) \
		  sort \
		  awk 'BEGIN { FS = ":.*?## " }; { printf "\033[36m%-30s\033[0m %s\n", $$1, $$2 }'

venv: ## Create python3 venv if it does not exists
	$(info --> Create python virtual env ($(VENV_DIR)))
	[[ -d $(VENV_DIR) ]] || $(shell command -v python3) -m venv $(VENV_DIR)
	@echo -e "\n--> You should now activate the python3 venv with:"
	@echo -e "source $(VENV_DIR)/bin/activate\n"

install-dev-tools: ## Installe les outils de développement (pytest, flake8, black)
	$(info --> Installation des outils de développement)
	uv pip install pytest pytest-cov flake8 black

install-pytest: ## Installe pytest et ses extensions
	$(info --> Installation de pytest via uv)
	uv pip install pytest pytest-cov

install: venv install-pytest ## Prépare l'environnement de développement complet

test: ## Exécute les tests avec pytest
	$(info --> Exécution des tests)
	pytest test_fizzbuzz.py $(PYTEST_ARGS)

test-coverage: ## Exécute les tests avec rapport de couverture
	$(info --> Exécution des tests avec rapport de couverture)
	pytest --cov=$(SRC_DIRS) --cov-report=term --cov-report=html test_fizzbuzz.py

lint: ## Vérifie le style du code avec flake8
	$(info --> Vérification du style de code)
	flake8 $(SRC_DIRS)

format: ## Formate le code avec black
	$(info --> Formatage du code)
	black $(SRC_DIRS)

run: ## Exécute le programme FizzBuzz pour les nombres de 1 à 100
	$(info --> Exécution de FizzBuzz de 1 à 100)
	$(PYTHON) -c "from fizzbuzz import generate_sequence; print('\n'.join(generate_sequence(100)))"

clean: ## Supprime l'environnement virtuel et les fichiers générés
	$(info --> Nettoyage des fichiers générés)
	rm -rf $(VENV_DIR) .pytest_cache htmlcov .coverage __pycache__ */__pycache__
