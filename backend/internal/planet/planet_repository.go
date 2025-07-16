package planet

import "database/sql"

type Repository struct {
	db *sql.DB
}

func NewPlanetRepository(db *sql.DB) *Repository {
	return &Repository{db: db}
}
