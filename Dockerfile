FROM alpine:3.17.1

RUN apk --no-cache add git==2.38.3-r0 openssh==9.1_p1-r1 && \
    mkdir -p ~/.ssh

COPY bin /bin
