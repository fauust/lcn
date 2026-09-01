/* execute on any of the nodes */
create user 'max_user'@'%' identified by 'max_pwd';
grant select on mysql.user to 'max_user'@'%';
grant select on mysql.db to 'max_user'@'%';
grant select on mysql.tables_priv to 'max_user'@'%';
grant select on mysql.columns_priv to 'max_user'@'%';
grant select on mysql.proxies_priv to 'max_user'@'%';
grant select on mysql.roles_mapping to 'max_user'@'%';
grant select on mysql.procs_priv to 'max_user'@'%';
grant show databases on *.* to 'max_user'@'%';
