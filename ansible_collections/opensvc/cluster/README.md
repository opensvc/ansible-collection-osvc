# Ansible Collection - opensvc.cluster

This collection deploys and manages **OpenSVC v2** clusters, the open source
high availability and orchestration agent.

It provides roles to:

- build an OpenSVC v2 cluster from a server inventory: agent installation,
  cluster name, nodes, heartbeats and orchestrator configuration (`provision_cluster`)
- configure container management support: backend network and CNI plugins
  (`install_backend_network`, `install_cni`)
- set up the cluster name service, the ingress gateway and DRBD9 prerequisites
  (`install_dns`, `install_envoy`, `install_drbd`)
- declare storage pools (`install_pool`)
- remove the services and the cluster (`unprovision_services`, `unprovision_cluster`)

To deploy OpenSVC v3 clusters, use the `opensvc.cluster_v3` collection instead.

## Usage

Install this collection locally:

    ansible-galaxy collection install opensvc.cluster -p ./collections

Then you can use the roles from the collection in your playbooks:

    ---
    - hosts: all
    
      collections:
        - opensvc.cluster
    
      roles:
        - role: provision_cluster
          vars:
            provision_cluster_osvc_clustername: prod01
            provision_cluster_osvc_hb_timeout: 30s

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

See the [CHANGELOG](https://github.com/opensvc/ansible-collection-osvc/blob/master/ansible_collections/opensvc/cluster/CHANGELOG.md)
for a history of notable changes to this collection.

## Author

OpenSVC Ansible Team <ansible@opensvc.com>
