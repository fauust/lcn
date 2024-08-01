# Merge compose files
Voir doc Docker :

[https://docs.docker.com/compose/multiple-compose-files/merge/](https://docs.docker.com/compose/multiple-compose-files/merge/) 

### Exemple :

```text-x-dockerfile
docker compose -f compose.yml -f compose.admin.yml run backup_db
```

*   compose.yml : principal
*   compose.admin.yml : surcharge
    *   DEBUG=1