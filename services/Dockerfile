# syntax = docker/dockerfile:1-experimental

FROM --platform=${BUILDPLATFORM} golang:1.15.2-alpine AS base
ARG PROJECT
WORKDIR /src
ENV CGO_ENABLED=0
COPY go.* .

FROM base AS mod-init
ARG NAME
RUN go mod init ${NAME}

FROM base AS tidy
RUN --mount=type=cache,target=/go/pkg/mod \
    go mod tidy

FROM scratch AS get-mod
COPY --from=mod-init /src/go.* /

FROM base AS dependencies
RUN --mount=type=cache,target=/go/pkg/mod \
    go mod download

FROM dependencies AS build
ARG TARGETOS
ARG TARGETARCH
RUN --mount=target=. \
    --mount=type=cache,target=/go/pkg/mod \
    --mount=type=cache,target=/root/.cache/go-build \
    GOOS=${TARGETOS} GOARCH=${TARGETARCH} go build -o /out/${PROJECT} ./${PROJECT}/main.go

FROM dependencies AS unit-test
RUN --mount=target=. \
    --mount=type=cache,target=/go/pkg/mod \
    --mount=type=cache,target=/root/.cache/go-build \
    mkdir /out && go test -v -coverprofile=/out/cover.out ./...

FROM golangci/golangci-lint:v1.31.0-alpine AS lint-base

FROM dependencies AS lint
RUN --mount=target=. \
    --mount=from=lint-base,src=/usr/bin/golangci-lint,target=/usr/bin/golangci-lint \
    --mount=type=cache,target=/go/pkg/mod \
    --mount=type=cache,target=/root/.cache/go-build \
    --mount=type=cache,target=/root/.cache/golangci-lint \
    golangci-lint run --timeout 10m0s ./...

FROM scratch AS unit-test-coverage
COPY --from=unit-test /out/cover.out /cover.out

FROM scratch AS bin-unix
COPY --from=build /out/${PROJECT} /

FROM bin-unix AS bin-linux
FROM bin-unix AS bin-darwin

FROM scratch AS bin-windows
COPY --from=build /out/${PROJECT} /${PROJECT}.exe

FROM bin-${TARGETOS} as bin
