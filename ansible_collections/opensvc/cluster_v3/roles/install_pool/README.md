Role Name
=========

This role ensure storage pool configuration for a OpenSVC cluster

Requirements
------------

OpenSVC cluster up and running.

Role Variables
--------------

`install_pool_name`

The cluster pool name.

Default value is `pool`

`install_pool_type`

The cluster pool type.

Default value is `directory`

`osvc_pool_path`

Optional. The cluster pool path.

Default value is `/var/lib/opensvc/pool/directory`

`osvc_pool_vg`

Optional. The cluster pool volume group. No default value.

`install_pool_zpool`

Optional. The cluster pool zpool. No default value.

`install_pool_network`

Optional. For DRBD pools, it allow to specify a backend network for replication paths. Use node public ips by default.


Example Playbook
----------------

The snippet below can be used to configure a directory pool backed by /data filesystem

    - hosts: all
      tasks:
        - import_role:
            name: opensvc.cluster.install_pool
          vars:
            install_pool_name: dirpool
            install_pool_type: directory
            osvc_pool_path: /data

The snippet below can be used to configure a drbd pool backed by datavg lvm volume group 

    - hosts: all
      tasks:
        - import_role:
            name: opensvc.cluster.install_pool
          vars:
            install_pool_name: drbdpool
            install_pool_type: drbd
            osvc_pool_vg: datavg

The snippet below can be used to configure a drbd pool backed by zfs zpool 

    - hosts: all
      tasks:
        - import_role:
            name: opensvc.cluster.install_pool
          vars:
            install_pool_name: drbdpool
            install_pool_type: drbd
            install_pool_zpool: tank



License
-------

GPL-2.0-or-later

Author Information
------------------

OpenSVC Ansible Team <ansible@opensvc.com>
