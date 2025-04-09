# Ansible Collection - opensvc.app

This collection contains roles for application deployment under OpenSVC clusters.

## Usage

Install this collection locally:

    ansible-galaxy collection install opensvc.cluster -p ./collections
    ansible-galaxy collection install opensvc.app -p ./collections

Then you can use the roles from the collection in your playbooks:

---
- hosts: all
  gather_facts: true
  become: true

  tasks:
    - name: import role provision_cluster
      import_role:
        name: opensvc.cluster.provision_cluster
      vars:
        osvc_clustername: collector

    - name: import role install_collector
      import_role:
        name: opensvc.app.install_collector
      vars:
        install_collector_network_host: true


## Author

OpenSVC Ansible Team <ansible@opensvc.com>
