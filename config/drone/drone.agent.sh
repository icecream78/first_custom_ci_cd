docker run \
  --volume=/var/run/docker.sock:/var/run/docker.sock \
  --env=DRONE_RPC_SERVER=http://192.168.50.5:8000 \
  --env=DRONE_RPC_SECRET=7nQDl8vLGWVLkaocVrcpD6PDdSJY542WOfn3amcBMprjgNUEFt2S3hsmSIAmlp4R8 \
  --env=DRONE_RUNNER_CAPACITY=2 \
  --env=DRONE_RUNNER_NAME=gogs_agent \
  --restart=always \
  --detach=true \
  --name=agent \
  drone/agent:1