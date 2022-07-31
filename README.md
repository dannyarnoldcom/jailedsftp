# A jailed ssh user for sftp  

### Usage
docker run -p 8022:22 -v [path-to-ftpfiles]:/var/jail/home/${SSHUSER} dannyarnoldcom/jailedsftp:latest

### Environment overrides

SSH_USER=sshjail
SSH_PASS=sshjail
AUTH_KEY=[authorized key (overrides password)]
SSH_SHELL=/usr/bin/nologin

### Repository

<https://github.com/pinnet/jailedsftp.git>

License MIT
