FROM alpine:3.16.0

RUN apk --no-cache add git==2.36.1-r0 openssh==9.0_p1-r1 && \
    mkdir -p ~/.ssh

COPY bin /bin
