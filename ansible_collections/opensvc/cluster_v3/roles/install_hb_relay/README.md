install_hb_relay
================

This role adds a relay heartbeat to an OpenSVC v3 cluster.

A relay is a standalone OpenSVC v3 server, usually hosted on a third site,
that the cluster nodes use as a mailbox to exchange their heartbeat datasets
over a different network path. It helps the cluster take the right quorum
decision when the sites hosting the nodes can not reach each other.

Requirements
------------

One or more Linux nodes, with OpenSVC v3 already installed, and grouped in a cluster.
The role provision_cluster can be used to meet the prerequisites.

A v3 relay server, reachable in https from all cluster nodes, with a user
account holding the `heartbeat` grant:

    om system/usr/relay create --kw grant=heartbeat
    om system/usr/relay key add --name=password --from /dev/urandom
    om system/usr/relay key decode --name=password

A v2 relay can not serve a v3 cluster.

Role Variables
--------------

`install_hb_relay_addr`

Mandatory. The relay server uri, for example `https://relay.acme.com:1215` or `relay.acme.com:3333`.
The port defaults to 1215 when not specified, even with a `https://` scheme.

`install_hb_relay_user`

The relay user account. Default value is `relay`

`install_hb_relay_password`

Mandatory. The relay user password, as set on the relay server.
The role fails when it is empty or set to `changeme`.

`install_hb_relay_rid`

The heartbeat section id, configured as `hb#<rid>`. Default value is `relay`

`install_hb_relay_secret`

The cluster secret object storing the relay password. Default value is `system/sec/relay`

`install_hb_relay_secret_key`

The key of the secret object storing the relay password. Default value is `password`

`install_hb_relay_timeout`

Optional. The delay after which a peer not read from the relay is declared stale, for example `15s`.
Empty value keeps the OpenSVC default.

`install_hb_relay_interval`

Optional. The delay between two posts to the relay, for example `5s`.
Empty value keeps the OpenSVC default.

`install_hb_relay_insecure`

Disable the relay certificate verification. For testing only. Default value is `false`

`install_hb_relay_wait_timeout`

Seconds to wait for the relay heartbeat to beat on every node. Default value is `60`

Example Playbook
----------------

The snippet below can be used as a playbook:

    ---
    - hosts: clusternodes
      tasks:
        - name: Add relay heartbeat
          ansible.builtin.import_role:
            name: opensvc.cluster_v3.install_hb_relay
          vars:
            install_hb_relay_addr: https://relay.acme.com
            install_hb_relay_user: mycluster
            install_hb_relay_password: "s3cr3t"

License
-------

Apache-2.0

Author Information
------------------

OpenSVC Ansible Team <ansible@opensvc.com>
