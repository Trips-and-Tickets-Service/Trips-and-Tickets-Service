package utils

import (
	"errors"
	"nexspace/main/internal/user"
	"regexp"
)

func ValidateUser(request user.RegisterUserRequest) error {
	err := validateName(request.Name)
	if err != nil {
		return err
	}
	err = validateEmail(request.Email)
	if err != nil {
		return err
	}
	err = validatePassword(request.Password)
	if err != nil {
		return err
	}
	return nil
}

func validateName(name string) error {
	if len(name) < 1 || len(name) > 16 {
		return errors.New("name should be from 1 to 16")
	}
	return nil
}

func validatePassword(password string) error {
	if len(password) < 6 || len(password) > 16 {
		return errors.New("password should be from 1 to 16")
	}
	return nil
}

func validateEmail(email string) error {
	emailRegex := regexp.MustCompile(`^[a-z0-9._%+\-]+@[a-z0-9.\-]+\.[a-z]{2,4}$`)
	if !emailRegex.MatchString(email) {
		return errors.New("email is invalid")
	}
	return nil
}
