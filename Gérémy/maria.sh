#!/usr/bin/env bash

apt install -y mariadb-server

mariadb < mydump.sql

