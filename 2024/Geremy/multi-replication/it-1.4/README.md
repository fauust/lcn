# 1- Créated USER ans set privileges

```
CREATE USER 'myuser'@'%' IDENTIFIED BY 'test123';
GRANT REPLICATION SLAVE ON *.* TO 'myuser'@'%';
FLUSH PRIVILEGES;
```

# 2- Synchronized DB

```
STOP SLAVE;
CHANGE MASTER TO
   MASTER_HOST="sql-primary02",
   MASTER_PORT=3306,
   MASTER_USER="myuser",
   MASTER_PASSWORD="test123",
   MASTER_USE_GTID=slave_pos;
START SLAVE;
```

puis faire : `CHANGE MASTER TO MASTER_USE_GTID = slave_pos`