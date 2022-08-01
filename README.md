# A jailed ssh user for sftp  

### Usage

    docker run -p 8022:22 -v [path-to-ftpfiles]:/var/jail/home/{SSH_USER} dannyarnoldcom/jailedsftp:latest

### Environment overrides

 - SSH_USER=sshjail
 - SSH_PASS=sshjail
 - UID=1000
 - GUID=${UID}
 - AUTH_KEY=[authorized key]
 - SSH_SHELL=/usr/bin/nologin
 - BANNER=none
 - BRANCH=release-stable
 ### Repository

<https://github.com/dannyarnoldcom/jailedsftp.git>

License MIT
