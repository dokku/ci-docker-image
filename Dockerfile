FROM alpine:3.18.0

RUN apk --no-cache add git==2.40.1-r0 openssh==9.3_p1-r3 && \
    mkdir -p ~/.ssh

COPY bin /bin
