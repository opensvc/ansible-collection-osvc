provision_cluster
=================

This role can be used to provision a simple OpenSVC cluster

Requirements
------------

A group of Linux nodes, up and running

Role Variables
--------------

`osvc_clustername`

This variable is used to set a cluster unique name. Default value is `demo`.

Examples : prod01, demo, staging, 12723

`osvc_hb_timeout`

This variable is used to set an expiration timeout to the default unicast heartbeat.
If a node does not receive heartbeat informations from its cluster peer after this period, it will start orchestration decisions, like starting a service.

Default value is `20s`.

Example Playbook
----------------

The snippet below can be used as a playbook:

    - hosts: all
      tasks:
        - import_role:
            name: opensvc.cluster.provision_cluster
          vars:
            osvc_clustername: testcluster
            osvc_hb_timeout: 25s
 

License
-------

GPL-2.0-or-later

Author Information
------------------

OpenSVC Ansible Team <ansible@opensvc.com>
