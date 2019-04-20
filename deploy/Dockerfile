FROM plugins/ansible

COPY ./ansible.cfg /.ansible.cfg
ADD . /root/.ansible
WORKDIR /root/.ansible

ENTRYPOINT [ "/bin/drone-ansible" ]