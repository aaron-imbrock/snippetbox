FROM golang:1.23-alpine AS builder

WORKDIR /app

COPY go.mod go.sum ./
COPY vendor/ ./vendor/

COPY . .

RUN CGO_ENABLED=0 GOOS=linux go build -o snippetbox ./cmd/web

FROM alpine:latest

WORKDIR /root/

COPY --from=builder /app/snippetbox .
COPY --from=builder /app/ui ./ui

EXPOSE 4000

CMD ["./snippetbox", "-dsn=postgres://web:pass@localhost:5432/snippetbox"]
