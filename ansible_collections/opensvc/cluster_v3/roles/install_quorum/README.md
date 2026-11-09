install_quorum
==============

This role configures the quorum of an OpenSVC v3 cluster: the vote of the
nodes when the cluster is split (`cluster.quorum`), the action of the nodes
without the majority of the votes (`node.split_action`), and the arbitrators
giving their vote to the nodes reaching them (`arbitrator#<name>` sections).

How the vote works
------------------

A node is split when it sees half of the nodes or less. With the quorum
enabled and the node not frozen, it counts its votes: the live nodes it sees,
itself included, plus the weight of each arbitrator it reaches. When the votes
are not more than half of the total, the number of nodes plus the weight of
all the arbitrators, it runs the split action: `crash` (default), `reboot` or
`disabled` (test only).

For example, two nodes and one arbitrator of weight 1 count 3 votes. When a
site is lost, the node of the other site reaching the arbitrator has 2 votes
out of 3 and keeps running. Without the arbitrator, each node of a split two
nodes cluster has 1 vote out of 2 and both stop.

With an even number of nodes, the part of a split in two equal parts keeping
the quorum must reach more than half of the arbitrators weight. Several
arbitrators add redundancy only when the loss of any one of them keeps that
true: two arbitrators of weight 1 count 4 votes with two nodes, and the
surviving node needs both of them, 3 votes out of 4. Prefer one arbitrator,
or an odd number of arbitrators of equal weight: with three, the surviving
node still has 3 votes out of 5 when one of them is down.

The role refuses an even number of nodes with no arbitrator, or with several
arbitrators of which the heaviest weighs half of their total weight or more,
unless `install_quorum_allow_even_split` is set.

The arbitrators count in the total: with an odd number of nodes, the side
with the majority of the nodes may also need an arbitrator to keep the
majority of the votes.

Arbitrators
-----------

An arbitrator uri without http scheme is checked by a tcp connection, on the
`listener.port` of the cluster (1215 by default) when the uri has no port, for
example to the listener of a standalone OpenSVC v3 server. An arbitrator still
served by a v2 agent must name its 1214 port. A http or https uri is checked by
a GET request: any http answer is a vote, only connection and certificate
errors are not.

The arbitrators must be hosted on a third site, close enough to each other to
not be reachable from both parts of a split cluster, but not on the same rack
and power lines. The nodes check them every 60s and alert on failures.

Role behavior
-------------

The role configures the arbitrators, waits for every cluster node to see them
up, then enables the quorum. It fails before enabling the quorum when an
arbitrator is not reached by every node, and the arbitrators configured before
the failure are kept. When a split action is requested, it checks every node
applies it.

With `install_quorum_enabled: false`, the quorum is disabled before the
arbitrators are changed.

Only the keywords whose value differs are updated: the role can run again on a
configured cluster.

Requirements
------------

One or more Linux nodes, with OpenSVC v3 already installed, and grouped in a cluster.
The role provision_cluster can be used to meet the prerequisites.

Role Variables
--------------

`install_quorum_enabled`

Enable the quorum (`cluster.quorum`). Default value is `true`

`install_quorum_split_action`

The action of a node without the quorum (`node.split_action`): `crash`,
`reboot`, or `disabled`, for test only, set for all the nodes. The role fails
when a node overrides it in its `node.conf`.

Empty leaves it unmanaged: the OpenSVC default, `crash`, applies, or the value
set in the configuration, for example in the `node.conf` of a node whose power
on is not easy, set to `reboot`. Default value is `""`

`install_quorum_arbitrators`

The arbitrators, a list of dictionaries with the keys:

* `name`: mandatory, the section name `arbitrator#<name>`, made of letters, digits, `-` and `_`
* `uri`: mandatory, for example `arbitrator.acme.com`, `arbitrator.acme.com:1214` or `https://arbitrator.acme.com/`
* `weight`: the votes of the arbitrator. Default value is `1`
* `insecure`: disable the certificate verification of a https uri, for testing only. Default value is `false`

Default value is `[]`

`install_quorum_exclusive`

Remove the `arbitrator#*` sections not listed in `install_quorum_arbitrators`.
Default value is `false`

`install_quorum_allow_even_split`

Enable the quorum of a cluster with an even number of nodes and no
arbitrator, or several arbitrators of which the loss of one makes a split in
two equal parts stop every node. Default value is `false`

`install_quorum_wait_timeout`

Seconds to wait for every node to see the arbitrators up. Default value is `90`

Example Playbook
----------------

The snippet below can be used as a playbook:

    ---
    - hosts: clusternodes
      tasks:
        - name: Configure the quorum
          ansible.builtin.import_role:
            name: opensvc.cluster_v3.install_quorum
          vars:
            install_quorum_arbitrators:
              - name: site3
                uri: arbitrator.acme.com

To disable the quorum and remove the arbitrators:

    install_quorum_enabled: false
    install_quorum_arbitrators: []
    install_quorum_exclusive: true

License
-------

Apache-2.0

Author Information
------------------

OpenSVC Ansible Team <ansible@opensvc.com>
