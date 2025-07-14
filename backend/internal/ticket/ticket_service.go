package ticket

type Service struct {
	repository *Repository
}

func NewTicketService(repository *Repository) *Service {
	return &Service{repository: repository}
}
