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

// CreateTicket godoc
// @Summary Create a new ticket
// @Description Creates a ticket for a specified trip for the current user
// @Tags tickets
// @Accept json
// @Produce json
// @Param request body ticket.OrderTicketRequest true "Order Ticket Request"
// @Success 200
// @Failure 400 {object} utils.ErrorResponse "Bad Request"
// @Failure 404 {object} utils.ErrorResponse "User Not Found"
// @Failure 500 {object} utils.ErrorResponse "Internal Server Error"
// @Router /tickets [post]
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
	context.Status(http.StatusOK)
}

// GetUserTickets godoc
// @Summary Get tickets for the current user
// @Description Retrieves a list of tickets associated with the currently authenticated user
// @Tags tickets
// @Produce json
// @Success 200 {array} models.Ticket "List of user tickets"
// @Failure 404 {object} utils.ErrorResponse "User Not Found"
// @Failure 500 {object} utils.ErrorResponse "Internal Server Error"
// @Router /tickets/user [get]
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

// GetUserTrips godoc
// @Summary Get trips for the current user
// @Description Retrieves a list of trips associated with the tickets of the currently authenticated user
// @Tags trips
// @Produce json
// @Success 200 {array} models.Trip "List of user trips"
// @Failure 404 {object} utils.ErrorResponse "User Not Found"
// @Failure 500 {object} utils.ErrorResponse "Internal Server Error"
// @Router /trips/user [get]
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
