#!/bin/bash
cat ./ProxmoxInterfaces.txt >> /etc/network/interfaces;
systemctl restart networking;
read -p "Введите ip файлового хранилиша: " SAMBA
read -p "Введите имя вашего локального хранилища: " STORAGE
curl -u "domain\username:passwd" smb://$SAMBA/diskfiles/ISP-disk001.vmdk -o ISP-disk001.vmdk
qm create 100 --name "ISP" --cores 1 --memory 1024 --ostype l26 --scsihw virtio-scsi-single  --net0 virtio,bridge=vmbr0 --net1 virtio,bridge=vmbr1 --net2 virtio,bridge=vmbr2
qm importdisk 100 ISP-disk001.vmdk $STORAGE --format qcow2 
qm set 100 -ide0 $STORAGE:vm-100-disk-0 --boot order=ide0
echo "ISP is done!!!"
