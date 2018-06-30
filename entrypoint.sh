#!/bin/bash

set -e

# Add npm as command if needed
if [ "${1:0:1}" = '-' ]; then
	set -- yarn "$@"
fi

if [ "$1" = 'new-plugin' ]; then
  shift
  set -- node kibana/scripts/generate_plugin "$@"
fi

if [ "$1" = 'elasticsearch' ]; then
	set -- yarn es snapshot # --license oss # -E
fi

exec "$@"
