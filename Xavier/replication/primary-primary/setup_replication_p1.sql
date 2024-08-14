# STOP SLAVE;
# , MASTER_USE_GTID = slave_pos
CHANGE MASTER TO MASTER_HOST = "sql-primary02", MASTER_USER = "replication_user", MASTER_PASSWORD = "toto";
START SLAVE;