#!/bin/bash
set -e

# Remove a potentially pre-existing server.pid for Rails.
rm -f /project/tmp/pids/server.pid

bin/rails db:create db:migrate

exec "$@"
