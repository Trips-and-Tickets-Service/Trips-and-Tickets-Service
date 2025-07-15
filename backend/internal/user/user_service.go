package user

import (
	"errors"
	"github.com/gin-gonic/gin"
	"golang.org/x/crypto/bcrypt"
	"log"
	"nexspace/main/internal/jwtservice"
	"nexspace/main/internal/models"
)

type Service struct {
	repository *Repository
	jwtService jwtservice.JWTService
}

func NewUserService(repository *Repository, jwtService jwtservice.JWTService) *Service {
	return &Service{repository: repository, jwtService: jwtService}
}

func (s *Service) RegisterUser(request RegisterUserRequest) (AccessToken, error) {
	var existingUser models.User
	existingUser, err := s.repository.GetUserByEmail(request.Email)
	if err != nil {
		log.Print(err)
		return AccessToken{}, errors.New("internal error")
	}
	if existingUser.ID != 0 {
		return AccessToken{}, errors.New("user already registered")
	}

	password, err := bcrypt.GenerateFromPassword([]byte(request.Password), 10)

	if err != nil {
		return AccessToken{}, err
	}

	user := models.User{
		Name:     request.Name,
		Email:    request.Email,
		Password: string(password),
	}

	err = s.repository.Create(&user)
	if err != nil {
		return AccessToken{}, err
	}

	token, err := s.jwtService.GenerateToken(int(user.ID), user.Email)
	if err != nil {
		return AccessToken{}, err
	}

	return AccessToken{AccessToken: token, Name: user.Name}, nil
}

func (s *Service) LoginUser(request LoginUserRequest) (AccessToken, error) {
	user, err := s.repository.GetUserByEmail(request.Email)
	if err != nil {
		log.Print(err)
		return AccessToken{}, errors.New("internal error")
	}

	err = bcrypt.CompareHashAndPassword([]byte(user.Password), []byte(request.Password))
	if err != nil {
		return AccessToken{}, errors.New("invalid password")
	}
	token, err := s.jwtService.GenerateToken(int(user.ID), user.Email)
	if err != nil {
		return AccessToken{}, err
	}
	return AccessToken{AccessToken: token, Name: user.Name}, nil
}

func (s *Service) GetCurrentUser(c *gin.Context) *models.User {
	userId, exists := c.Get("user_id")
	if !exists {
		return nil
	}

	user, err := s.repository.GetUser(userId.(int))
	if err != nil {
		return nil
	}
	return &user
}
