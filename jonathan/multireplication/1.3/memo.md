# replication primary/replica

pour vérifier la replication de post, j'ai fait un `docker compose down`, modifié le docker-compose.yml en mettant sql-replica01 comme DB_HOST de wordpress, fait un `docker compose up -d` et verifié que le post s'affiche dans le front de  wordpress.

