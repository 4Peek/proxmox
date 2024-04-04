#!/bin/bash
cat ./ProxmoxInterfaces.txt >> /etc/network/interfaces;
systemctl restart networking;
apt install smbclient -y
read -p "Введите ip файлового хранилиша: " SAMBA
read -p "Введите имя вашего локального хранилища: " STORAGE

smbclient //$SAMBA/diskfiles -N -c "get alt.vmdk alt.vmdk"
echo "Alt disk downloaded"
qm create 100 --name "Alt" --cores 3 --memory 4196 --ostype l26 --scsihw virtio-scsi-single  --net0 virtio,bridge=vmbr0 --net1 virtio,bridge=vmbr1 --net2 virtio,bridge=vmbr2
qm importdisk 100 alt.vmdk $STORAGE --format qcow2 
echo "Alt disk imported"
qm set 100 -ide0 $STORAGE:vm-100-disk-0 --boot order=ide0
echo "Alt is done!!!"

