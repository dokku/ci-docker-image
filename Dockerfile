FROM alpine:3.22.2

RUN apk --no-cache add git==2.49.1-r0 python3==3.12.12-r0 openssh==10.0_p1-r9 && \
    mkdir -p ~/.ssh

COPY bin /bin
