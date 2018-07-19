#!/bin/sh

[[ -n "$DEBUG" ]] && set -x
set -e

if [[ `id -u` -ge 500 ]]; then
    adduser -h "$HOME" -u "$(id -u)" -G "$(id -gn)" -s /bin/ash rabbitmq
fi

echo "$RABBITMQ_ERLANG_COOKIE" > "$HOME/.erlang.cookie"
chmod 0600 "$HOME/.erlang.cookie"

if
  [[ -z $RABBITMQ_NODENAME ]] && \
  [[ -n $RABBITMQ_NODENAME_PREFIX ]] && \
  [[ -n $MY_POD_IP ]]
then
  export RABBITMQ_NODENAME="${RABBITMQ_NODENAME_PREFIX}@${MY_POD_IP}"
fi

docker-entrypoint.sh rabbitmq-server
