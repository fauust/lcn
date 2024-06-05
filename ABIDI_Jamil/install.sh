#! /usr/bin/env bash
. ./print_bash.sh
###################DESCRIPTION######################
#
#le script dit être lancé en SUDO
#
########################################################
function install_VM {
name1=$1
    virt-install \
      --name="${name1}" \
      --vcpus=2 \
      --memory=2048 \
    	--location=/home/jamil/Téléchargements/debian-12.5.0-amd64-netinst.iso \
    	--initrd-inject=preseed.cfg \
    	--initrd-inject=postinst.sh\
    	--graphics spice \
    	--network default,model=virtio \
    	--disk size=20,path="/var/lib/libvirt/images/${name1}.img",bus=virtio,cache=none \
    	--check all=off \
    	--noautoconsole \
    	--wait
}

function clear_Vm {
name2=$1
      test_VM_running "${name2}"
#TODO: la suite est à finir mais faut tenir les délais
      virsh destroy "${name2}"
      virsh undefine "${name2}"
      rm -f "/var/lib/libvirt/images/${name}.img"
}

function test_VM_running {
name3=$1
if [ "$( virsh list|  grep -e "${name3}" | awk '{ print $2 }')" = "${name3}" ]
then
  echo_red "${name3} is already UP & RUNNING  \n on la stoppe"
  virsh shutdown "${name3}"
fi
}
#TODO: function parsing preseed blue print with sed taking SSH-KEY
#!/usr/bin/env bash
function sed_preseed {
  DEFAULTVALUE=jamil
  DEFAULTPASSWD=jamilou
  DEFAULT_IP=192.168.122.93

#  DEFAULT_SSH_KEY=

  NAME="${1:-$DEFAULTVALUE}"
  PASSWD="${2:-$DEFAULTPASSWD}"
  IP="${3:-$DEFAULT_IP}"

  cp ./preseed_blue_print.cfg ./preseed.cfg
  sed -i  "s/NAME_BP/$NAME/g"  ./preseed.cfg
  sed -i "s/PWD_BP/$PASSWD/g"  ./preseed.cfg
  sed -i "s/IP_BP/$IP/g"  ./preseed.cfg
#  sed -i 's/SSH_KEY/$SSH_KEY/g'  ./preseed_update_test.cfg
}


####################### MAIN  ##################


read -rp "quel est le nom de la VM:" name
read -rp "quel est son IP:" IP
read -rp "quel est le nom du user:" USERNAME
read -rp "quel est le mot de pass du user:" USERPWD


if [ -f "/var/lib/libvirt/images/${name}.img" ]
then
  clear_Vm "$name"
fi

 echo_yellow "on installe la vm"
 sed_preseed "${USERNAME}" "${USERPWD}" "${IP}" && install_VM "$name"
 echo_green "la vm est cree"


