#!/bin/bash
set -eu

bundle check || true
exec "$@"

