# Build stage
FROM golang:1.23 AS builder
WORKDIR /app
COPY go.mod .
RUN go mod download
COPY . .
RUN CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go build -o main .

# Debuggable Image (Instead of Distroless)
FROM alpine:latest
WORKDIR /
COPY --from=builder /app/main .
COPY --from=builder /app/static ./static
RUN chmod +x /main
RUN apk add --no-cache curl
EXPOSE 8080
CMD ["/main"]
