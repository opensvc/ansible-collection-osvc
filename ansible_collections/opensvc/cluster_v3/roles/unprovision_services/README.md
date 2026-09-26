unprovision_services
====================

This role can be used to unprovision all services on a cluster.

**Warning: this is a destructive action. Once executed, all opensvc services are destroyed, with their data.**

The role lists the objects to purge, and fails without changing anything unless
`unprovision_services_confirm` is set to `true`.

Every object is purged except the ones the cluster itself needs, which are kept:

* the `cluster` configuration
* the `system/sec/ca`, `system/sec/cert`, `system/sec/hb` and `system/sec/relay` secrets
* the users, `system/usr/*`
* the secrets referenced by the relay heartbeats

The cluster is frozen during the purge, and thawed afterwards, unless it was already frozen before.

Requirements
------------

A group of Linux nodes, up and running, formed into an OpenSVC cluster

Role Variables
--------------

`unprovision_services_confirm`

Must be set to `true` for the role to purge the services. Default value is `false`.

`unprovision_services_purge_wait_time`

This variable is the time to wait for services to be destroyed. Default value is `120s`.

`unprovision_services_purge_retries`
`unprovision_services_purge_delay`

Those variables are used to loop across final checks, to verify that services are no more present.
Default values are `10` retries, with a `10` seconds wait time between each try.

Example Playbook
----------------

The snippet below can be used as a playbook:

    - hosts: all
      tasks:
        - name: Unprovision all services
          ansible.builtin.import_role:
            name: opensvc.cluster_v3.unprovision_services
          vars:
            unprovision_services_confirm: true
            unprovision_services_purge_wait_time: 60s
 

License
-------

Apache-2.0

Author Information
------------------

OpenSVC Ansible Team <ansible@opensvc.com>
