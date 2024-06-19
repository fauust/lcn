#!/usr/bin/env bash

. ./bash.sh

usage() {
  cat >&2 <<-EOF
Usage : $0 -u <user|all>
  -u user (or all)
  -h help
EOF
}

typeset -r LARAVEL_URL="https://github.com/alexeymezenin/laravel-realworld-example-app/"
typeset -r LARAVEL_DIR="/tmp/laravel-realworld-example-app"

# make sure commands are available
for cmd in git composer phpunit php sqlite3; do
  command -v $cmd 1>/dev/null ||
    err "$cmd command not found"
done

typeset USER=""

while getopts "u:h" OPTION; do
  case $OPTION in
    u)
      USER="$OPTARG"
      ;;
    h)
      usage
      exit 0
      ;;
    *)
      usage
      exit 1
      ;;
  esac
done

[[ $USER != "" ]] || {
  usage
  exit 1
}

# clone and install the tooling if dir does not exists
if [[ ! -d $LARAVEL_DIR ]]; then
  git clone "$LARAVEL_URL" "$LARAVEL_DIR"
  cd $LARAVEL_DIR || err "cd $LARAVEL_DIR"
  composer update
  composer install
  cp .env.example .env
  # STDOUT goes to /dev/null (always keep STDERR)
  cd - 1>/dev/null
fi

case $USER in
  all)
    USERS=$(find ~+ -mindepth 1 -maxdepth 1 -type d | grep -v ".git" | sort)
    ;;
  *)
    USERS=$USER
    [[ -d $USERS ]] ||
      err "$USERS does not seem to exist"
    ;;
esac

for user in $USERS; do
  msg="${user##*/}: starting"
  line="${msg//?/=}"
  echo_blue "\n${line}\n${msg}\n${line}\n"
  cd "$user" || err "cd $user"
  # Import DB seeds
  SEED=$(find ~+ -type f -name "DatabaseSeeder.php")
  if [[ -z $SEED ]]; then
    echo_red "ERROR: can't find a DB seed, skipping everything"
  else
    # clean DB
    cd $LARAVEL_DIR
    cp -f "$SEED" database/seeders
    echo >database/database.sqlite
    echo_blue "Injecting DB seed"
    if ! php artisan migrate:refresh --seed 1>/dev/null; then
      echo_red "DB import error, aborting"
      echo_green "done"
      sleep 2
    else
      echo_green "done"
      # check that content of DB looks like what we want
      sqlite3 database/database.sqlite "select * from users;" |
        grep -E '(Rose|Musonda)' 1>/tmp/res.sql
      # count lines (should be 2)
      echo_blue "\nCheck DB content"
      if (($(wc -l /tmp/res.sql | awk '{print $1}') != 2)); then
        echo_red "ERROR: DB content does not look OK"
      else
        echo_green "done"
      fi
      sleep 1
    fi
    cd - 1>/dev/null

    # phpUnit tests
    echo_blue "\nExecuting tests"
    TESTS=$(find ~+ -mindepth 2 -type d -name "tests")
    if [[ -z $TESTS ]]; then
      echo_red "ERROR: can't find the tests directory, skipping tests"
    else
      cd $LARAVEL_DIR
      # remove previous tests
      [[ -d tests ]] && rm -rf tests
      cp -r "$TESTS" .
      # restore upstream state
      git checkout -q tests
      # using php artisan (but you can switch to phpunit)
      php artisan test
      # phpunit
    fi
    echo_green "done"
  fi
  msg="${user##*/}: done"
  line="${msg//?/=}"
  echo_blue "\n${line}\n${msg}\n${line}"
done
