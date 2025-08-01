package handler

import (
	"github.com/gin-gonic/gin"
	"net/http"
	"nexspace/main/internal/user"
	"nexspace/main/pkg/utils"
)

type UserHandler struct {
	service *user.Service
}

func NewUserHandler(service *user.Service) *UserHandler {
	return &UserHandler{service: service}
}

// SignUp godoc
//
//	@Summary		SignUp
//	@Description	signup user
//	@Tags			users
//	@Accept			json
//	@Produce		json
//	@Success		200	{object}	user.AccessToken
//	@Failure		400	{object}	utils.ErrorResponse
//	@Failure		404	{object}	utils.ErrorResponse
//	@Failure		500	{object}	utils.ErrorResponse
//	@Router			/users/signup [post]
func (handler *UserHandler) SignUp(context *gin.Context) {
	var request user.RegisterUserRequest
	if err := context.ShouldBind(&request); err != nil {
		utils.SendErrorResponse(context, http.StatusBadRequest, err)
		return
	}
	if err := utils.ValidateUser(request); err != nil {
		utils.SendErrorResponse(context, http.StatusBadRequest, err)
		return
	}

	accessToken, err := handler.service.RegisterUser(request)
	if err != nil {
		utils.SendErrorResponse(context, http.StatusInternalServerError, err)
		return
	}
	context.JSON(http.StatusOK, accessToken)
}

// SignIn godoc
// @Summary Sign in a user
// @Description Logs in a user and returns an access token
// @Tags users
// @Accept json
// @Produce json
// @Param request body user.LoginUserRequest true "Login User Request"
// @Success 200 {string} string "Access Token"
// @Failure 400 {object} utils.ErrorResponse "Bad Request"
// @Failure 401 {object} utils.ErrorResponse "Unauthorized"
// @Router /signin [post]
func (handler *UserHandler) SignIn(context *gin.Context) {
	var request user.LoginUserRequest
	if err := context.ShouldBind(&request); err != nil {
		utils.SendErrorResponse(context, http.StatusBadRequest, err)
		return
	}

	accessToken, err := handler.service.LoginUser(request)
	if err != nil {
		utils.SendErrorResponse(context, http.StatusUnauthorized, err)
		return
	}
	context.JSON(http.StatusOK, accessToken)
}
