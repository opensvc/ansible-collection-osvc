# Ansible Collection - opensvc.cluster_v3

This collection deploys and manages **OpenSVC v3** clusters, the open source
high availability and orchestration agent.

It provides roles to:

- build an OpenSVC v3 cluster from a server inventory: agent and client
  installation, cluster name, nodes, heartbeats and orchestrator configuration
  (`provision_cluster`)
- add a relay heartbeat to the cluster (`install_hb_relay`)
- configure container management support: backend network and CNI plugins
  (`install_backend_network`, `install_cni`)
- set up the cluster name service and DRBD9 prerequisites
  (`install_dns`, `install_drbd`)
- declare storage pools (`install_pool`)
- remove the services and the cluster (`unprovision_services`, `unprovision_cluster`)

To deploy OpenSVC v2 clusters, use the `opensvc.cluster` collection instead.

## Usage

Install this collection locally:

    ansible-galaxy collection install opensvc.cluster_v3 -p ./collections

Then you can use the roles from the collection in your playbooks:

    ---
    - hosts: all
    
      collections:
        - opensvc.cluster_v3
    
      roles:
        - role: provision_cluster
          vars:
            provision_cluster_clustername: prod01
            provision_cluster_hb_timeout: 30s

## Ansible version compatibility

RHEL 7 and RHEL 8 nodes ship python 3.6, which ansible-core 2.17 and later
can no longer manage. Use ansible-core <= 2.16 (Ansible <= 9) to deploy on
these distributions.

On RHEL 7, the OpenSVC repository is declared with `gpgcheck` disabled,
because rpm 4.11 can not verify packages signed with a gpg subkey.

## Support

As Red Hat Ansible Certified Content, this collection is entitled to support
through Red Hat Ansible Automation Platform, using the **Create issue** button
on the collection page of Automation Hub.

If a support case can not be opened with Red Hat, or if the collection was
obtained from Ansible Galaxy or GitHub, report issues and ask questions on the
[GitHub issue tracker](https://github.com/opensvc/ansible-collection-osvc/issues).
Community help is also available on the [Ansible Forum](https://forum.ansible.com/).

For OpenSVC commercial support, contact [OpenSVC](https://www.opensvc.com/).

## Release Notes

See the [CHANGELOG](https://github.com/opensvc/ansible-collection-osvc/blob/master/ansible_collections/opensvc/cluster_v3/CHANGELOG.md)
for a history of notable changes to this collection.

## Author

OpenSVC Ansible Team <ansible@opensvc.com>
