# Mémo Multi-Stage Dockerfile

## Utilisation du cron pour lancer le script dump_script.sh

``` bash
crontab -e #ou sudo vim /etc/cron.d/mon_cron

*/2 * * * * /path/to/dump_script.sh >> /path/to/backup_cron.log 2>&1

```

