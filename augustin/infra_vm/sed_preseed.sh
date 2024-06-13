#! /usr/bin/env bash
name=$1
password=$2
userName=$3

function sed_preseed {
  VMName_bp="<VMNAME>"
  password_bp="<PASSWORD>"
  userName_bp="<USERNAME>"
  cp /home/augustin/Desktop/infra_VM/scripts/blue_print_preseed.cfg /home/augustin/Desktop/infra_VM/scripts/"$userName"_preseed.cfg
  sed -i "s/$userName_bp/$userName/g" /home/augustin/Desktop/infra_VM/scripts/"$userName"_preseed.cfg
  sed -i "s/$password_bp/$password/g" /home/augustin/Desktop/infra_VM/scripts/"$userName"_preseed.cfg
  sed -i "s/$VMName_bp/$name/g" /home/augustin/Desktop/infra_VM/scripts/"$userName"_preseed.cfg
}
sed_preseed
