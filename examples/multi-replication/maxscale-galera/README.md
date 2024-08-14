# Setup MaxScale + Galera in docker-compose

## Galera

Bitnami images use 1001 UID so datadir needs to be owned by UID 1001.

```console
$ sudo chown -R 1001:1001 node_data*
```

## TODO

The node2 and node3 sometimes needs a restart of the stack in order to work, not
sure why. This needs some more work.

## MaxScale

### MaxScale GUI access

Access should be available at http://127.0.0.1:898 (default credentials,
admin/any-pwd).

If a user needs to be created in the maxscale container:

```console
$ docker exec -u root -it maxscale bash
# maxctrl create user "administrator" "PASSWORD" --type=admin
```

Then login with the previous credentials should work.
