FROM alpine:3.21.0

RUN apk --no-cache add git==2.45.2-r0 python3==3.12.7-r0 openssh==9.7_p1-r4 && \
    mkdir -p ~/.ssh

COPY bin /bin
