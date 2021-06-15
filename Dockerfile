FROM alpine:3.13.4

RUN apk --no-cache add bash curl git openssl

WORKDIR /action

RUN curl -L https://github.com/gimlet-io/gimlet-stack/releases/download/v0.3.0/stack-$(uname)-$(uname -m) -o /usr/local/bin/stack && \
      chmod +x /usr/local/bin/stack

COPY entrypoint.sh /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
