#!/bin/sh

docker run -d \
  -p 5000:5000 \
  --restart=always \
  --name registry \
  -e REGISTRY_AUTH=htpasswd \
  -e REGISTRY_AUTH_HTPASSWD_PATH=/auth/htpasswd \
  -e REGISTRY_AUTH_HTPASSWD_REALM='Registry Realm' \
  --volume=/var/lib/registry:/var/lib/registry \
  --volume=/auth:/auth \
  registry:2