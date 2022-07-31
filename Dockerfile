FROM buildpack-deps:22.04-curl

USER root

WORKDIR /root/

ENV REPO_DIR=jailedsftp

ENV REPO_URL=https://github.com/dannyarnoldcom/jailedsftp.git

COPY init .

RUN chmod +x init

EXPOSE 22

ENTRYPOINT [ "/bin/sh", "-c", "exec /root/init " ]