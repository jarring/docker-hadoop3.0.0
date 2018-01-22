#! /bin/bash

user_dir="/home/hadoop"
ssh_user_dir="$user_dir/.ssh"
ssh_config="/etc/ssh"
sshd_config="$ssh_config/sshd_config"
ssh_host_rsa_key="$ssh_config/ssh_host_rsa_key"
ssh_host_ecdsa_key="$ssh_config/ssh_host_ecdsa_key"
ssh_host_ed25519_key="$ssh_config/ssh_host_ed25519_key"

echo ssh_host_rsa_key=$ssh_host_rsa_key
echo ssh_host_ecdsa_key=$ssh_host_ecdsa_key
echo ssh_host_ed25519_key=$ssh_host_ed25519_key

id hadoop >& /dev/null  
if [ $? -ne 0 ]  
then  
    useradd hadoop -d "$user_dir"
    echo hadoop | passwd --stdin hadoop
    echo "hadoop    ALL=(ALL)       ALL" >> /etc/sudoers
fi

chown -R hadoop:hadoop "$user_dir"
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

