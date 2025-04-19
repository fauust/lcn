-- Création d'un utilisateur dédié à la réplication avec droits limités
CREATE USER IF NOT EXISTS 'replication_user'@'%' IDENTIFIED BY 'replicapass';
GRANT REPLICATION SLAVE ON *.* TO 'replication_user'@'%';

-- Configuration du slave pour pointer vers le master
CHANGE MASTER TO 
  MASTER_HOST='sql-primary02', 
  MASTER_USER='replication_user', 
  MASTER_PASSWORD='replicapass',
  MASTER_PORT=3306,
  MASTER_CONNECT_RETRY=10;

-- Démarrage du slave
START SLAVE;

-- Création d'un utilisateur de monitoring avec droits restreints
CREATE USER 'monitoring_user'@'%' IDENTIFIED BY 'monitorpass';
GRANT PROCESS, REPLICATION CLIENT ON *.* TO 'monitoring_user'@'%';
