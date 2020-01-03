#!/usr/bin/env bash

case $1 in
  "b2flow-api")
    rake db:mongoid:create_indexes
    rails s
    ;;
  *)
    # shellcheck disable=SC2068
    exec $@
    ;;
esac