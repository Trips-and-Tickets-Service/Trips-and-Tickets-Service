FROM golang:1.24.4

WORKDIR /app

COPY go.mod go.sum ./
RUN go mod download

COPY . ./

RUN CGO_ENABLED=0 GOOS=linux go build -o /backend ./cmd/app/main.go

EXPOSE 8080

CMD ["/backend"]