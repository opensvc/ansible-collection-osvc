# OPENSVC DEMO

## Playbook v3

This playbook installs OpenSVC basics.

```
docker run --rm -v /home/opensvc/demo/ansible-collection-osvc/examples:/examples -it osvccol:11.1.0 ansible-playbook -v -i /examples/inventory.rhel10 /examples/demo/playbook.v3.yml
```

## Playbook drbd

This playbook provisions a DRBD service.

```
docker run --rm -v /home/opensvc/demo/ansible-collection-osvc/examples:/examples -it osvccol:11.1.0 ansible-playbook -v -i /examples/inventory.rhel10 /examples/demo/playbook.rhel_demo_drbd.yml
```

## Playbook haproxy

This playbook deploys an HAProxy service.

```
docker run --rm -v /home/opensvc/demo/ansible-collection-osvc/examples:/examples -it osvccol:11.1.0 ansible-playbook -v -i /examples/inventory.rhel10 /examples/demo/playbook.rhel_demo_haproxy.yml
```
