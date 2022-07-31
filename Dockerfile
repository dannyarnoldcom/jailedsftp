FROM buildpack-deps:22.04-curl

USER root

WORKDIR /root/

RUN apt-get update && apt-get install -y --no-install-recommends \
        git \
        openssh-server \
    && rm -rf /var/lib/apt/lists/*

RUN cd /root && git clone -b release-stable https://github.com/pinnet/jailedsftp.git && chmod +x -R /root/jailedsftp/install_scripts/

ENV REPO_DIR=jailedsftp

EXPOSE 22

ENTRYPOINT [ "/bin/sh", "-c", "exec /root/jailedsftp/install_scripts/init " ]