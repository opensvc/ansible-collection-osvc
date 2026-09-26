unprovision_cluster
===================

This role can be used to unprovision an opensvc cluster.

*Warning* This is a destructive action, once executed, opensvc cluster is unconfigured and uninstalled.

The opensvc-server and opensvc-client packages are removed. The OpenSVC
package repository is kept. The OpenSVC configuration and data are kept
unless `unprovision_cluster_purge` is set.

The role fails without changing anything when services or volumes are still
defined on the cluster. Purge them first, for example with the
unprovision_services role.

Requirements
------------

A group of Linux nodes, up and running, formed into an OpenSVC cluster

Role Variables
--------------

`unprovision_cluster_purge`

Also remove the OpenSVC configuration and data: the package configuration files on Debian and Ubuntu,
`/etc/opensvc`, `/var/lib/opensvc`, `/var/log/opensvc` and the other OpenSVC files.

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
