package trip

import (
	"errors"
	"math"
	"math/rand"
	"nexspace/main/internal/models"
	"time"
)

type Service struct {
	repository *Repository
}

func NewTripService(repository *Repository) *Service {
	randomlyGenerateTrips(repository)
	return &Service{repository: repository}
}

func randomlyGenerateTrips(repository *Repository) {
	planets := []string{
		"mercury",
		"venus",
		"earth",
		"mars",
		"jupiter",
		"saturn",
		"uranus",
		"neptune",
		"moon",
		"pluto",
	}
	var index uint
	for i, planet := range planets {
		for k, anotherPlanet := range planets {
			times := rand.Intn(5)
			for x := 0; x < times; x++ {
				if planet == anotherPlanet {
					continue
				}
				index++
				maxSeats := rand.Intn(200) + 1
				availableSeats := rand.Intn(maxSeats)
				repository.db.Save(&models.Trip{
					ID:             index,
					FromPlanet:     planet,
					ToPlanet:       anotherPlanet,
					DepartureTime:  time.Now().AddDate(0, 0, 1+x),
					ArrivalTime:    time.Now().AddDate(0, 0, int(math.Abs(float64(k-i)))+3+x),
					AvailableSeats: uint(availableSeats),
					MaxSeats:       uint(maxSeats),
					Price:          5000,
				})
			}
		}
	}
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
