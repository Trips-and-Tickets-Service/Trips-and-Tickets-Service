package handler

import (
	"github.com/gin-gonic/gin"
	"net/http"
	trip "nexspace/main/internal/trip"
	"nexspace/main/pkg/utils"
)

type TripHandler struct {
	service *trip.Service
}

func NewTripHandler(service *trip.Service) *TripHandler {
	return &TripHandler{service: service}
}

// GetTripsInRange godoc
// @Summary Get trips within a specified time range
// @Description Retrieves a list of trips that fall within the given time range
// @Tags trips
// @Accept json
// @Produce json
// @Param timeRange query trip.TimeRangeRequest true "Time Range Request"
// @Success 200 {array} models.Trip "List of trips within the specified time range"
// @Failure 400 {object} utils.ErrorResponse "Bad Request"
// @Failure 500 {object} utils.ErrorResponse "Internal Server Error"
// @Router /trips/range [get]
func (handler *TripHandler) GetTripsInRange(context *gin.Context) {
	var timeRange trip.TimeRangeRequest
	if err := context.ShouldBindQuery(&timeRange); err != nil {
		utils.SendErrorResponse(context, http.StatusBadRequest, err)
		return
	}
	trips, err := handler.service.GetTripsInRange(timeRange)
	if err != nil {
		utils.SendErrorResponse(context, http.StatusInternalServerError, err)
		return
	}
	context.JSON(200, trips)
}

// GetTrips godoc
// @Summary Get all trips
// @Description Retrieves a list of all trips
// @Tags trips
// @Produce json
// @Success 200 {array} models.Trip "List of trips"
// @Failure 500 {object} utils.ErrorResponse "Internal Server Error"
// @Router /trips [get]
func (handler *TripHandler) GetTrips(context *gin.Context) {
	trips, err := handler.service.GetAllTrips()
	if err != nil {
		utils.SendErrorResponse(context, http.StatusInternalServerError, err)
		return
	}
	context.JSON(200, trips)
}
