install_slapos_comp1
====================

SlapOS https://slapos.nexedi.com/ is a distributed, service oriented, operating system. It is composed of 2 kinds of components, master and slave nodes. SlapOS can afford the loss of master node for a few hours, but the loss of a slave worker node involves a service outage.

This role enables automated deployment of highly available SlapOS slave node, using OpenSVC cluster and Linbit DRBD data replication.

It configures OpenSVC cluster, deploy Re6st component (ipv6 mesh network, needed by SlapOS), and then deploy SlapOS.

The SlapOS comp1 component is embedded in an OpenSVC service, allowing SlapOS administrator to move the service from one cluster node to another, or also to survive to a server issue (crash, poweroff, ...)


Requirements
------------

Any pre-requisites that may not be covered by Ansible itself or the role should be mentioned here. For instance, if the role uses the EC2 module, it may be a good idea to mention in this section that the boto package is required.

* 2 nodes Ubuntu 22.04 LTS
* hard disk drive sized for operating system usage + SlapOS needs
* Re6st token
* SlapOS token

Role Variables
--------------

### opensvc
`osvc_slapos_comp1_namespace`

This variable sets the target opensvc namespace.

Default value is `slapos`.

`osvc_slapos_comp1_name`

This variable sets the target opensvc service name.

Default value is `comp1`.

`osvc_slapos_comp1_svcpath`

This variable sets the target opensvc service path.

Default value is `{{ osvc_slapos_comp1_namespace }}/svc/{{ osvc_slapos_comp1_name }}` and should not be changed.

`osvc_slapos_comp1_cfgpath`

This variable sets the target opensvc configmap path.

Default value is `{{ osvc_slapos_comp1_namespace }}/cfg/{{ osvc_slapos_comp1_name }}` and should not be changed.

`osvc_slapos_comp1_data_size`

This variable sets the drbd volume size. Must be sized according to SlapOS deployments requirements (from a few GB to many TB)

Default value is `2GB` and should be set to fit your needs.

---
### re6st

`osvc_re6st_installer_url`

This variable sets the re6st installer url, which is downloaded and executed during role deployment.

Default value is `https://deploy.erp5.net/gnet/re6st`.

`osvc_re6st_token`

This variable sets the re6st token. Check [re6st token request howto](https://handbook.rapid.space/rapidspace-HowTo.Request.A.Freefib.Token).

Default value is `notoken`.

`osvc_re6st_router_advertisement`

This variable triggers the re6st router advertisement.

Default value is `no`.

---
### slapos

`osvc_slapos_comp1_installer_url`

This variable sets the SlapOS installer url, which is downloaded and executed during role deployment.

Default value is `https://deploy.rapid.space/slapos-base`.

`osvc_slapos_comp1_master_url`

This variable sets the SlapOS master url. It is used to register the slave node into the SlapOS master node.

Default value is `https://slap.vifib.com/`.

`osvc_slapos_comp1_web_master_url`

This variable sets the SlapOS console url. It is used to register the slave node into the web management console.

Default value is `https://panel.rapid.space/`.

`osvc_slapos_comp1_computer_name`

This variable sets the SlapOS node name, which will appear in the web console.

Default value is `noname`. Do not try to register a same node name twice without revoking the node certificate in the web console first.

`osvc_slapos_token`

This variable sets the SlapOS token. Check [SlapOS node install procedure](https://slapos.nexedi.com/slapos-Tutorial.Install.Slapos.Node.Comp.123) in the `Get SlapOS Master Token` section.

Default value is `notoken`.

`osvc_slapos_interface_name`

This variable sets the SlapOS nic name to use to contact master.

Default value is `lo`.

`osvc_slapos_partition_number`

This variable sets the target partition count to deploy.

Default value is `10`.

Dependencies
------------

- opensvc.cluster.provision_cluster
- opensvc.cluster.install_drbd

Example Playbook
----------------

    - hosts: clusternodes
      gather_facts: true
      tasks:
        - name: Provision OpenSVC cluster
          import_role:
            name: opensvc.cluster.provision_cluster
          vars:
            osvc_clustername: democluster
            osvc_hb_timeout: 30s
            osvc_update_etc_hosts: true
            osvc_configure_webapp: false
            osvc_configure_vip: false

        - name: Add Linbit DRBD replication features
          import_role:
            name: opensvc.cluster.install_drbd

        - name: Provision High Availability Nexedi SlapOS comp1
          import_role:
            name: opensvc.app.install_slapos_comp1
          vars:
            osvc_re6st_token: 218408gtusliazertydjybpamx
            osvc_slapos_comp1_data_size: 20GB
            osvc_slapos_token: 20230912-26280B3
            osvc_slapos_comp1_computer_name: comp1ha
            osvc_slapos_partition_number: 5



License
-------

Apache-2.0

Author Information
------------------

OpenSVC Ansible Team <ansible@opensvc.com>
