# OpenSVC v3 Cluster Collection

## Description

This collection deploys and manages **OpenSVC v3** clusters, the open source
high availability and orchestration agent. It is meant for the system and
platform teams running highly available services, virtual machines or
containers on Linux nodes, who want to build and operate their OpenSVC
clusters as code.

It provides roles to:

- build an OpenSVC v3 cluster from a server inventory: agent and client
  installation, cluster name, nodes, heartbeats and orchestrator configuration
  (`provision_cluster`)
- add heartbeats to the cluster: unicast, multicast, disk and relay
  (`install_hb_unicast`, `install_hb_multicast`, `install_hb_disk`,
  `install_hb_relay`)
- configure the split quorum, its arbitrators and split action
  (`install_quorum`)
- configure container management support: backend network and CNI plugins
  (`install_backend_network`, `install_cni`)
- set up the cluster name service and DRBD9 prerequisites
  (`install_dns`, `install_drbd`)
- declare storage pools (`install_pool`)
- remove the services and the cluster (`unprovision_services`, `unprovision_cluster`)

Each role is documented by the README of its directory, in the
[roles directory](https://github.com/opensvc/ansible-collection-osvc/tree/master/ansible_collections/opensvc/cluster_v3/roles).

To deploy OpenSVC v2 clusters, use the `opensvc.cluster` collection instead.

## Requirements

The collection uses `ansible.builtin` modules only: it has no collection
dependency and no python package requirement on the control node.

The managed nodes need:

- a supported Linux distribution, listed in the Testing section
- python 3.6 or later. The python version of the nodes limits the usable
  ansible-core versions, see the Testing section
- root privileges for the play (`become: true`)
- an access to the packages repositories: the OpenSVC repository
  (`https://packages.opensvc.com`), the distribution repositories, and, for
  the roles that need them, the DRBD repositories (ELRepo, LINBIT or the
  LINBIT PPA), the CNI plugins releases on GitHub and the OpenSVC templates
  on GitHub. The README of each role lists its own requirements.

## Installation

Red Hat customers install this certified collection from
[Red Hat Ansible Automation Hub](https://console.redhat.com/ansible/automation-hub/repo/published/opensvc/cluster_v3/).
Red Hat does not support installing collections from GitHub.

To install from Automation Hub with the `ansible-galaxy` command-line tool,
declare the Automation Hub server, with an offline token got from the
[Connect to Hub](https://console.redhat.com/ansible/automation-hub/token)
page, in the `ansible.cfg` file:

```ini
[galaxy]
server_list = automation_hub, galaxy

[galaxy_server.automation_hub]
url = https://console.redhat.com/api/automation-hub/content/published/
auth_url = https://sso.redhat.com/auth/realms/redhat-external/protocol/openid-connect/token
token = <offline token>

[galaxy_server.galaxy]
url = https://galaxy.ansible.com/
```

The token can also be set by the
`ANSIBLE_GALAXY_SERVER_AUTOMATION_HUB_TOKEN` environment variable, instead of
being written in the file. A private automation hub serves the collection the
same way, with its own `url` and token.

See [configuring the ansible-galaxy client](https://docs.ansible.com/ansible/latest/collections_guide/collections_installing.html#configuring-the-ansible-galaxy-client)
for more details.

### Installing the collection

Install this collection with the Ansible Galaxy command-line tool:

```bash
ansible-galaxy collection install opensvc.cluster_v3
```

### Installing from a requirements file

You can include this collection in a `requirements.yml` file and install it
with `ansible-galaxy collection install -r requirements.yml`:

```yaml
collections:
  - name: opensvc.cluster_v3
```

An execution environment built with `ansible-builder` installs the
collections listed in the same way.

### Installing a specific version

Use the following syntax to install version 1.5.0:

```bash
ansible-galaxy collection install opensvc.cluster_v3:==1.5.0
```

See [using Ansible collections](https://docs.ansible.com/ansible/devel/user_guide/collections_using.html)
for more details.

### Upgrading the collection

To upgrade the collection to the latest available version, run the following
command:

```bash
ansible-galaxy collection install opensvc.cluster_v3 --upgrade
```

## Use cases

### Build a cluster

Install the OpenSVC v3 agent on every node of the inventory group, and join
them into the `prod01` cluster:

```yaml
- hosts: prod01
  become: true
  roles:
    - role: opensvc.cluster_v3.provision_cluster
      vars:
        provision_cluster_clustername: prod01
        provision_cluster_hb_timeout: 30s
```

### Survive a network or site loss

Add a unicast heartbeat on a second network, with the
`install_hb_unicast_addr` host variable set to the address of each node on
that network, and an arbitrator hosted on a third site, so that the nodes of
a split two-site cluster do not both stop:

```yaml
- hosts: prod01
  become: true
  roles:
    - role: opensvc.cluster_v3.install_hb_unicast
      vars:
        install_hb_unicast_rid: "2"
        install_hb_unicast_port: "10001"
    - role: opensvc.cluster_v3.install_quorum
      vars:
        install_quorum_arbitrators:
          - name: site3
            uri: https://arbitrator.acme.com/
```

### Run containers

Configure the backend network of the containers, spanning the nodes, and the
CNI plugins:

```yaml
- hosts: prod01
  become: true
  roles:
    - role: opensvc.cluster_v3.install_cni
    - role: opensvc.cluster_v3.install_backend_network
      vars:
        install_backend_network_subnet_range: 10.100.0.0/16
```

### Replicate the service data with DRBD

Install the DRBD9 kernel module and tools, then declare a DRBD storage pool
backed by a volume group, for the services to provision replicated volumes:

```yaml
- hosts: prod01
  become: true
  roles:
    - role: opensvc.cluster_v3.install_drbd
    - role: opensvc.cluster_v3.install_pool
      vars:
        install_pool_name: drbdpool
        install_pool_type: drbd
        install_pool_vg: data
```

### Decommission a cluster

Purge the services, then remove the agent and its configuration:

```yaml
- hosts: prod01
  become: true
  roles:
    - role: opensvc.cluster_v3.unprovision_services
      vars:
        unprovision_services_confirm: true
    - role: opensvc.cluster_v3.unprovision_cluster
      vars:
        unprovision_cluster_purge: true
```

## Testing

This collection requires ansible-core >= 2.16. It has been tested with
ansible-core 2.16, 2.19, 2.20, 2.21 and 2.22 (beta), on Ubuntu 20.04, 22.04,
24.04, 26.04, Debian 12, 13, RHEL 7, 8, 9, 10 and SLES 15 SP7, 16.0 nodes.
Each release runs `ansible-lint`, `ansible-test sanity`, and every role twice
on two-node lab clusters of each distribution, the second run reporting no
change.

The python version of the managed nodes limits the usable ansible-core versions:

| Nodes                       | Python | ansible-core |
|-----------------------------|--------|--------------|
| RHEL 7, RHEL 8, SLES 15     | 3.6    | <= 2.16      |
| Ubuntu 20.04                | 3.8    | <= 2.19      |
| RHEL 9, RHEL 10, SLES 16, Ubuntu 22.04 and later, Debian 12, 13 | >= 3.9 | >= 2.16 |

On RHEL 8 and SLES 15, installing a newer python (`python3.11` on RHEL 8,
`python311` on SLES 15) lifts this limit.

Known limitations:

- On SLES, ansible.builtin has no zypper module: the roles declare the
  repositories as `/etc/zypp/repos.d` files and install the packages with the
  `zypper` command.
- On RHEL 7, the OpenSVC repository is declared with `gpgcheck` disabled,
  because rpm 4.11 can not verify packages signed with a gpg subkey.

Example playbooks are available in the
[examples directory](https://github.com/opensvc/ansible-collection-osvc/tree/master/examples)
of the repository.

## Support

As Red Hat Ansible Certified Content, this collection is entitled to support
through Red Hat Ansible Automation Platform (AAP), using the **Create issue**
button on the top right corner of the collection page of Automation Hub.

If a support case can not be opened with Red Hat, or if the collection was
obtained from Ansible Galaxy or GitHub, report issues and ask questions on the
[GitHub issue tracker](https://github.com/opensvc/ansible-collection-osvc/issues).
Community help is also available on the [Ansible Forum](https://forum.ansible.com/).

For OpenSVC commercial support, contact [OpenSVC](https://www.opensvc.com/).

## Release notes and roadmap

See the [CHANGELOG](https://github.com/opensvc/ansible-collection-osvc/blob/master/ansible_collections/opensvc/cluster_v3/CHANGELOG.md)
for a history of notable changes to this collection.

See the [Red Hat Ansible Automation Platform Life Cycle](https://access.redhat.com/support/policy/updates/ansible-automation-platform)
page for the support timeline of the platform.

## Related information

- [OpenSVC documentation](https://book.opensvc.com/)
- [OpenSVC agent source code](https://github.com/opensvc/om3)
- [Using Ansible collections](https://docs.ansible.com/ansible/devel/user_guide/collections_using.html)

## License information

This collection is licensed under the Apache License, Version 2.0.

See the [LICENSE](https://github.com/opensvc/ansible-collection-osvc/blob/master/ansible_collections/opensvc/cluster_v3/LICENSE)
file for the full text, also included in the collection tarball, or
[apache.org](https://www.apache.org/licenses/LICENSE-2.0).

## Author

OpenSVC Ansible Team <ansible@opensvc.com>
