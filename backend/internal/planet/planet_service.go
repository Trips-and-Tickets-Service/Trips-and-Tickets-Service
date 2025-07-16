package planet

type Service struct {
	repository *Repository
}

func NewPlanetService(repository *Repository) *Service {
	return &Service{repository: repository}
}
