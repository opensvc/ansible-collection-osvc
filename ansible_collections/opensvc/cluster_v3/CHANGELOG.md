## 1.1.0

Breaking changes, variables renamed (old names are silently ignored):

- install_pool: `osvc_pool_path` is now `install_pool_path`, `osvc_pool_vg` is now `install_pool_vg`
- install_backend_network: `install_backend_network_subnet_ips_per_node` is replaced by
  `install_backend_network_subnet_mask_per_node` (per-node subnet prefix length, default 24)

New features:

- New role install_hb_relay, to add a relay heartbeat to the cluster
- install_pool: add `vg` pool type and `install_pool_force` to overwrite an existing pool
- provision_cluster: set the `hb#1.timeout` keyword from `provision_cluster_hb_timeout`
- provision_cluster: install a given OpenSVC version with `provision_cluster_version`
  (server and client pinned), downgrades require `provision_cluster_allow_downgrade`,
  freeze the cluster before and thaw it only once all nodes have rejoined

Fixes:

- Set `requires_ansible` to `>=2.16.0`, as required by Red Hat certification
- RHEL 7 and RHEL 8 nodes need ansible-core <= 2.16 (python 3.6 targets), see README
- provision_cluster: pass the join token through `OSVC_JOIN_TOKEN`, `--token` now expects a file path
- provision_cluster: display the join token only with `-vv`
- provision_cluster: compute the package repository path per distribution and release
  (Debian repository path was missing the release codename)
- provision_cluster: use a deb822 signed repository on Ubuntu
- provision_cluster: install jq on Debian and Ubuntu, remove python3-netaddr
- provision_cluster, install_drbd: use the package module instead of dnf, for RHEL 7 support
- provision_cluster: disable repository gpgcheck on RHEL 7, as rpm 4.11 can not verify subkey signatures
- provision_cluster: ssh trust, hb timeout, cluster thaw and apt cache update no longer report a change on every run
- install_drbd: detect a loaded module from /sys/module, `lsmod | grep -q` under pipefail
  reported it as missing and reloaded it on every run
- install_pool, install_backend_network: detect existing objects from `om ... ls -o json`
- install_pool: use `om cluster config update --set`
- install_dns: prefix role variables with `install_dns_`

## 1.0.0

- Red Hat Ansible Automation Platform is ending support for Ansible Core 2.15 and Python 3.11.
- Fix linting and sanity errors
- Set minimum ansible version to 2.16.0
- Fix deprecated syntax
