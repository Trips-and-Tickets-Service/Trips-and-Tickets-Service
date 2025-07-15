package user

import (
	"errors"
	"gorm.io/gorm"
)

type Repository struct {
	db *gorm.DB
}

func NewUserRepository(db *gorm.DB) *Repository {
	return &Repository{db: db}
}
func (r *Repository) GetUserByEmail(email string) (user User, err error) {
	err = r.db.Where(&User{Email: email}).First(&user).Error
	if errors.Is(err, gorm.ErrRecordNotFound) {
		return User{}, nil
	}
	return user, err
}

func (r *Repository) Create(user *User) error {
	result := r.db.Create(&user)
	if result.Error != nil {
		return result.Error
	}
	// user variable will be updated automatically
	return nil
}
