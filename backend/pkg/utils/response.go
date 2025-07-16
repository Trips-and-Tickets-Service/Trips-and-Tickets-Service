package utils

import "github.com/gin-gonic/gin"

type ErrorResponse struct {
	StatusCode int         `json:"statusCode"`
	Error      interface{} `json:"error"`
}

func SendErrorResponse(ctx *gin.Context, StatusCode int, Error error) {
	errResponse := ErrorResponse{
		StatusCode: StatusCode,
		Error:      Error.Error(),
	}

	ctx.JSON(StatusCode, errResponse)
	defer ctx.AbortWithStatus(StatusCode)
}
