# Ansible Collection - opensvc.cluster_v3

This collection contains OpenSVC-related ansible objects.

## Usage

Install this collection locally:

    ansible-galaxy collection install opensvc.clusteri_v3 -p ./collections

Then you can use the roles from the collection in your playbooks:

    ---
    - hosts: all
    
      collections:
        - opensvc.cluster_v3
    
      roles:
        - role: provision_cluster
          vars:
            osvc_clustername: prod01
            osvc_hb_timeout: 30s

## Author

OpenSVC Ansible Team <ansible@opensvc.com>
