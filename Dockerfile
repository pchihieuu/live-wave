FROM golang:1.22.3 AS builder

WORKDIR /app

COPY go.mod go.sum ./
RUN go mod download

COPY . .


RUN go build -o live-wave.exe .


FROM debian:bullseye-slim

RUN apt-get update && apt-get install -y \
    ca-certificates \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /root/


COPY --from=builder /app/live-wave.exe .

COPY web/static /root/static
COPY web/views /root/views

CMD ["./live-wave.exe"]
