install_drbd
============

Prepares the nodes for DRBD 9 backed OpenSVC pools: installs DRBD 9 when no
DRBD 9 kernel module is installed yet, loads the module, filters the drbd
devices out of the LVM scans, and disables the drbd systemd unit (OpenSVC
drives the DRBD resources).

A node already providing a DRBD 9 module is left as is, whatever its source.
The distribution kernels may ship a DRBD 8.4 module: it is not accepted, and
DRBD 9 is installed.

DRBD 9 sources
--------------

| Distribution    | `install_drbd_linbit_key` unset          | `install_drbd_linbit_key` set |
|-----------------|------------------------------------------|-------------------------------|
| Ubuntu >= 22.04 | LINBIT ppa (`install_drbd_ppa`)          | LINBIT repositories           |
| Ubuntu 20.04    | unsupported, the ppa has no packages     | LINBIT repositories           |
| Debian          | unsupported, install DRBD 9 beforehand   | LINBIT repositories           |
| RHEL 8, 9, 10   | ELRepo                                   | LINBIT repositories           |
| RHEL 7          | unsupported, install DRBD 9 beforehand   | LINBIT repositories           |

The LINBIT repositories are the official LINBIT customer repositories, reached
with the enabler code of the LINBIT subscription.

Role Variables
--------------

| Variable | Default | Description |
|----------|---------|-------------|
| `install_drbd_linbit_key` | `""` | LINBIT customer repository enabler code. When set, DRBD 9 is installed from the LINBIT repositories. |
| `install_drbd_linbit_url` | `https://packages.linbit.com` | LINBIT repositories base url. |
| `install_drbd_ppa` | `ppa:linbit/linbit-drbd9-stack` | Ubuntu ppa used without LINBIT enabler code. |
| `install_drbd_elrepo_packages` | see `defaults/main.yml` | ELRepo DRBD 9 packages, by EL major version. |

The enabler code is confidential:

* keep it in an ansible-vault encrypted file, never in clear text in the inventory
* the role hides the tasks using it from the logs (`no_log`)
* the repository file written on the nodes holds it, and is readable by root only

On RHEL, the LINBIT kernel modules follow the kABI of each minor release, and
the repository url includes the minor release: run the role again after a
minor release upgrade.

Example Playbook
----------------

    - hosts: clusternodes
      vars_files:
        - linbit.vault.yml    # install_drbd_linbit_key: "..."
      roles:
        - role: opensvc.cluster_v3.install_drbd

with `linbit.vault.yml` created by `ansible-vault create linbit.vault.yml`.

License
-------

Apache-2.0

Author Information
------------------

OpenSVC Ansible Team <ansible@opensvc.com>
