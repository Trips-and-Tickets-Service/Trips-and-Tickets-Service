package trip

import (
	"encoding/json"
	"errors"
	"gorm.io/gorm"
	"nexspace/main/internal/models"
	"time"
)

type Repository struct {
	db *gorm.DB
}

func NewTripRepository(db *gorm.DB) *Repository {
	return &Repository{db: db}
}

func (r *Repository) GetTripsByRouteAndTime(startTime time.Time, endTime time.Time, departure string, arrival string) ([]models.Trip, error) {
	var trips []models.Trip
	result := r.db.Find(&trips, "departure_time > ? AND arrival_time < ? AND from_planet = ? AND to_planet = ?", startTime, endTime, departure, arrival)
	if result.Error != nil {
		return trips, result.Error
	}
	return trips, nil
}

func (r *Repository) GetTrips() ([]models.Trip, error) {
	var trips []models.Trip
	result := r.db.Find(&trips)
	if result.Error != nil {
		return trips, result.Error
	}
	return trips, nil
}

func (r *Repository) GetTrip(tripId uint) (models.Trip, error) {
	var trip models.Trip
	err := r.db.First(&trip, tripId).Error
	if errors.Is(err, gorm.ErrRecordNotFound) {
		return models.Trip{}, nil
	}
	return trip, err
}

func (r *Repository) UpdateTrip(trip models.Trip) error {
	var tripInterface map[string]interface{}
	jsonTrip, _ := json.Marshal(trip)
	err := json.Unmarshal(jsonTrip, &tripInterface)
	if err != nil {
		return err
	}
	err = r.db.Model(&models.Trip{}).Updates(tripInterface).Error
	if err != nil {
		return err
	}
	return nil
}
