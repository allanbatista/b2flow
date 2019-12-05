#!/usr/bin/env bash

case $1 in
  "webapp")
    rake db:create
    rake db:migrate
    rails s
    ;;
  "scheduler")
    rake scheduler:manager
    ;;
  "executor")
    rake scheduler:executor
    ;;
  *)
    # shellcheck disable=SC2068
    exec $@
    ;;
esac