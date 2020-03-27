# Ansible Collection - opensvc.cluster

This collection contains OpenSVC-related ansible objects.

## Usage

Install this collection locally:

    ansible-galaxy collection install opensvc.cluster -p ./collections

Then you can use the roles from the collection in your playbooks:

    ---
    - hosts: all
    
      collections:
        - opensvc.cluster
    
      roles:
        - kubernetes
        - role: k8s_manifests
          vars:
            k8s_manifests_base_dir: ''
            k8s_manifests:
              - monitoring/prometheus
              - dir: docker-registry
                namespace: registry

## Author

OpenSVC Ansible Team <ansible@opensvc.com>
