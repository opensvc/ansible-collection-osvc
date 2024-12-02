Role Name
=========

This role ensure backend network configuration for a OpenSVC cluster

Requirements
------------

OpenSVC cluster up and running.

Role Variables
--------------

`osvc_backend_subnet_name`

The cluster backend network name.

Default value is `backend`

`osvc_backend_subnet_range`

The cluster backend network range. The routed_bridge driver fragments this into `osvc_backend_subnet_ips_per_node` blocks subnets.

Default value is `10.100.0.0/16`

`osvc_backend_subnet_ips_per_node`

The number of allocatable ips per node on the network.

Default value is `1024`

`osvc_backend_tunnel`

Create and route trafic through tunnels to peer nodes policy. `auto` tunnel if the peer is not in the same subnet, `always` tunnel even if the peer seems to be in the same subnet (some hosting providers require this as traffic goes through router even between adjacent nodes. `never` tunnel is also possible.

Default value is `auto`

Example Playbook
----------------

The snippet below can be used as a playbook:

    - hosts: all
      tasks:
        - import_role:
            name: opensvc.cluster.install_backend_network
          vars:
            osvc_backend_subnet_name: backendnet
            osvc_backend_subnet_range: 10.123.0.0/16
            osvc_backend_subnet_ips_per_node: 4096
            osvc_backend_tunnel: auto

With the previous inputs on a 2-nodes cluster, the role will configure a network named `backendnet`.

The subnet `10.123.0.0/20` will be assigned to the first cluster node (4096 ip addr)

The subnet `10.123.16.0/20` will be assigned to the second cluster node (4096 ip addr)

License
-------

GPL-2.0-or-later

Author Information
------------------

OpenSVC Ansible Team <ansible@opensvc.com>
