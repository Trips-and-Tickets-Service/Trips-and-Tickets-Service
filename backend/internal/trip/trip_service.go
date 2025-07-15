package trip

import (
	"errors"
	"time"
)

type Service struct {
	repository *Repository
}

func NewTripService(repository *Repository) *Service {
	repository.db.Create(&Trip{
		From:           "Neptune",
		To:             "Saturn",
		DepartureTime:  time.Now().AddDate(0, 0, -1),
		ArrivalTime:    time.Now().AddDate(0, 4, 0),
		AvailableSeats: 12,
		MaxSeats:       25,
	})
	return &Service{repository: repository}
}

func (s *Service) GetAllTrips() ([]Trip, error) {
	trips, err := s.repository.GetTrips()
	if err != nil {
		return []Trip{}, err
	}
	return trips, nil
}

func (s *Service) GetTripsInRange(request TimeRangeRequest) ([]Trip, error) {
	startTime := time.Unix(int64(request.DepartureTime), 0)
	endTime := time.Unix(int64(request.ArrivalTime), 0)
	if endTime.Before(startTime) {
		return []Trip{}, errors.New("incorrect time range")
	}
	trips, err := s.repository.GetTripsByRouteAndTime(startTime, endTime, request.From, request.To)
	if err != nil {
		return []Trip{}, err
	}
	return trips, nil
}

func (s *Service) checkTripAvailability(tripId int) bool {
	trip, err := s.repository.GetTrip(tripId)
	if err != nil {
		return false
	}
	return trip.AvailableSeats > 0
}
