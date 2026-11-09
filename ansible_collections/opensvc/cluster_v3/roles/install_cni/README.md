install_cni
===========

This role sets up the [CNI](https://github.com/containernetworking/cni)
plugins of a running OpenSVC cluster.

The plugins already present on the nodes are used, like the ones of the
`containernetworking-plugins` packages of Ubuntu (`/usr/lib/cni`), RHEL and
SLES (`/usr/libexec/cni`): the role looks for the `install_cni_plugin_binaries`
plugins in the `install_cni_search_dirs` directories. When every node holds them
in the same directory, the role uses it, else it downloads the plugins into
`install_cni_plugins_dir`. It then points the `cni.plugins` and `cni.config`
cluster keywords to the plugins and configuration directories.

Requirements
------------

One or more Linux nodes, with OpenSVC already installed, and grouped in a cluster.
The role provision_cluster can be used to meet the prerequisites.

Role Variables
--------------

`install_cni_plugins_dir`

The directory where the downloaded plugins are installed.

Default value is `/usr/libexec/cni/bin`

`install_cni_config_dir`

This variable specify the location where the CNI configuration files will be located.

Default value is `/var/lib/opensvc/cni/net.d`

`install_cni_plugin_binaries`

The plugins to look for. Default value is `['macvlan', 'ipvlan', 'vlan', 'bridge']`

`install_cni_search_dirs`

The directories where the plugins may already be installed, in order of
preference. Default value is `install_cni_plugins_dir`, `/usr/lib/cni`,
`/usr/libexec/cni` and `/opt/cni/bin`

`install_cni_force`

Download the plugins into `install_cni_plugins_dir`, even when they are already
present. Default value is `false`

`install_cni_version`

The version of the plugins to download, among the `install_cni_download_url_version`
ones. Default value is `v1.6.2`

Example Playbook
----------------

The snippet below can be used as a playbook:

    - hosts: all
      tasks:
        - import_role:
            name: opensvc.cluster_v3.install_cni
          vars:
            install_cni_plugins_dir: /usr/libexec/cni/bin
            install_cni_config_dir: /var/lib/opensvc/cni/net.d


License
-------

Apache-2.0

Author Information
------------------

OpenSVC Ansible Team <ansible@opensvc.com>
