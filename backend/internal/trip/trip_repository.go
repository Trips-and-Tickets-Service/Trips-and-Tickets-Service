package trip

import (
	"errors"
	"gorm.io/gorm"
	"time"
)

type Repository struct {
	db *gorm.DB
}

func NewTripRepository(db *gorm.DB) *Repository {
	return &Repository{db: db}
}

func (r *Repository) GetTripsByRouteAndTime(startTime time.Time, endTime time.Time, departure string, arrival string) ([]Trip, error) {
	var trips []Trip
	result := r.db.Find(&trips, "departure_time > ? AND arrival_time < ? AND from_planet = ? AND to_planet = ?", startTime, endTime, departure, arrival)
	if result.Error != nil {
		return trips, result.Error
	}
	return trips, nil
}

func (r *Repository) GetTrips() ([]Trip, error) {
	var trips []Trip
	result := r.db.Find(&trips)
	if result.Error != nil {
		return trips, result.Error
	}
	return trips, nil
}

func (r *Repository) GetTrip(tripId int) (Trip, error) {
	var trip Trip
	err := r.db.First(&trip, tripId).Error
	if errors.Is(err, gorm.ErrRecordNotFound) {
		return Trip{}, nil
	}
	return trip, err
}
