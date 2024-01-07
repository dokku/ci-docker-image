FROM alpine:3.19.0

RUN apk --no-cache add git==2.43.0-r0 openssh==9.6_p1-r0 && \
    mkdir -p ~/.ssh

COPY bin /bin
