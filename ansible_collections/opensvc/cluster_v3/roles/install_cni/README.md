install_cni
===========

This role deploys container network interface (https://github.com/containernetworking/cni) plugins binaries to a running OpenSVC cluster
On modern distributions, this role is not needed, because of native os package availability (containernetworking-plugins on Ubuntu, containernetworking-plugins on RHEL)

Requirements
------------

One or more Linux nodes, with OpenSVC already installed, and grouped in a cluster.
The role provision_cluster can be used to meet the prerequisites.

Role Variables
--------------

`install_cni_plugins_dir`

This variable specify the location where the CNI binaries will be installed after CNI tarball extraction.

Default value is `/usr/libexec/cni/bin`

`install_cni_config_dir`

This variable specify the location where the CNI configuration files will be located.

Default value is `/var/lib/opensvc/cni/net.d`

Example Playbook
----------------

The snippet below can be used as a playbook:

    - hosts: all
      tasks:
        - import_role:
            name: opensvc.cluster.install_cni
          vars:
            install_cni_plugins_dir: /usr/libexec/cni/bin
            install_cni_config_dir: /var/lib/opensvc/cni/net.d


License
-------

Apache-2.0

Author Information
------------------

OpenSVC Ansible Team <ansible@opensvc.com>
