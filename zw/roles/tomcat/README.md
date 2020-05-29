tomcat-ansible-role
===================

Ansible role to install and configure Apache Tomcat on CentOS/RHEL. 


Requirements
------------
* Tomcat supported versions by this role:
  * 7.0
  * 8.0
  * 8.5
  * 9.0 (9.0.1 or later)
* CentOS/RHEL 7
* SELinux disabled

Installation
------------
```
整个文件夹【tomcat】是个角色，放置在/etc/ansible/roles下
```

Example Playbook
----------------
```yaml
- hosts: servers
  vars:
    tomcat_version: 8.5.23
    tomcat_state: absent
    tomcat_dir_name: yunzhihulian

    tomcat_port_shutdown: 8005
    tomcat_port_connector: 8080
    tomcat_port_redirect: 8443
    
    tomcat_permissions_production: False
    
    add_tomcat_users: False
    
    tomcat_users:
      - username: "tomcat"
        password: "t3mpp@ssw0rd"
        roles: "tomcat,admin,manager,manager-gui"
      - username: "exampleuser"
        password: "us3rp@ssw0rd"
        roles: "tomcat"        
  roles:
    - role: tomcat
```

Role Variables
--------------
The main variable:
- `tomcat_version`: tomcat version to install

- `tomcat_state`: 
  * `present`: 安装tomcat，更改tomcat配置
  * `absent`: 卸载tomcat
  * `deplay`: 部署war包

Some variables that require review:
- `tomcat_install_java`: False   
By default OpenJDK Java will not be installed. Change it to "True" if you  want OpenJDK Java to be installed by this role.
- `tomcat_java_version`: 1.8   
OpenJDK Java version to be installed. Default is "1.8". Currently, latest OpenJDK Java version is "11".
- `tomcat_install_path`: /data/soft/service   
Location in which tomcat will be installed. Default is "/data/soft/service".
- JVM memory management:   
You can set the minimum and maximum memory heap size with the following JVM -Xms and -Xmx variables as a percentage of the total system memory. For example, for a 2GB RAM system, using the default values: Xms=307m (15% of 2048MB), Xmx=1126m (55% of 2048MB).
  * `tomcat_jvm_memory_percentage_xms`: 512
  * `tomcat_jvm_memory_percentage_xmx`: 512   
- `tomcat_allow_manager_access_only_from_localhost`: False   
If set to "True", tomcat manager app will be accessible only from localhost for security reasons. (This behavior is default for Tomcat 8.5 and 9.0)
如果设置为“True”，则出于安全原因，只能从localhost访问tomcat管理程序。（此行为是Tomcat 8.5和9.0的默认行为）
- `tomcat_allow_host_manager_access_only_from_localhost`: False   
If set to "True", tomcat host manager app will be accessible only from localhost for security reasons. (This behavior is default for Tomcat 8.5 and 9.0)
如果设置为“True”，则出于安全原因，只能从localhost访问tomcat主机管理器应用程序。（此行为是Tomcat 8.5和9.0的默认行为）
- `add_tomcat_users`:是否增加tomcat用户(tomcat-user.xml)，默认不增加
- `tomcat_users`: List of tomcat users to be created. See example for the expected format.Only valid when add_tomcat_users is True.
- `tomcat_debug_mode`: False   
Change it to "True" in order to configure tomcat to allow remote debugging. Default debug port is set to tcp/8000 (you can change it through the corresponding variable).

File permissions:
- `tomcat_webapps_auto_deployment`: False  
For better security, auto-deployment should be disabled and web applications should be deployed as exploded directories. If auto-deployment is disabled, set this to "False". This variable makes sense only for production installation (if tomcat_permissions_production is "True"). Default is "True".  
  * If set to "True", webapps subdirectory is owned by tomcat with group tomcat.
  * If set to "False", webapps subdirectory is owned by root with group tomcat.  

Tomcat ports:
- `tomcat_port_connector`: 8080
- `tomcat_port_shutdown`: 8005
- `tomcat_port_redirect`: 8443
- `tomcat_port_ajp`: 8009
- `tomcat_port_debug`: 8000

Some defaults (probably not requiring tampering):
- `tomcat_dir_name`: search_service
如果tomcat文件夹名称需要由apache-tomcat-8.5.37变为其他，则在此配置，如果不需要变更，则配置为NULL

- `tomcat_service_name`: tomcat
- `tomcat_java_home`: /usr/lib/jvm/jre

- `tomcat_package_source`: local
tomcat安装包获取方式，默认为local
  * 如果设置为local，则表示从ansible主控服务器获取，则tomcat安装包应放在files文件夹中.
  * 如果设置为URL，则表示从网络上下载安装包，此时应该同时配置tomcat_downloadURL.

- `tomcat_downloadURL`: https://<i></i>archive.apache.org/dist
- `tomcat_user`: tomcat
- `tomcat_group`: tomcat
- `tomcat_temp_download_path`: /tmp/ansible/tomcat/tempdir

- `clean_all_webapps`: True
是否清空webapps文件夹

Optional variables (by default undefined):
- You can set custom user uid and group gid for homogeneity across multiple servers. For example:
  * `tomcat_user_uid`: 500
  * `tomcat_group_gid`: 500

In case of uninstallation:
- `tomcat_state`: absent
  * To uninstall tomcat that was installed using this role, set this variable to "absent". Default value is "present".
- `tomcat_uninstall_create_backup`: True   
By default, in a better safe than sorry basis, a backup tar archive will be created at "tomcat_install_path" before deletion.
- `tomcat_uninstall_remove_java`: False   
Change it to "True" to uninstall Java after tomcat is uninstalled.
- By default, tomcat user and group will be removed. Change to "False" to preserve them after tomcat is uninstalled.
  * `tomcat_uninstall_remove_user`: True
  * `tomcat_uninstall_remove_group`: True