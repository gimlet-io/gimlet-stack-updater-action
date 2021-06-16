FROM alpine:3.13.4

RUN apk --no-cache add bash curl git jq openssl

WORKDIR /action

RUN curl -L https://github.com/gimlet-io/gimlet-stack/releases/download/tip/stack-$(uname)-$(uname -m) -o /usr/local/bin/stack && \
      chmod +x /usr/local/bin/stack

COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

RUN wget https://github.com/cli/cli/releases/download/v1.11.0/gh_1.11.0_linux_386.tar.gz -O ghcli.tar.gz
RUN tar --strip-components=1 -xf ghcli.tar.gz && mv ./bin/gh /bin/gh

ENTRYPOINT ["/entrypoint.sh"]
