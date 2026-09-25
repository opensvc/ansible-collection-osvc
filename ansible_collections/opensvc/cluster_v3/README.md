# Ansible Collection - opensvc.cluster_v3

This collection contains OpenSVC-related ansible objects.

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

## Author

OpenSVC Ansible Team <ansible@opensvc.com>
