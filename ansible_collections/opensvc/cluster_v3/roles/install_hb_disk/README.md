install_hb_disk
===============

This role adds a disk heartbeat to an OpenSVC v3 cluster: the nodes write
their heartbeat dataset to a slot of a shared disk and read the slots of their
peers, over the storage network, a path independent of the ip networks.

How the disk is used
--------------------

The disk starts with a signature, then the metadata area, `max_slots` pages of
4KiB where each node claims a slot, then the 1MiB data slots. It must be
dedicated to the heartbeats, and sized `max_slots` x 4KiB, plus 1MiB per node,
plus 1MiB: 7MiB for two nodes with the default 1024 slots.

Several clusters may share a disk, with the same `max_slots`: each node claims
its own slot. Signing a disk again makes the nodes already using it lose their
slots.

Role behavior
-------------

The role checks the disk on every node of the heartbeat. It refuses a disk
that is:

* not a block device
* used, by a partition, a device mapper or a mount
* too small
* seen differently by the nodes: another udev identity (`DM_UUID`, `ID_WWN`,
  `ID_SERIAL`), another signature or header
* not identified by udev, holding data in the signature or metadata area, or
  holding a signature known by `blkid`, unless `install_hb_disk_force` is set

It refuses to change `max_slots` of a configured heartbeat.

It then configures the `hb#<rid>` section and, when the disk is not signed
yet, signs it once, from the first node of the heartbeat. With
`install_hb_disk_force`, the metadata area is cleared before the disk is
signed. A disk already signed, by another cluster for example, is used as is.
The role waits for every node of the heartbeat to read from and write to the
disk.

With `install_hb_disk_state: absent`, the section is removed and the disk is
left signed, other clusters may use it: `om daemon hb wipe <rid>` removes the
signature of a configured heartbeat.

Only the keywords whose value differs are updated: the role can run again on a
configured cluster.

Requirements
------------

One or more Linux nodes, with OpenSVC v3 already installed, and grouped in a cluster.
The role provision_cluster can be used to meet the prerequisites.

A disk shared by the nodes, for example a multipath LUN. Every node of the
heartbeat must be a play host.

Role Variables
--------------

`install_hb_disk_rid`

Mandatory. The heartbeat section id, configured as `hb#<rid>`, made of
letters, digits, `-` and `_`.

`install_hb_disk_state`

`present`, or `absent` to remove the heartbeat. Default value is `present`

`install_hb_disk_dev`

Mandatory. The path of the shared disk, for example `/dev/mapper/<wwid>`.
Prefer a path stable across reboots and nodes. Set it as a host variable when
the path differs between the nodes: it is then scoped to each node
(`dev@<node>`). Default value is `""`

`install_hb_disk_max_slots`

The slots of the disk, at least twice the number of nodes using it. It must
not change once the disk is in use, and must be the same for every cluster
sharing the disk. Empty for the OpenSVC default, `1024`. Default value is `""`

`install_hb_disk_nodes`

The nodes of the heartbeat, empty for all the cluster nodes. Default value is `[]`

`install_hb_disk_timeout`

Optional. The delay after which a peer not read is declared stale, for example
`15s`. Empty value keeps the OpenSVC default.

`install_hb_disk_interval`

Optional. The delay between two writes, for example `5s`.
Empty value keeps the OpenSVC default.

`install_hb_disk_force`

Sign a disk holding data, a known signature, or not identified by udev on
every node. Its first `max_slots` x 4KiB and its data slots are overwritten.
Default value is `false`

`install_hb_disk_wait_timeout`

Seconds to wait for the heartbeat to beat on every node. Default value is `60`

Example Playbook
----------------

The snippet below can be used as a playbook:

    ---
    - hosts: clusternodes
      tasks:
        - name: Add a disk heartbeat
          ansible.builtin.import_role:
            name: opensvc.cluster_v3.install_hb_disk
          vars:
            install_hb_disk_rid: disk
            install_hb_disk_dev: /dev/mapper/36001405562f1e4bc38d4434b86aa53b2

License
-------

Apache-2.0

Author Information
------------------

OpenSVC Ansible Team <ansible@opensvc.com>
