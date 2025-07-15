package trip

import (
	"errors"
	"nexspace/main/internal/models"
	"time"
)

type Service struct {
	repository *Repository
}

func NewTripService(repository *Repository) *Service {
	repository.db.Create(&models.Trip{
		FromPlanet:     "neptune",
		ToPlanet:       "saturn",
		DepartureTime:  time.Now().AddDate(0, 0, 1),
		ArrivalTime:    time.Now().AddDate(0, 0, 3),
		AvailableSeats: 12,
		MaxSeats:       25,
		Price:          5000,
	})
	return &Service{repository: repository}
}

func (s *Service) GetAllTrips() ([]models.Trip, error) {
	trips, err := s.repository.GetTrips()
	if err != nil {
		return []models.Trip{}, err
	}
	return trips, nil
}

func (s *Service) GetTripsInRange(request TimeRangeRequest) ([]models.Trip, error) {
	startTime := time.Unix(int64(request.DepartureTime), 0)
	endTime := time.Unix(int64(request.ArrivalTime), 0)
	if endTime.Before(startTime) {
		return []models.Trip{}, errors.New("incorrect time range")
	}
	trips, err := s.repository.GetTripsByRouteAndTime(startTime, endTime, request.From, request.To)
	if err != nil {
		return []models.Trip{}, err
	}
	return trips, nil
}

func (s *Service) CheckTripAvailability(tripId uint) bool {
	trip, err := s.repository.GetTrip(tripId)
	if err != nil {
		return false
	}
	return trip.AvailableSeats > 0 && !trip.DepartureTime.Before(time.Now())
}

func (s *Service) BookSeat(tripId uint) error {
	trip, err := s.repository.GetTrip(tripId)
	if err != nil {
		return err
	}
	trip.AvailableSeats--
	trip.Price = trip.Price + trip.Price/10
	return nil
}

func (s *Service) GetTripByID(tripId uint) (models.Trip, error) {
	trip, err := s.repository.GetTrip(tripId)
	if err != nil {
		return models.Trip{}, err
	}
	return trip, err
}
