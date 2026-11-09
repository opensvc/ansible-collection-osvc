install_hb_unicast
==================

This role adds a unicast heartbeat to an OpenSVC v3 cluster, on a network of
its own, for example a dedicated interface or a second network path between
the sites, so that the loss of one network does not split the cluster.

Each node listens on its address of the heartbeat network and sends its
heartbeat dataset to the address of each peer, over tcp.

Role behavior
-------------

The role configures the `hb#<rid>` section with the address, and optionally
the interface, of each node, scoped to the node (`addr@<node>`,
`intf@<node>`), then waits for every node of the heartbeat to receive from
and send to its peers.

A receiver listens on all its addresses when the address of the node is not
set: two unicast heartbeats of the cluster using the same port can not both
listen. The role refuses a port already used by another unicast heartbeat of
the cluster, the default port included.

Only the keywords whose value differs are updated: the role can run again on a
configured cluster.

Requirements
------------

One or more Linux nodes, with OpenSVC v3 already installed, and grouped in a cluster.
The role provision_cluster can be used to meet the prerequisites.

Every node of the heartbeat must be a play host, with its
`install_hb_unicast_addr` host variable set.

Role Variables
--------------

`install_hb_unicast_rid`

Mandatory. The heartbeat section id, configured as `hb#<rid>`, made of
letters, digits, `-` and `_`.

`install_hb_unicast_state`

`present`, or `absent` to remove the heartbeat. Default value is `present`

`install_hb_unicast_addr`

A host variable, mandatory on each node of the heartbeat: the address of the
node on the heartbeat network.

`install_hb_unicast_intf`

An optional host variable: the interface of the node to bind.

`install_hb_unicast_port`

The tcp port, used by every node. Each unicast heartbeat of the cluster needs
its own port. Empty for the OpenSVC default, `10000`. Default value is `""`

`install_hb_unicast_nodes`

The nodes of the heartbeat, empty for all the cluster nodes. Default value is `[]`

`install_hb_unicast_timeout`

Optional. The delay after which a peer not heard of is declared stale, for
example `15s`. Empty value keeps the OpenSVC default.

`install_hb_unicast_interval`

Optional. The delay between two sends, for example `5s`.
Empty value keeps the OpenSVC default.

`install_hb_unicast_wait_timeout`

Seconds to wait for the heartbeat to beat on every node. Default value is `60`

Example Playbook
----------------

With the inventory:

    [clusternodes]
    node1 install_hb_unicast_addr=10.1.2.11
    node2 install_hb_unicast_addr=10.1.2.12

The snippet below can be used as a playbook:

    ---
    - hosts: clusternodes
      tasks:
        - name: Add a unicast heartbeat on the second network
          ansible.builtin.import_role:
            name: opensvc.cluster_v3.install_hb_unicast
          vars:
            install_hb_unicast_rid: "2"
            install_hb_unicast_port: 10001

License
-------

Apache-2.0

Author Information
------------------

OpenSVC Ansible Team <ansible@opensvc.com>
