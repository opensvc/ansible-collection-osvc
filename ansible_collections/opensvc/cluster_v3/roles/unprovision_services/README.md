unprovision_services
====================

This role can be used to unprovision all services on a cluster. 

*Warning* This is a destructive action, once executed, all opensvc services are destroyed.

Requirements
------------

A group of Linux nodes, up and running, formed into an OpenSVC cluster

Role Variables
--------------

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
        - import_role:
            name: opensvc.cluster.unprovision_services
          vars:
            unprovision_services_purge_wait_time: 60s
 

License
-------

GPL-2.0-or-later

Author Information
------------------

OpenSVC Ansible Team <ansible@opensvc.com>
