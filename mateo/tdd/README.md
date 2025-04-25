# FizzBuzz TDD

Un exemple minimaliste de Test-Driven Development avec le problème FizzBuzz classique.

## Prérequis

- Python 3.6+
- uv (gestionnaire de paquets Python moderne)
- make

Pour installer uv, suivre son [guide d'installation](https://docs.astral.sh/uv/#highlights)

## Contexte

FizzBuzz est un exercice de programmation où:
- Pour les multiples de 3, on affiche "Fizz"
- Pour les multiples de 5, on affiche "Buzz"
- Pour les multiples de 3 et 5, on affiche "FizzBuzz"
- Pour les autres nombres, on affiche le nombre lui-même

Ce projet implémente FizzBuzz en suivant l'approche TDD (Test-Driven Development).

## Utilisation du Makefile

Le projet utilise un Makefile pour simplifier les commandes:

```bash
# Affiche l'aide
make

# Crée un environnement virtuel Python
make venv

# Active l'environnement virtuel
source .venv/bin/activate

# Installe pytest avec uv
make install-pytest

# Exécute les tests
make test

# Nettoie l'environnement virtuel
make clean
```

## Exécuter FizzBuzz

```python
from fizzbuzz import fizzbuzz, generate_sequence

# Pour un nombre spécifique
result = fizzbuzz(15)  # Renvoie: "FizzBuzz"

# Pour générer une séquence de 1 à n
sequence = generate_sequence(100)
print("\n".join(sequence))
```

## Structure du projet

- `fizzbuzz.py`: Implémentation de FizzBuzz
- `test_fizzbuzz.py`: Tests unitaires
- `Makefile`: Automatisation des tâches

## Commandes Makefile disponibles

| Commande | Description |
|----------|-------------|
| `make help` | Affiche l'aide du Makefile |
| `make venv` | Crée un environnement virtuel Python |
| `make install-pytest` | Installe pytest avec uv |
| `make install-dev-tools` | Installe pytest, flake8 et black |
| `make install` | Prépare l'environnement de développement complet |
| `make test` | Exécute les tests |
| `make test-coverage` | Exécute les tests avec rapport de couverture |
| `make lint` | Vérifie le style du code avec flake8 |
| `make format` | Formate le code avec black |
| `make run` | Exécute FizzBuzz pour les nombres de 1 à 100 |
| `make clean` | Supprime l'environnement virtuel et les fichiers générés |