# Setting up Primary/Replica with mariadb

Primary db is initialized with [primary.conf](./primary.conf)
and replica db is initialized with [replica01.conf](./replica01.conf).
Give the replica db a different server-id than the primary db.

You also need to create a user with replication privileges on the primary db.

## If not using env for primary and replica db

### Primary db

Now you need prevent any changes to the data while you view the binary log position. You'll use this to tell the slave at exactly which point it should start replicating from.

    On the master, flush and lock all tables by running FLUSH TABLES WITH READ LOCK. Keep this session running - exiting it will release the lock.
    Get the current position in the binary log by running SHOW MASTER STATUS:

```sql
SHOW MASTER STATUS;
+--------------------+----------+--------------+------------------+
| File               | Position | Binlog_Do_DB | Binlog_Ignore_DB |
+--------------------+----------+--------------+------------------+
| primary01-bin.00002 |      568 |              |                  |
+--------------------+----------+--------------+------------------+
```

    Record the File and Position details. If binary logging has just been enabled, these will be blank.
    Now, with the lock still in place, copy the data from the master to the slave. See Backup, Restore and Import for details on how to do this.
    Note for live databases: You just need to make a local copy of the data, you don't need to keep the master locked until the slave has imported the data.
    Once the data has been copied, you can release the lock on the master by running UNLOCK TABLES.

```sql
UNLOCK TABLES;
```

### Replica db

Setup the replica db with the data from the primary db.
    On the slave, configure the replica settings by running CHANGE MASTER TO. You need to specify the master host, user, password, and the binary log file and position you recorded earlier.

```sql
CHANGE MASTER TO
  MASTER_HOST='sql-primary',
  MASTER_USER='replication_user',
  MASTER_PASSWORD='bigs3cret',
  MASTER_PORT=3306,
  MASTER_LOG_FILE='primary01-bin.00002',
  MASTER_LOG_POS=568,
  MASTER_CONNECT_RETRY=10;
```

Start the replica

```sql
START SLAVE;
```

Check replica status:

```sql
SHOW SLAVE STATUS \G
```

### Testing

To test the replication, create a new database on the primary db:

```sql
CREATE DATABASE test;
```

Then check if the database is created on the replica db:

```sql
SHOW DATABASES;
```

You can also stop the replica db and see if the changes are replicated when you start it again.
