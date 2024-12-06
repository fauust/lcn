# Ansible example

## pre-commit

Any code submitted to this project is checked with the
[pre-commit](https://pre-commit.com/) framework. To make sure that your code
will pass the checks, you can execute the pre-commit checks locally before "git
pushing" your code.

You will need the following:

-   uv (see: <https://github.com/astral-sh/uv>)

Then you should be able to setup your environment with:

```console
make install
source .venv/bin/activate
make install-pre-commit
make pre-commit-run
```

You can also [install](https://pre-commit.com/#install) the pre-commit tool so
that any commit will be checked automatically.

## Direnv

A [direnv](https://direnv.net/) file directive (`.envrc`) is also included as an
example. You will need to install it and to allow the current directory:

## Normal and latest ansible mode (slow)

```console
make clean
cd && cd -
make install
cd && cd -
```

## Mitogen mode (fast)

```console
make clean
cd && cd -
make install-mitogen
cd && cd -
```

## Molecule mode (role testing)

See: https://github.com/fauust/ansible-role-mariadb/?tab=readme-ov-file#testing-molecule
