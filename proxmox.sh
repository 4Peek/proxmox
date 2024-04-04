#!/bin/bash
cat ./ProxmoxInterfaces.txt >> /etc/network/interfaces;
systemctl restart networking;
apt install smbclient -y
read -p "Введите ip файлового хранилиша: " SAMBA
read -p "Введите имя вашего локального хранилища: " STORAGE
--
smbclient //$SAMBA/diskfiles -N -c "get ISP-disk001.vmdk ISP-disk001.vmdk"
echo "ISP disk downloaded"
qm create 100 --name "ISP" --cores 1 --memory 1024 --ostype l26 --scsihw virtio-scsi-single  --net0 virtio,bridge=vmbr0 --net1 virtio,bridge=vmbr1 --net2 virtio,bridge=vmbr2
qm importdisk 100 ISP-disk001.vmdk $STORAGE --format qcow2 
echo "ISP disk imported"
qm set 100 -ide0 $STORAGE:vm-100-disk-0 --boot order=ide0
echo "ISP is done!!!"
--
smbclient //$SAMBA/diskfiles -N -c "get RTR-HQ-disk001.vmdk RTR-HQ-disk001.vmdk"
echo "RTR-HQ disk downloaded"
qm create 101 --name "RTR-HQ" --cores 4 --memory 4096 --ostype l26 --scsihw virtio-scsi-single --net0 e1000,bridge=vmbr1 --net1 e1000,bridge=vmbr3 
qm importdisk 101 RTR-HQ-disk001.vmdk $STORAGE --format qcow2 
echo "RTR-HQ disk imported"
qm set 101 -ide0 $STORAGE:vm-101-disk-0 --boot order=ide0
echo "RTR-HQ is done!!!"
--
smbclient //$SAMBA/diskfiles -N -c "get RTR-BR-disk001.vmdk RTR-BR-disk001.vmdk"
echo "RTR-BR disk downloaded"
qm create 102 --name "RTR-BR" --cores 4 --memory 4096 --ostype l26 --scsihw virtio-scsi-single  --net0 e1000,bridge=vmbr2 --net1 e1000,bridge=vmbr4
qm importdisk 102 RTR-BR-disk001.vmdk $STORAGE --format qcow2 
echo "RTR-BR disk imported"
qm set 101 -ide0 $STORAGE:vm-101-disk-0 --boot order=ide0
echo "RTR-BR is done!!!"
