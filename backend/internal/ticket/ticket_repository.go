package ticket

import "database/sql"

type Repository struct {
	db *sql.DB
}

func NewTicketRepository(db *sql.DB) *Repository {
	return &Repository{db: db}
}
