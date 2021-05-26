install_dns
===========

This role deploys an embedded dns service for OpenSVC cluster. It is used to serve accurate name services during the cluster life, when services and containers are started, stopped, or even relocated.

Requirements
------------

One or more Linux nodes, with OpenSVC already installed, and grouped in a cluster.
The roles provision_cluster can be used to meet the prerequisites.

Role Variables
--------------

`osvc_dns1_ip_addr`
`osvc_dns2_ip_addr`

These optional variables can be set to force the nodes ip addr that will operate de dns instances.
By default, those variables are filled in with the node main ip, taken from ansible facts.
Consider only the first variable for single node deployments.

Example Playbook
----------------

Example 1: use default nodes ip addr

    - hosts: all
      tasks:
        - import_role:
            name: opensvc.cluster.install_dns

Example 2: single node deployment with forced ip addr

    - hosts: all
      tasks:
        - import_role:
            name: opensvc.cluster.install_dns
          vars:
            osvc_dns1_ip_addr: 10.11.12.1

Example 3: dual nodes deployment with forced ip addr

    - hosts: all
      tasks:
        - import_role:
            name: opensvc.cluster.install_dns
          vars:
            osvc_dns1_ip_addr: 10.11.12.1
            osvc_dns2_ip_addr: 10.11.12.2


License
-------

GPL-2.0-or-later

Author Information
------------------

OpenSVC Ansible Team <ansible@opensvc.com>
