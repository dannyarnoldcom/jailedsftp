FROM buildpack-deps:22.04-curl

USER root

WORKDIR /root/

RUN apt-get update && apt-get upgrade -y && \ 
    apt-get install -y --no-install-recommends git openssh-server && \
    rm -rf /var/lib/apt/lists/*

ENV REPO_DIR=jailedsftp

ENV REPO_URL=https://github.com/dannyarnoldcom/jailedsftp.git

COPY init .

RUN chmod +x init

EXPOSE 22

ENTRYPOINT [ "/bin/sh", "-c", "exec /root/init " ]