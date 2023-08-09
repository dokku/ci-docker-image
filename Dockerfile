FROM alpine:3.18.3

RUN apk --no-cache add git==2.40.1-r0 openssh==9.3_p2-r0 && \
    mkdir -p ~/.ssh

COPY bin /bin
