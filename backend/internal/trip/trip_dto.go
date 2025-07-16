package trip

type TimeRangeRequest struct {
	From          string `form:"from"`
	To            string `form:"to"`
	DepartureTime int    `form:"departure_time"`
	ArrivalTime   int    `form:"arrival_time"`
}
