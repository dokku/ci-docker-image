FROM alpine:3.12.1

RUN apk --no-cache add git==2.26.3-r0 openssh==8.3_p1-r2 && \
    mkdir -p ~/.ssh

COPY bin /bin
