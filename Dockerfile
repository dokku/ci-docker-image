FROM alpine:3.14.1

RUN apk --no-cache add git==2.32.0-r0 openssh==8.6_p1-r2 && \
    mkdir -p ~/.ssh

COPY bin /bin
