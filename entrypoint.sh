#!/bin/bash
set -e

if [ "$1" = 'new-plugin' ]; then
  sao kibana-plugin
fi

if [ "$1" = 'elasticsearch' ]; then
  npm run elasticsearch
fi

exec "$@"
