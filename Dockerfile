FROM alpine:3.17.1

RUN apk --no-cache add git==2.38.3-r1 openssh==9.1_p1-r2 && \
    mkdir -p ~/.ssh

COPY bin /bin
