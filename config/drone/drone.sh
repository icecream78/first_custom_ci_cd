#!/bin/sh

docker run \
  --volume=/var/run/docker.sock:/var/run/docker.sock \
  --volume=/var/lib/drone:/data \
  --env=DRONE_GIT_ALWAYS_AUTH=true \
  --env=DRONE_GOGS_SKIP_VERIFY=false \
  --env=DRONE_GOGS_SERVER=http://192.168.50.4:3000 \
  --env=DRONE_RUNNER_CAPACITY=2 \
  --env=DRONE_SERVER_HOST=192.168.50.5 \
  --env=DRONE_SERVER_PROTO=http \
  --env=DRONE_TLS_AUTOCERT=true \
  --env=DRONE_RPC_SECRET=7nQDl8vLGWVLkaocVrcpD6PDdSJY542WOfn3amcBMprjgNUEFt2S3hsmSIAmlp4R8 \
  --publish=8000:80 \
  --publish=4430:443 \
  --restart=always \
  --detach=true \
  --name=drone \
  drone/drone:1