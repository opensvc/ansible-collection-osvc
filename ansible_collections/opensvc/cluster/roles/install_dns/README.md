install_dns
===========

This role deploys an embedded dns service for OpenSVC cluster. It is used to serve accurate name services during the cluster life, when services and containers are started, stopped, or even relocated.

Requirements
------------

One or more Linux nodes, with OpenSVC already installed, and grouped in a cluster.
The roles provision_cluster can be used to meet the prerequisites.

Role Variables
--------------

None

Example Playbook
----------------

Example 1: use default nodes ip addr

    - hosts: all
      tasks:
        - import_role:
            name: opensvc.cluster.install_dns


License
-------

Apache-2.0

Author Information
------------------

OpenSVC Ansible Team <ansible@opensvc.com>
