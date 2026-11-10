install_hb_multicast
====================

This role adds a multicast heartbeat to an OpenSVC v3 cluster, for example on
a dedicated interface, so that the loss of one network does not split the
cluster.

Each node sends its heartbeat dataset to a multicast group, over udp, and
listens to the group for the datasets of its peers. A single datagram reaches
all the nodes: the heartbeat does not need the address of each node, and
runs on all the cluster nodes.

Role behavior
-------------

The role configures the `hb#<rid>` section with the group address and port,
and optionally the interface of each node, scoped to the node (`intf@<node>`),
then waits for every cluster node to receive from and send to its peers.

Two multicast heartbeats of the cluster on the same group and port receive
the datagrams of each other: one would beat on the sends of the other, and
hide its own failure. The role refuses a group and port pair already used by
another multicast heartbeat of the cluster, the default pair included.

Only the keywords whose value differs are updated: the role can run again on a
configured cluster.

Requirements
------------

One or more Linux nodes, with OpenSVC v3 already installed, and grouped in a cluster.
The role provision_cluster can be used to meet the prerequisites.

The network must deliver the multicast datagrams between the nodes: the nodes
are in the same layer 2 network, or the routers forward the group. A switch
doing IGMP snooping needs an IGMP querier on the network, or it stops
forwarding the group a few minutes after the nodes joined it. The firewall of
the nodes must accept the udp port.

Role Variables
--------------

`install_hb_multicast_rid`

Mandatory. The heartbeat section id, configured as `hb#<rid>`, made of
letters, digits, `-` and `_`.

`install_hb_multicast_state`

`present`, or `absent` to remove the heartbeat. Default value is `present`

`install_hb_multicast_addr`

The multicast group address, IPv4 (`224.0.0.0/4`) or IPv6 (`ff00::/8`).
Empty for the OpenSVC default, `224.3.29.71`. Default value is `""`

`install_hb_multicast_port`

The udp port. Each multicast heartbeat of the cluster needs its own group
and port pair. Empty for the OpenSVC default, `10000`. Default value is `""`

`install_hb_multicast_intf`

An optional host variable: the interface of the node to send and listen on.
Empty for the interface of the route to the group address.

`install_hb_multicast_timeout`

Optional. The delay after which a peer not heard of is declared stale, for
example `15s`. Empty value keeps the OpenSVC default.

`install_hb_multicast_interval`

Optional. The delay between two sends, for example `5s`.
Empty value keeps the OpenSVC default.

`install_hb_multicast_wait_timeout`

Seconds to wait for the heartbeat to beat on every node. Default value is `60`

Example Playbook
----------------

With the inventory:

    [clusternodes]
    node1 install_hb_multicast_intf=eth1
    node2 install_hb_multicast_intf=eth1

The snippet below can be used as a playbook:

    ---
    - hosts: clusternodes
      tasks:
        - name: Add a multicast heartbeat on the second network
          ansible.builtin.import_role:
            name: opensvc.cluster_v3.install_hb_multicast
          vars:
            install_hb_multicast_rid: "2"
            install_hb_multicast_addr: 239.1.1.2
            install_hb_multicast_port: 10002

License
-------

Apache-2.0

Author Information
------------------

OpenSVC Ansible Team <ansible@opensvc.com>
