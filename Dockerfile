FROM alpine:3.15.2

RUN apk --no-cache add git==2.34.1-r0 openssh==8.8_p1-r1 && \
    mkdir -p ~/.ssh

COPY bin /bin
