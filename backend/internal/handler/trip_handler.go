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

func (handler *TripHandler) GetTrips(context *gin.Context) {
	trips, err := handler.service.GetAllTrips()
	if err != nil {
		utils.SendErrorResponse(context, http.StatusInternalServerError, err)
		return
	}
	context.JSON(200, trips)
}
