#!/bin/bash

JAILED_USER=${SSH_USER:=sshjail}
SSH_SHELL=${SSH_SHELL:=/usr/bin/nologin}
UID=${UID:=1000}
GID=${GID:=${UID}}

if [ "$UID" -lt "500" ]; then
    UID=500
fi
if [ "$GID" -lt "500" ]; then
    GID=500
fi

groupadd --gid ${GID} jailed
adduser --uid ${UID} --disabled-password --shell ${SSH_SHELL} --ingroup jailed --gecos "" $JAILED_USER

mkdir -p /var/jail/home/$JAILED_USER
chown -R $JAILED_USER:jailed /var/jail/home/$JAILED_USER
chmod -R 700 /var/jail/home/$JAILED_USER
touch /var/jail/home/$JAILED_USER/.hushlogin

if [[ -z "${AUTH_KEY}" ]]; then
    if [[ -z "${SSH_PASS}" ]]; then
        SSH_PASS=sshjail
    else
        SSH_PASS=$SSH_PASS
    fi
else    
    mkdir /home/$JAILED_USER/.ssh && chown $JAILED_USER:jailed /home/$JAILED_USER/.ssh && chmod 700 /home/$JAILED_USER/.ssh
    echo "${AUTH_KEY}" > /home/$JAILED_USER/.ssh/authorized_keys
    chown $JAILED_USER:jailed /home/$JAILED_USER/.ssh/authorized_keys && chmod 700 /home/$JAILED_USER/.ssh/authorized_keys
fi

if [[ -z "${BANNER}" ]]; then
    BANNER=none
else
    cp /root/${REPO_DIR}/${BANNER} /etc/ssh/banner
    BANNER=/etc/ssh/banner
fi

echo "# Automatically generated by mkuser.sh" > /etc/ssh/sshd_config
echo "Include /etc/ssh/sshd_config.d/*.conf" >> /etc/ssh/sshd_config
echo "ChallengeResponseAuthentication no" >> /etc/ssh/sshd_config
echo "Subsystem sftp internal-sftp" >> /etc/ssh/sshd_config
echo "AcceptEnv LANG LC_*" >> /etc/ssh/sshd_config
echo "PrintMotd no" >> /etc/ssh/sshd_config
echo "Banner ${BANNER}" >> /etc/ssh/sshd_config
echo "UsePam yes" >> /etc/ssh/sshd_config
echo 'PermitRootLogin no' >> /etc/ssh/sshd_config
echo 'PermitEmptyPasswords no' >> /etc/ssh/sshd_config
echo 'PasswordAuthentication no' >> /etc/ssh/sshd_config
echo 'PubkeyAuthentication yes' >> /etc/ssh/sshd_config
echo 'AuthorizedKeysFile .ssh/authorized_keys' >> /etc/ssh/sshd_config
echo "LoginGraceTime 2m" >> /etc/ssh/sshd_config
echo "MaxAuthTries 3" >> /etc/ssh/sshd_config
echo "MaxSessions 2" >> /etc/ssh/sshd_config
echo "# Match section --\n" >> /etc/ssh/sshd_config
echo "Match User ${JAILED_USER}" >> /etc/ssh/sshd_config

if [[ -z "${SSH_PASS}" ]]; then
  echo '  PasswordAuthentication no' >> /etc/ssh/sshd_config
else
  echo -e "$SSH_PASS\n$SSH_PASS" | passwd $JAILED_USER
  echo '  PasswordAuthentication yes' >> /etc/ssh/sshd_config
fi

