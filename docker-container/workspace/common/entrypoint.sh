#! /bin/bash

user_id="hadoop"
user_dir="/home/$user_id"
ssh_user_dir="$user_dir/.ssh"
ssh_config="/etc/ssh"
sshd_config="$ssh_config/sshd_config"
ssh_host_rsa_key="$ssh_config/ssh_host_rsa_key"
ssh_host_ecdsa_key="$ssh_config/ssh_host_ecdsa_key"
ssh_host_ed25519_key="$ssh_config/ssh_host_ed25519_key"

echo ssh_host_rsa_key=$ssh_host_rsa_key
echo ssh_host_ecdsa_key=$ssh_host_ecdsa_key
echo ssh_host_ed25519_key=$ssh_host_ed25519_key

id $user_id >& /dev/null  
if [ $? -ne 0 ]  
then  
    useradd $user_id -d "$user_dir"
    echo $user_id | passwd --stdin $user_id
    echo "$user_id    ALL=(ALL)       ALL" >> /etc/sudoers
fi

chown -R $user_id:$user_id "$user_dir"
chmod 755 "$ssh_user_dir"

if [ ! -f "$sshd_config" ]; then
    cp /etc/ssh-bak/sshd_config $sshd_config
fi

if [ ! -f "$ssh_host_rsa_key" ]; then
    ssh-keygen -q -t rsa -b 2048 -f "$ssh_host_rsa_key" -N ''
fi

if [ ! -f "$ssh_host_ecdsa_key" ]; then
    ssh-keygen -q -t ecdsa -f "$ssh_host_ecdsa_key" -N ''
fi

if [ ! -f "$ssh_host_ed25519_key" ]; then
    ssh-keygen -t dsa -f "$ssh_host_ed25519_key" -N ''
fi

chmod 777 /workspace

# /usr/sbin/init
/usr/sbin/sshd -D

