# Primary/Primary

## How to use

Start the containers

```bash
docker compose up -d
```

## How to test

```bash
docker exec -it sql-primary01 bash
```

```bash
mariadb -u root -ppassword1234
```

```sql
USE mydb2;

CREATE TABLE t1 (i INT);
```

```bash
docker exec -it sql-primary02 bash
```

```bash
mariadb -u root -ppassword1234
```

```sql
USE mydb2;

SHOW TABLES;

-- Should show t1

CREATE TABLE t2 (i INT);
```

```bash
docker exec -it sql-primary01 bash
```

```bash
mariadb -u root -ppassword1234
```

```sql

USE mydb2;

SHOW TABLES;

-- Should show t2
```
