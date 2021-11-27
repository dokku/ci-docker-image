FROM alpine:3.15.0

RUN apk --no-cache add git==2.34.0-r0 openssh==8.8_p1-r3 && \
    mkdir -p ~/.ssh

COPY bin /bin
