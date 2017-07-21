#!/bin/bash

set -e

# Add npm as command if needed
if [ "${1:0:1}" = '-' ]; then
	set -- npm "$@"
fi

if [ "$1" = 'new-plugin' ]; then
  sao kibana-plugin
fi

if [ "$1" = 'elasticsearch' ]; then
  npm run elasticsearch
fi

exec "$@"
