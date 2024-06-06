#!/usr/bin/env bash
userName=$1

echo "$userName ALL=(ALL) NOPASSWD: ALL" >>/etc/sudoers
