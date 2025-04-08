install_collector
=================

This role deploys an OpenSVC collector service (https://docs.opensvc.com/latest/collector.introduction.html)

Requirements
------------

OpenSVC cluster up & running
CNI installed
docker or podman installed

Role Variables
--------------

`install_collector_namespace`

The cluster namespece where the collector service will be deployed.

Default value is `prod`, so that the service path is `prod/svc/collector`

`install_collector_db_password`

The mariadb password for user opensvc.

`install_collector_web2py_admin_console_password`

The web2py admin password. ( https://f.q.d.n/admin )

Default value is `opensvc`

The password can be changed manually using the procedure below:
- open a shell on the opensvc node running the collector service
- enter the container#uwsgi container with `om prod/svc/collector enter --rid container#uwsgi`
- go to the /opt/web2py folder with `cd /opt/web2py`
- run the command `python -c "from gluon.main import save_password;save_password(raw_input('admin password: '),443)"`
- fill in the new password when prompted

`install_collector_repo`

The git repository from which the collector source code is pulled.

Default value is `https://github.com/opensvc/collector`

Custom private deployments with authentication can set this to `https://username:<personal access token>@host.my.corp/opensvc/collector`

`install_collector_nginx_conf_file`

Nginx configuration file uri

Default value is `https://raw.githubusercontent.com/opensvc/opensvc_templates/main/collector/nginx.conf`

`install_collector_dbdump_script`

Database backup script uri

Default value is `https://raw.githubusercontent.com/opensvc/opensvc_templates/main/collector/scripts/dbdump.sh`

`install_collector_dbrestore_script`

Database backup restore uri

Default value is `https://raw.githubusercontent.com/opensvc/opensvc_templates/main/collector/scripts/dbrestore.sh`

`install_collector_dbtables_list`

Database table file. Contains table list to backup with dbdump.sh

Default value is `https://raw.githubusercontent.com/opensvc/opensvc_templates/main/collector/scripts/dbdump.tables`

`install_collector_service_config`

Collector service template file

Default value is `https://raw.githubusercontent.com/opensvc/opensvc_templates/main/collector/collector.conf`

`install_collector_network_host`

Boolean to enable collector operating in the host network namespace.

Default value is `false`. Rely on CNI to provide a private ip addr to the service.
When enabled with `true`, the service will share the server network configuration.

Dependencies
------------

Depending on your context, you may need to call opensvc.cluster.provision_cluster and opensvc.cluster.install_cni before this role.

Example Playbook
----------------

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

License
-------

GPL-2.0-or-later

Author Information
------------------

OpenSVC Ansible Team <ansible@opensvc.com>
