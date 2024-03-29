# adapted from https://github.com/pteich/caddy-tlsconsul/blob/master/Dockerfile

FROM golang:1.12-alpine

ENV GO111MODULE=on
ENV GOPROXY=https://proxy.golang.org

RUN set -x \
    && apk update && apk add --no-cache --upgrade \
        openssl git ca-certificates

RUN cd / && mkdir caddybuild && cd caddybuild && echo $'package main\n\
import (\n\
"github.com/caddyserver/caddy/caddy/caddymain"\n\
_ "github.com/eventonehq/caddy-tls-s3"\n\
)\n\
func main() {\n\
caddymain.Run()\n\
}' > main.go && \
          go mod init caddy && go get github.com/caddyserver/caddy && go build

FROM alpine:latest
LABEL maintainer="opensource@event1.io"
LABEL description="Caddy with integrated TLS S3 Storage plugin"

ENV DUMBINIT_VERSION 1.2.2
ENV CADDYPATH /.caddy

RUN set -x \
    && apk update && apk add --no-cache \
        openssl \
        dpkg \
        ca-certificates \
    && update-ca-certificates \
    && cd /tmp \
    && dpkgArch="$(dpkg --print-architecture | awk -F- '{ print $NF }')" \
    && wget -O /usr/local/bin/dumb-init "https://github.com/Yelp/dumb-init/releases/download/v${DUMBINIT_VERSION}/dumb-init_${DUMBINIT_VERSION}_${dpkgArch}" \
    && chmod +x /usr/local/bin/dumb-init \
    && rm -rf /tmp/*

COPY --from=0 /caddybuild/caddy /bin/caddy
RUN chmod +x /bin/caddy

ENTRYPOINT ["/usr/local/bin/dumb-init","/bin/caddy"]

EXPOSE 80 443 2015
WORKDIR /var/www/html
CMD [""]
