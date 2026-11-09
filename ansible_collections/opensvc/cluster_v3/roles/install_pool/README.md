Role Name
=========

This role ensures a storage pool configuration of an OpenSVC cluster.

It configures `directory`, `loop`, `shm`, `virtual`, `vg`, `zpool` and `drbd`
pools, and refuses the other types. On a new or an existing pool, it sets the
keywords of the role variables, and only updates the ones whose value differs:
a pool configuration changed by hand is set back to the role variables values.
An empty variable leaves its keyword unmanaged.

| Type        | Keywords set by the variables              | Mandatory          |
|-------------|--------------------------------------------|--------------------|
| `directory` | `path`                                     |                    |
| `loop`      | `path`                                     |                    |
| `shm`       |                                            |                    |
| `virtual`   |                                            | `template`         |
| `vg`        | `name` (`install_pool_vg`)                 | `install_pool_vg`  |
| `zpool`     | `name` (`install_pool_zpool`)              | `install_pool_zpool` |
| `drbd`      | `path`, `vg`, `zpool`, `network`           |                    |

The other keywords of a pool type, like `quota`, `thin_pool`, `fs_type`,
`mode`, `template` or `max_peers`, are set with `install_pool_keywords`.

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

`install_pool_path`

Optional, `directory`, `loop` and `drbd` pools. The pool path. No default value: the
OpenSVC default is `/var/lib/opensvc/pool/directory` for a directory pool.

`install_pool_vg`

Optional, `drbd` and `vg` pools. The pool lvm volume group (the `vg` keyword
of a drbd pool, the `name` keyword of a vg pool). No default value.

`install_pool_zpool`

Optional, `drbd` and `zpool` pools. The pool zpool (the `zpool` keyword of a
drbd pool, the `name` keyword of a zpool pool). No default value.

`install_pool_network`

Optional, `drbd` pools. A backend network for the replication paths. Use node
public ips by default.

`install_pool_status_schedule`

Optional. The pool status schedule.

`install_pool_keywords`

Optional. Other pool keywords, as a dictionary, overriding the ones set by the
variables above. Example: `{quota: true}` for a directory pool. Default value
is `{}`.

`install_pool_force`

Optional. If set to true, set all the keywords, even when their value is
already the desired one. false by default.


Example Playbook
----------------

The snippet below can be used to configure a directory pool with quota
support, backed by the /data filesystem

    - hosts: all
      tasks:
        - import_role:
            name: opensvc.cluster_v3.install_pool
          vars:
            install_pool_name: dirpool
            install_pool_type: directory
            install_pool_path: /data
            install_pool_keywords:
              quota: true

The snippet below can be used to configure a directory pool backed by /data filesystem

    - hosts: all
      tasks:
        - import_role:
            name: opensvc.cluster_v3.install_pool
          vars:
            install_pool_name: dirpool
            install_pool_type: directory
            install_pool_path: /data

The snippet below can be used to configure a drbd pool backed by datavg lvm volume group 

    - hosts: all
      tasks:
        - import_role:
            name: opensvc.cluster_v3.install_pool
          vars:
            install_pool_name: drbdpool
            install_pool_type: drbd
            install_pool_vg: datavg

The snippet below can be used to configure a drbd pool backed by zfs zpool 

    - hosts: all
      tasks:
        - import_role:
            name: opensvc.cluster_v3.install_pool
          vars:
            install_pool_name: drbdpool
            install_pool_type: drbd
            install_pool_zpool: tank



License
-------

Apache-2.0

Author Information
------------------

OpenSVC Ansible Team <ansible@opensvc.com>
