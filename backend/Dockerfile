FROM golang:1.24.4

WORKDIR /app

COPY go.mod go.sum ./
RUN go mod download

COPY . ./

RUN go install github.com/swaggo/swag/cmd/swag@latest
# RUN swag init -g ./cmd/app/main.go -o cmd/docs

RUN CGO_ENABLED=0 GOOS=linux go build -o /backend ./cmd/app/main.go

EXPOSE 8080

CMD ["/backend"]