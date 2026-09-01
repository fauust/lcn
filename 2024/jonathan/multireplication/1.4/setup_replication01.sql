CHANGE MASTER TO MASTER_HOST='sql-primary02', MASTER_USER='replication_user', MASTER_PASSWORD='replicapass';
START SLAVE;
