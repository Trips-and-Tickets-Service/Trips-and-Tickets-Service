package user

import (
	"errors"
	"gorm.io/gorm"
	"nexspace/main/internal/models"
)

type Repository struct {
	db *gorm.DB
}

func NewUserRepository(db *gorm.DB) *Repository {
	return &Repository{db: db}
}
func (r *Repository) GetUserByEmail(email string) (user models.User, err error) {
	err = r.db.Where(&models.User{Email: email}).First(&user).Error
	if errors.Is(err, gorm.ErrRecordNotFound) {
		return models.User{}, nil
	}
	return user, err
}

func (r *Repository) Create(user *models.User) error {
	result := r.db.Create(&user)
	if result.Error != nil {
		return result.Error
	}
	// user variable will be updated automatically
	return nil
}

func (r *Repository) GetUser(id int) (user models.User, err error) {
	err = r.db.First(&user, id).Error
	if errors.Is(err, gorm.ErrRecordNotFound) {
		return models.User{}, nil
	}
	return user, err
}
