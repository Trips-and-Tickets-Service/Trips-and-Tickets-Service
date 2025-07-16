package middleware

import (
	"errors"
	"github.com/gin-gonic/gin"
	"net/http"
	"nexspace/main/internal/jwtservice"
	"nexspace/main/pkg/utils"
)

func AuthMiddleware(service *jwtservice.JWTService) gin.HandlerFunc {
	return func(c *gin.Context) {
		tokenString := c.GetHeader("Authorization")
		if tokenString == "" {
			utils.SendErrorResponse(c, http.StatusUnauthorized, errors.New("authorization header required"))
			return
		}

		claims, err := service.ValidateToken(tokenString)

		if err != nil {
			utils.SendErrorResponse(c, http.StatusUnauthorized, err)
			return
		}

		c.Set("user_id", claims.UserID)
		c.Next()
	}
}
