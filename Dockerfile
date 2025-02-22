FROM alpine:3.21.3

RUN apk --no-cache add git==2.47.2-r0 python3==3.12.9-r0 openssh==9.9_p1-r2 && \
    mkdir -p ~/.ssh

COPY bin /bin
