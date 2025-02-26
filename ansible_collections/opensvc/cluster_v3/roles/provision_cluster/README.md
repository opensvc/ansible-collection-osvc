provision_cluster
=================

This role can be used to provision a simple OpenSVC cluster

Requirements
------------

A group of Linux nodes, up and running

Role Variables
--------------

`provision_cluster_clustername`

This variable is used to set a cluster unique name. Default value is `demo`.

Examples : prod01, demo, staging, 12723

`provision_cluster_hb_timeout`

This variable is used to set an expiration timeout to the default unicast heartbeat.
If a node does not receive heartbeat informations from its cluster peer after this period, it will start orchestration decisions, like starting a service.

Default value is `20s`.

`provision_cluster_update_etc_hosts`

update /etc/hosts to add each cluster node ip.
warning: cluster node name resolution is critical
=> false: you do the configuration by yourself
=> true: you expect the playbook to do the config

Default value is `false`.

`provision_cluster_configure_ssh_trust`

create a dedicated opensvc ssh keypair.
populate root authorized_keys file with public ssh keys.
=> false: do not configure ssh root trust accross cluster nodes. rsync sync resources and fs.type=flag resource won't work.
=> true: enable ssh trust autoconfig.

Default value is `false`.

`provision_cluster_configure_vip`

Enable the deployment of cluster virtual ip.
It is mandatory to provide other parameters, see below.

Default value is `false`.

`provision_cluster_vip_name`

Cluster floating ipv4 or ipv6 address. It must be different from node's ips, but reachable once configured on any cluster node.

Default value is `1.2.3.4`.

`provision_cluster_vip_netmask`

CIDR subnet mask associated with the vip address

Default value is `24`.

`provision_cluster_vip_dev`

Optional. It is the network interface (ip link list), on which the ip will be configured.

Default value is empty, and role automatically discover it.

`provision_cluster_vip_template`

Url to vip service template, which will be downloaded and started with custom parameters

Default value is `https://raw.githubusercontent.com/opensvc/opensvc_templates/refs/heads/main/vip/vip.conf`.

Example Playbook
----------------

The snippet below can be used as a playbook:

    - hosts: all
      tasks:
        - import_role:
            name: opensvc.cluster_v3.provision_cluster
          vars:
            provision_cluster_clustername: testcluster
            provision_cluster_hb_timeout: 25s

A more complex cluster playbook:

    - hosts: all
      tasks:
        - name: import role provision_cluster
          import_role:
            name: opensvc.cluster_v3.provision_cluster
          vars:
            provision_cluster_clustername: testcluster
            provision_cluster_hb_timeout: 25s
            provision_cluster_update_etc_hosts: true
            provision_cluster_configure_vip: true
            provision_cluster_vip_name: '1.2.3.4'
            provision_cluster_vip_netmask: '24'
 

License
-------

Apache-2.0

Author Information
------------------

OpenSVC Ansible Team <ansible@opensvc.com>
