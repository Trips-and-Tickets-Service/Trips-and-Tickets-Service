package models

import "time"

type Ticket struct {
	ID        uint `json:"id"`
	UserId    uint `json:"user_id"`
	TripId    uint `json:"trip_id"`
	CreatedAt time.Time
}

type TicketWithTripInfo struct {
	Ticket *Ticket `json:"ticket"`
	Trip   *Trip   `json:"trip"`
}
