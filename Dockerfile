FROM alpine:3.16.2

RUN apk --no-cache add git openssh==9.0_p1-r2 && \
    mkdir -p ~/.ssh

COPY bin /bin
