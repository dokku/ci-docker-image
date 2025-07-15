FROM alpine:3.22.1

RUN apk --no-cache add git==2.49.0-r0 python3==3.12.10-r1 openssh==10.0_p1-r7 && \
    mkdir -p ~/.ssh

COPY bin /bin
