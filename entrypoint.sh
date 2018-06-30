#!/bin/bash

set -e

# Add npm as command if needed
if [ "${1:0:1}" = '-' ]; then
	set -- yarn "$@"
fi

if [ "$1" = 'new-plugin' ]; then
  node kibana/scripts/generate_plugin "$@"
fi

exec "$@"
