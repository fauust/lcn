# Commande à effectuer dans la Primary

```
ALTER USER 'myuser'@'%' IDENTIFIED VIA mysql_native_password USING PASSWORD('test123');
GRANT REPLICATION SLAVE ON *.* TO 'myuser'@'%';
FLUSH PRIVILEGES;
SHOW MASTER STATUS;
```


# Commande à effectuer dans la ou les replica 
```
CHANGE MASTER TO
  MASTER_HOST='mariadb-primary',
  MASTER_USER='myuser',
  MASTER_PASSWORD='test123',
  MASTER_LOG_FILE='mysql-bin.000002',
  MASTER_LOG_POS=821;
```
