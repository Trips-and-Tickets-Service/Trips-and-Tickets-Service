package ticket

import (
	"gorm.io/gorm"
	"nexspace/main/internal/models"
)

type Repository struct {
	db *gorm.DB
}

func NewTicketRepository(db *gorm.DB) *Repository {
	return &Repository{db: db}
}

func (r *Repository) CreateTicket(userId uint, tripId uint) error {
	err := r.db.Create(&models.Ticket{
		UserId: userId,
		TripId: tripId,
	}).Error
	return err
}

func (r *Repository) GetUserTickets(userID uint) ([]models.Ticket, error) {
	var user models.User
	if err := r.db.Preload("Tickets").First(&user, userID).Error; err != nil {
		return nil, err
	}
	return user.Tickets, nil
}
