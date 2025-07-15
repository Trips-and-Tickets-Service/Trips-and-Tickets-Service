package handler

import (
	"errors"
	"github.com/gin-gonic/gin"
	"net/http"
	"nexspace/main/internal/ticket"
	"nexspace/main/internal/user"
	"nexspace/main/pkg/utils"
)

type TicketHandler struct {
	service     *ticket.Service
	userService *user.Service
}

func NewTicketHandler(service *ticket.Service, userService *user.Service) *TicketHandler {
	return &TicketHandler{service: service, userService: userService}
}

func (handler *TicketHandler) CreateTicket(context *gin.Context) {
	var request ticket.OrderTicketRequest
	if err := context.ShouldBind(&request); err != nil {
		utils.SendErrorResponse(context, http.StatusBadRequest, err)
		return
	}
	currentUser := handler.userService.GetCurrentUser(context)
	if currentUser == nil {
		utils.SendErrorResponse(context, http.StatusNotFound, errors.New("cannot find user"))
	}
	err := handler.service.CreateTicket(currentUser.ID, request.TripId)
	if err != nil {
		utils.SendErrorResponse(context, http.StatusInternalServerError, err)
		return
	}
}

func (handler *TicketHandler) GetUserTickets(context *gin.Context) {
	currentUser := handler.userService.GetCurrentUser(context)
	if currentUser == nil {
		utils.SendErrorResponse(context, http.StatusNotFound, errors.New("cannot find user"))
	}
	tickets, err := handler.service.GetUserTickets(currentUser)
	if err != nil {
		utils.SendErrorResponse(context, http.StatusInternalServerError, err)
		return
	}
	context.JSON(http.StatusOK, tickets)
}

func (handler *TicketHandler) GetUserTrips(context *gin.Context) {
	currentUser := handler.userService.GetCurrentUser(context)
	if currentUser == nil {
		utils.SendErrorResponse(context, http.StatusNotFound, errors.New("cannot find user"))
	}
	tickets, err := handler.service.GetUserTrips(currentUser)
	if err != nil {
		utils.SendErrorResponse(context, http.StatusInternalServerError, err)
		return
	}
	context.JSON(http.StatusOK, tickets)
}
