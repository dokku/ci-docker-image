FROM alpine:3.23.3

RUN apk --no-cache add git==2.52.0-r0 python3==3.12.12-r0 openssh==10.2_p1-r0 && \
    mkdir -p ~/.ssh

COPY bin /bin
