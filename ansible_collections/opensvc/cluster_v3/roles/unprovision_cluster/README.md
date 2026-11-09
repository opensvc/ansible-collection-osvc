unprovision_cluster
===================

This role can be used to unprovision an opensvc cluster.

*Warning* This is a destructive action, once executed, opensvc cluster is unconfigured and uninstalled.

The opensvc-server and opensvc-client packages are removed. The OpenSVC
configuration and data, and the other files added by provision_cluster, are
kept unless `unprovision_cluster_purge` is set.

The role fails without changing anything when services or volumes are still
defined on the cluster. Purge them first, for example with the
unprovision_services role. The objects are listed by a running daemon, else
from their configuration files on the nodes.

Requirements
------------

A group of Linux nodes, up and running, formed into an OpenSVC cluster

Role Variables
--------------

`unprovision_cluster_purge`

Also remove the OpenSVC configuration and data: the package configuration files on Debian and Ubuntu,
`/etc/opensvc`, `/var/lib/opensvc`, `/var/log/opensvc` and the other OpenSVC files.

Also remove the files added by provision_cluster: the OpenSVC package
repository, the sysrq setting (the running kernel keeps it until the next
boot), the cluster nodes block of `/etc/hosts`, and `/etc/docker/daemon.json`
when it is the one of `provision_cluster_deploy_docker_daemon_json`, docker
being restarted then. The repository signing key is kept.

Default value is `false`.

Example Playbook
----------------

The snippet below can be used as a playbook:

    - hosts: all
      tasks:
        - name: Unprovision the cluster, removing its configuration and data
          ansible.builtin.import_role:
            name: opensvc.cluster_v3.unprovision_cluster
          vars:
            unprovision_cluster_purge: true

License
-------

Apache-2.0

Author Information
------------------

OpenSVC Ansible Team <ansible@opensvc.com>
