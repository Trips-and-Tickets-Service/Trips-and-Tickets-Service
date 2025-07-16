package ticket

import (
	"errors"
	"nexspace/main/internal/models"
	"nexspace/main/internal/trip"
)

type Service struct {
	repository  *Repository
	tripService *trip.Service
}

func NewTicketService(repository *Repository, service *trip.Service) *Service {
	return &Service{repository: repository, tripService: service}
}

func (s *Service) CreateTicket(userId uint, tripId uint) error {
	if !s.tripService.CheckTripAvailability(tripId) {
		return errors.New("trip is unavailable")
	}
	err := s.tripService.BookSeat(tripId)
	if err != nil {
		return err
	}
	err = s.repository.CreateTicket(userId, tripId)
	if err != nil {
		return err
	}
	return nil
}

func (s *Service) GetUserTickets(user *models.User) ([]models.Ticket, error) {
	tickets, err := s.repository.GetUserTickets(user.ID)
	if err != nil {
		return nil, err
	}
	return tickets, nil
}

func (s *Service) GetUserTrips(user *models.User) ([]models.TicketWithTripInfo, error) {
	tickets, err := s.repository.GetUserTickets(user.ID)
	if err != nil {
		return nil, err
	}
	var ticketsWithTripInfo []models.TicketWithTripInfo
	for _, ticket := range tickets {
		t, err := s.tripService.GetTripByID(ticket.TripId)
		if err != nil {
			return nil, err
		}
		ticketsWithTripInfo = append(ticketsWithTripInfo, models.TicketWithTripInfo{Ticket: &ticket, Trip: &t})
	}
	return ticketsWithTripInfo, err
}
