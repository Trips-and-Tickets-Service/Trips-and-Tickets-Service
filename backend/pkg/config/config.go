package config

import (
	"fmt"
	"github.com/caarlos0/env/v6"
	"github.com/joho/godotenv"
	"log"
)

type (
	Config struct {
		HTTP HTTP
		DB   DB
		JWT  JWT
	}

	HTTP struct {
		Port string `env:"HTTP_PORT,required"`
	}

	DB struct {
		Host     string `env:"POSTGRES_HOST,required"`
		User     string `env:"POSTGRES_USER,required"`
		Password string `env:"POSTGRES_PASSWORD,required"`
		DbName   string `env:"POSTGRES_DB,required"`
	}

	JWT struct {
		SecretKey string `env:"SECRET_KEY,required"`
	}
)

func LoadConfig() (*Config, error) {
	err := godotenv.Load()
	if err != nil {
		log.Printf("unable to load .env file: %e", err)
	}

	cfg := &Config{}
	if err := env.Parse(cfg); err != nil {
		return nil, fmt.Errorf("config error: %w", err)
	}

	return cfg, nil
}
