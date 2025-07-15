package trip

import "time"

type Trip struct {
	ID             uint      `json:"id"`
	From           string    `json:"from"`
	To             string    `json:"to"`
	DepartureTime  time.Time `json:"departure_time"`
	ArrivalTime    time.Time `json:"arrival_time"`
	AvailableSeats uint      `json:"available_seats"`
	MaxSeats       uint      `json:"max_seats"`
}
