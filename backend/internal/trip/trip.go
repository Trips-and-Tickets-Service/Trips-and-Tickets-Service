package trip

import "time"

type Trip struct {
	ID             uint      `json:"id"`
	FromPlanet           string    `json:"from_planet"`
	ToPlanet             string    `json:"to_planet"`
	DepartureTime  time.Time `json:"departure_time"`
	ArrivalTime    time.Time `json:"arrival_time"`
	AvailableSeats uint      `json:"available_seats"`
	MaxSeats       uint      `json:"max_seats"`
	Price          uint      `json:"price"`
}
