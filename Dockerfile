FROM golang:1.9.2-alpine3.6
WORKDIR /go/src/github.com/wildsurfer/postgrest-oauth-server
COPY . .
RUN apk add --no-cache openssl git && \
    wget -O /usr/bin/dep https://github.com/golang/dep/releases/download/v0.3.2/dep-linux-amd64 && \
    chmod +x /usr/bin/dep /usr/bin/dep && \
    dep ensure -vendor-only && go build

FROM alpine:3.6
MAINTAINER Ivan Kuznetsov <kuzma.wm@gmail.com>
ENV OAUTH_DB_CONN_STRING="postgres://user:pass@postgresql:5432/test?sslmode=disable" \
    OAUTH_ACCESS_TOKEN_JWT_SECRET="morethan32symbolssecretkey!!!!!!" \
    OAUTH_ACCESS_TOKEN_TTL=7200 \
    OAUTH_REFRESH_TOKEN_JWT_SECRET="notlesshan32symbolssecretkey!!!!" \
    OAUTH_COOKIE_HASH_KEY="supersecret" \
    OAUTH_COOKIE_BLOCK_KEY="16charssecret!!!" \
    OAUTH_VALIDATE_REDIRECT_URI=true
    OAUTH_FB_CLIENT_ID="545872983742"
    OAUTH_FB_CLIENT_SECRET="hgjh2riftuer7r82iuhrf982938uryhfg3hre"
    OAUTH_FB_REDIRECT_URI_HOST="http://localhost:3684"
    OAUTH_FB_API_VERSION="v2.12"
RUN apk --no-cache add ca-certificates
WORKDIR /root/
COPY --from=0 /go/src/github.com/wildsurfer/postgrest-oauth-server/postgrest-oauth-server .
COPY --from=0 /go/src/github.com/wildsurfer/postgrest-oauth-server/templates/ ./templates
CMD ./postgrest-oauth-server
