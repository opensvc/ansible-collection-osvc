
# Ansible Collection Development Repository


[OpenSVC](https://www.opensvc.com/) supports Ansible for cluster deployment and configuration. This repository includes an Ansible collection with multiple roles and example playbooks, allowing users to easilly build OpenSVC clusters. It is also organised to develop and contribute to this project. Please refer to [Getting Started](#getting-started) section of this readme.

## Ansible Collections

Please refer to [Ansible Collections Documentation](https://docs.ansible.com/ansible/latest/dev_guide/developing_collections.html#developing-collections) for any questions related to this new way of delivering Ansible contents (introduced by ansible version `2.9.0`)

## Getting Started

There are multiple ways of using the collection, they are described below

### Prerequisites

This repository requires some products to be installed:

__Collection usage__
- python interpreter `2.7` and `3.6+`
- ansible >= `2.9.0`
- docker

----


###  Option 1 : Using [Ansible Galaxy](https://galaxy.ansible.com/) and `ansible-galaxy` to install the collection

```shell
$ ansible-galaxy collection install opensvc.cluster
Process install dependency map
Starting collection install process
Installing 'opensvc.cluster:0.0.1' to '~/.ansible/collections/ansible_collections/opensvc/cluster'
```

----


### Option 2 : Installing the collection from the git repository

You can git clone this repository, and build yourself the collection, to finally install it

__Git clone the repo__

```shell
user@node:~/dev$ git clone https://github.com/opensvc/ansible-collection-osvc.git
```

__Install the collection__

```shell
user@node:~/dev$ cd ansible-collection-osvc
user@node:~/dev/ansible-collection-osvc$ ansible-galaxy collection build --force ansible_collections/opensvc/cluster
user@node:~/dev/ansible-collection-osvc$ ansible-galaxy collection install opensvc-cluster-<VERSION>.tar.gz
```

Some example playbooks are available in the `examples` folder. After updating the `inventory` file to reflect your environment, you can run a playbook with the command below:

```shell
$ cd examples
$ ansible-playbook -i inventory playbook.yml
```

Please refer to [OpenSVC Galaxy Documentation](https://galaxy.ansible.com/opensvc) for more detailed usages of the collection.

----


### Option 3 : Testing/Contributing to the collection

__Git clone the repo__

```shell
user@node:~/dev$ git clone https://github.com/opensvc/ansible-collection-osvc.git
```

You can contribute to this collection by using the development environment:

1. Implement changes, patches, to the collection structure `ansible-collection-osvc/ansible_collections/*`. You don't have to commit your changes for testing purposes.
2. Build the docker image
  * install all prerequisites
  * embedds the current collection with your changes
    ```shell
    user@node:~/dev$ cd ansible-collection-osvc
    user@node:~/dev/ansible-collection-osvc$ docker build -t osvccol:test .
    ```
3. Spawn a docker container using the new image, and start testing your changes using the bind mounted `examples` directory
    ```shell
    user@node:~/dev/ansible-collection-osvc$ docker run --rm -v $HOME/dev/ansible-collection-osvc/examples:/examples -it osvccol:stable /bin/sh
    /examples # 
    ```
4. Update `inventory` and `ssh.private.key` files
    ```shell
    /examples # ls -l
    total 40
    -rw-r--r--    1 1000     1000           140 Mar 25 16:42 ansible.cfg
    -rw-r--r--    1 1000     1000           226 Mar 25 16:08 inventory
    -rw-r--r--    1 1000     1000           233 Mar 25 16:36 playbook-provision-cluster.yml
    -rw-r--r--    1 1000     1000           151 Mar 23 11:17 playbook-unprovision-cluster.yml
    -rw-r--r--    1 1000     1000           152 Mar 23 11:23 playbook-unprovision-services.yml
    -rwx------    1 1000     1000          3243 Mar 23 09:23 ssh.private.key
    ```
    **Note:** You must create the `ssh.private.key` file with your personal private key, to make ssh connection work fine.

    ```shell
    /examples # cat inventory 
    [clusternodes]
    demo1.acme.com ansible_host="1.1.1.1" ansible_ssh_private_key_file="ssh.private.key"
    demo2.acme.com ansible_host="2.2.2.2" ansible_ssh_private_key_file="ssh.private.key"
    
    [webservers]
    web1.acme.com
    web2.acme.com
    
    [dbservers]
    db1.acme.com
    db2.acme.com
    ```
5. Run a playbook to provision a cluster using members of the `clusternodes` group
    ```shell
    /examples # ansible-playbook -i inventory playbook-provision-cluster.yml --limit clusternodes
    ```

If your changes are ok, and you want to share them with the community, then you can submit a pull request.

If you need to rework your changes, just follow those steps :

1. Exit the docker container with `exit` or `CTRL+d`
2. Fix your code
3. Update the docker image
    ```shell
    user@node:~/dev/ansible-collection-osvc$ docker build -t osvccol:test .
    ```
4. Spawn a new docker container
    ```shell
    user@node:~/dev/ansible-collection-osvc$ docker run --rm -v $HOME/dev/ansible-collection-osvc/examples:/examples -it osvccol:stable /bin/sh
    ```
5. Repeat your tests
    ```shell
    /examples # ansible-playbook -i inventory playbook-provision-cluster.yml --limit clusternodes
    ```

----

### Note

The `Dockerfile` ends with a call to an entrypoint `docker-entrypoint.sh` which by default run a syntax check and lint every playbook found in the `examples` directory.

```shell
user@node:~/dev/ansible-collection-osvc$ docker run --rm -v $PWD/examples:/examples -it osvccol:test

=> Start syntax checking & linting for playbook playbook-provision-cluster-with-relay-heartbeat.yml

playbook: playbook-provision-cluster-with-relay-heartbeat.yml
Examining playbook-provision-cluster-with-relay-heartbeat.yml of type playbook
=> End of syntax checking & linting for playbook playbook-provision-cluster-with-relay-heartbeat.yml

=> Start syntax checking & linting for playbook playbook-provision-cluster.yml

playbook: playbook-provision-cluster.yml
Examining playbook-provision-cluster.yml of type playbook
=> End of syntax checking & linting for playbook playbook-provision-cluster.yml

=> Start syntax checking & linting for playbook playbook-unprovision-cluster.yml

playbook: playbook-unprovision-cluster.yml
Examining playbook-unprovision-cluster.yml of type playbook
=> End of syntax checking & linting for playbook playbook-unprovision-cluster.yml

=> Start syntax checking & linting for playbook playbook-unprovision-services.yml

playbook: playbook-unprovision-services.yml
Examining playbook-unprovision-services.yml of type playbook
=> End of syntax checking & linting for playbook playbook-unprovision-services.yml
```
