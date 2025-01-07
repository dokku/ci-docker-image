FROM alpine:3.21.1

RUN apk --no-cache add git==2.47.1-r0 python3==3.12.7-r1 openssh==9.9_p1-r2 && \
    mkdir -p ~/.ssh

COPY bin /bin
