#!/bin/bash
set -eu

bundle check || bundle install

yarn check --integrity --silent || bin/yarn install --frozen-lockfile

# Railsサーバーを実行する場合PIDファイルがあれば削除しておく
if [ "${1:-}" = rails -a "${2:-}" = server ]; then
  if [ -f tmp/pids/server.pid ]; then
    rm -v tmp/pids/server.pid
  fi
fi

exec "$@"
