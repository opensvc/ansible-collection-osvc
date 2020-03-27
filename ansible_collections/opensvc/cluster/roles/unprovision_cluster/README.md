unprovision_cluster
===================

This role can be used to unprovision an opensvc cluster. 

*Warning* This is a destructive action, once executed, opensvc cluster is unconfigured and uninstalled.

Requirements
------------

A group of Linux nodes, up and running, formed into an OpenSVC cluster

Role Variables
--------------

None

Example Playbook
----------------

The snippet below can be used as a playbook:

    - hosts: all
      tasks:
        - import_role:
            name: opensvc.cluster.unprovision_cluster

License
-------

GPL-2.0-or-later

Author Information
------------------

OpenSVC Ansible Team <ansible@opensvc.com>
