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

`osvc_update_etc_hosts`

update /etc/hosts to add each cluster node ip
=> false: you do the configuration by yourself
=> true: you expect the playbook to do the config

Default value is `false`.

`osvc_configure_vip`

Enable the deployment of cluster virtual ip.
It is mandatory to provide other parameters, see below.

Default value is `false`.

`osvc_cluster_vip_addr`

Cluster floating ipv4 or ipv6 address. It must be different from node's ips, but reachable once configured on any cluster node.

Default value is `1.2.3.4`.

`osvc_cluster_vip_cidr_subnet`

CIDR subnet mask associated with the vip address

Default value is `24`.

`osvc_cluster_vip_nic_name`

ip link name created to configure the cluster vip on.

Default value is `vipnic`.

`osvc_node_prd_nic`

physical device on which the vip nic name is attached.

Default value is `br0`.

`osvc_vip_external_fqdn`

public cluster fqdn associated with the vip
this field is added to the alt_names ssl certificate field

Default value is `vip.domain.com`.

`osvc_configure_webapp`

Enable the deployment of the embedded cluster web gui.

Default value is `false`.

`osvc_webapp_user`

cluster administrator login for webapp & api

Default value is `admin`.

`osvc_webapp_password`

cluster administrator password for webapp & api

Default value is `s3cr3t`.

`osvc_ca_cert_mode`

ssl certification authority mode.
webapp/api are served through tls / http/2
by default 'self' mode create a per-cluster CA and self-signed certs for 1215/tcp listener
other modes can be configured, please contact support@opensvc.com

Default value is `self`.

`osvc_ca_cert_name`

ssl certificate common name (CN) field

Default value is `TEST CLUSTER`.

`osvc_ca_cert_country`

ssl certificate country (C) field

Default value is `US`.

`osvc_ca_cert_org`

ssl certificate organization (O) field

Default value is `ACME Company`.


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

A more complex cluster playbook:

    - hosts: all
      tasks:
        - name: import role provision_cluster
          import_role:
            name: opensvc.cluster.provision_cluster
          vars:
            osvc_clustername: testcluster
            osvc_hb_timeout: 25s
            osvc_update_etc_hosts: true
            osvc_configure_webapp: true
            osvc_configure_vip: true
            osvc_cluster_vip_addr: '1.2.3.4'
            osvc_cluster_vip_cidr_subnet: '24'
            osvc_cluster_vip_nic_name: 'vippe'
            osvc_node_prd_nic: 'enp1s0'
            osvc_vip_external_fqdn: 'vip-cluster.opensvc.org'
            osvc_webapp_user: 'webadmin'
            osvc_webapp_password: 's3cr3t'
            osvc_ca_cert_name: 'TEST CLUSTER'
            osvc_ca_cert_country: 'FR'
            osvc_ca_cert_org: 'The Cluster Company'
 

License
-------

GPL-2.0-or-later

Author Information
------------------

OpenSVC Ansible Team <ansible@opensvc.com>
