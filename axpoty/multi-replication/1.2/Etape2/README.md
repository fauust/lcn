# Cron job to run the script every 2 minutes

```bash
*/2 * * * * /usr/bin/docker exec sql-svg /backup.sh >> /var/log/cron.log 2>&1
```
