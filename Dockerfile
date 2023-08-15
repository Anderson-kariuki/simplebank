# Build stage
FROM golang:1.20-alpine3.18 AS builder
WORKDIR /app
COPY . .
RUN go build -o main main.go

# Run stage
FROM alpine:3.18
WORKDIR /app
COPY --from=builder /app/main .
COPY --from=builder /app/migrate.linux-amd64 ./migrate
COPY app.env .
COPY start.sh .
COPY db/migration ./migration

EXPOSE 8080
CMD [ "/app/main" ]
ENTRYPOINT [ "/app/start.sh" ]

# run: docker build -t simplebank:latest .
# then create a network using: docker network create bank-network
# then connect to the network: docker connect bank-network postgres15
# docker run --name simplebank --network bank-network -p 8080:8080 -e GIN_MODE=release -e DB_SOURCE=postgresql://root:secret@postgres15:5432/simple_bank?sslmode=disable simplebank:latest

# instead of the above commands use docker compose
