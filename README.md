Список сайтов, которые использовались при развертывании CI/CD:
http://plugins.drone.io/drone-plugins/drone-docker/

https://docs.docker.com/registry/insecure/
https://github.com/docker/distribution/issues/948
https://www.digitalocean.com/community/tutorials/how-to-set-up-a-private-docker-registry-on-ubuntu-14-04
https://fogflow.readthedocs.io/en/latest/registry.html

Очень важная инфа по пулингу образов в drone из приватных реестров
https://discourse.drone.io/t/how-to-pull-private-images-with-1-0/3155

В дроне необходимо прописать переменные docker_username/docker_password для паблиша в локальный регистри в деплое, ansible_private_key с содержимым из файла ansible_ssh_key.
Для пуллинга из приватных репозиторий необходимо указать переменную dockerconfigjson с содержимым из файла.

Генерация серта для https
```
openssl req \
  -newkey rsa:4096 -nodes -sha256 -keyout registry_certs/domain.key \
  -x509 -days 365 -out registry_certs/domain.crt
```