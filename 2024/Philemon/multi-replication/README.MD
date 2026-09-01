# CRON

Dans le fichier `/etc/cron.d/mon-cron` :

```
# backup-db container sql-01
*/2 * * * * philemon /home/philemon/Workspace/InfraVM/Projet/lcn_faustin-myfork/Philemon/multi-replication/dump-et-sauvegarde/dump.sh
```