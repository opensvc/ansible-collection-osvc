install_envoy
=============

This role deploys an embedded envoy service for OpenSVC cluster. It provides ingress gateway features.

Requirements
------------

One or more Linux nodes, with OpenSVC already installed, and grouped in a cluster.
The roles provision_cluster can be used to meet the prerequisites.

Role Variables
--------------

None

Example Playbook
----------------

Example 1: 

    - hosts: all
      tasks:
        - import_role:
            name: opensvc.cluster.install_envoy

License
-------

GPL-2.0-or-later

Author Information
------------------

OpenSVC Ansible Team <ansible@opensvc.com>
