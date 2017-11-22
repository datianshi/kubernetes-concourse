#!/bin/bash

mkdir -p /concourse-keys

command=$1 

if [ "$command" = "web" ]
then
  echo "$CONCOURSE_TSA_PUBLIC_KEY" > /concourse-keys/tsa_host_key.pub
  echo "$CONCOURSE_TSA_AUTHORIZED_KEYS" > /concourse-keys/authorized_worker_keys
  echo "$CONCOURSE_SESSION_SIGNING_KEY" > /concourse-keys/session_signing_key
  echo "$CONCOURSE_TSA_HOST_KEY" > /concourse-keys/tsa_host_key
elif [ "$command" = "worker" ]
then
  echo "$CONCOURSE_TSA_PUBLIC_KEY" > /concourse-keys/tsa_host_key.pub
  echo "$CONCOURSE_TSA_WORKER_PRIVATE_KEY" > /concourse-keys/worker_key
else
  "COMMAND needs to be either web or worker"
fi 




