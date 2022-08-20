JAILED_USER=${SSH_USER:=tunnel}
JAILED_GROUP=${SSH_GROUP:=tunneljail}
SSH_SHELL=${SSH_SHELL:=/usr/bin/bash}


groupadd tunneljail
adduser  --disabled-password --shell ${SSH_SHELL} --ingroup $JAILED_GROUP --gecos "" $JAILED_USER

mkdir -p /var/jail/home/$JAILED_USER
chown -R $JAILED_USER:$JAILED_GROUP /var/jail/home/$JAILED_USER
chmod -R 700 /var/jail/home/$JAILED_USER
touch /var/jail/home/$JAILED_USER/.hushlogin

mkdir /home/$JAILED_USER/.ssh && chown $JAILED_USER:$JAILED_GROUP /home/$JAILED_USER/.ssh && chmod 700 /home/$JAILED_USER/.ssh
touch /home/$JAILED_USER/.ssh/authorized_keys
chown $JAILED_USER:$JAILED_GROUP /home/$JAILED_USER/.ssh/authorized_keys && chmod 600 /home/$JAILED_USER/.ssh/authorized_keys

echo 'Match Group ' $JAILED_GROUP      >> /etc/ssh/sshd_config
echo '    PasswordAuthentication no'  >> /etc/ssh/sshd_config
echo '    ChrootDirectory /var/jail/' >> /etc/ssh/sshd_config
echo '    AllowTcpForwarding yes'     >> /etc/ssh/sshd_config