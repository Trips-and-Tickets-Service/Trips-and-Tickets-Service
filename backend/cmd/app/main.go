package main

import (
	"fmt"
	"github.com/gin-gonic/gin"
	"github.com/swaggo/files"
	"github.com/swaggo/gin-swagger"
	"gorm.io/driver/postgres"
	"gorm.io/gorm"
	"log"
	"net/http"
	"nexspace/main/cmd/docs"
	"nexspace/main/internal/handler"
	"nexspace/main/internal/jwtservice"
	"nexspace/main/internal/middleware"
	"nexspace/main/internal/models"
	"nexspace/main/internal/ticket"
	trip "nexspace/main/internal/trip"
	"nexspace/main/internal/user"
	"nexspace/main/pkg/config"
	"time"
)

//	@contact.name	API Support
//	@contact.url	http://www.swagger.io/support
//	@contact.email	support@swagger.io

// @license.name	Apache 2.0
// @license.url	http://www.apache.org/licenses/LICENSE-2.0.html
func main() {
	cfg, err := config.LoadConfig()

	if err != nil {
		log.Fatal(err)
	}

	docs.SwaggerInfo.Title = "Nexspace API"
	docs.SwaggerInfo.Description = "An analogue of Aviasales for traveling between planets."
	docs.SwaggerInfo.Version = "1.0"
	docs.SwaggerInfo.Host = "localhost:" + cfg.HTTP.Port
	docs.SwaggerInfo.BasePath = "/api"
	docs.SwaggerInfo.Schemes = []string{"http", "https"}

	router := gin.New()

	// Global middleware
	// Logger middleware will write the logs to gin.DefaultWriter even if you set with GIN_MODE=release.
	// By default, gin.DefaultWriter = os.Stdout
	router.Use(gin.Logger())

	// Recovery middleware recovers from any panics and writes a 500 if there was one.
	router.Use(gin.Recovery())
	dsn := fmt.Sprintf("host=%s port=%s user=%s password=%s dbname=%s sslmode=%s TimeZone=Europe/Moscow",
		cfg.DB.Host, "5432", cfg.DB.User, cfg.DB.Password,
		cfg.DB.DbName, "disable")
	db, err := gorm.Open(postgres.Open(dsn), &gorm.Config{})
	if err != nil {
		log.Fatal(err)
	}
	err = db.AutoMigrate(models.User{}, models.Trip{}, models.Ticket{})
	if err != nil {
		log.Println("Error while migration:")
		log.Fatal(err)
	}

	jwtService, err := jwtservice.NewJWTService(cfg.JWT.SecretKey)
	if err != nil {
		log.Fatal(err)
	}

	userService := user.NewUserService(user.NewUserRepository(db), *jwtService)
	userHandler := handler.NewUserHandler(userService)

	tripService := trip.NewTripService(trip.NewTripRepository(db))
	tripHandler := handler.NewTripHandler(tripService)

	ticketService := ticket.NewTicketService(ticket.NewTicketRepository(db), tripService)
	ticketHandler := handler.NewTicketHandler(ticketService, userService)

	router.Use(middleware.CorsMiddleware())

	public := router.Group("/api")
	{
		public.POST("/signup", userHandler.SignUp)
		public.POST("/signin", userHandler.SignIn)
	}

	private := router.Group("/api")
	private.Use(middleware.AuthMiddleware(jwtService))
	{
		// Endpoints only for authorized users
		private.GET("/test", func(context *gin.Context) {
			context.Status(http.StatusOK)
		})

		private.GET("/trips", tripHandler.GetTrips)
		private.GET("/trips/schedule", tripHandler.GetTripsInRange)

		private.GET("/tickets", ticketHandler.GetUserTickets)
		private.GET("/users/trips", ticketHandler.GetUserTrips)
		private.POST("/tickets", ticketHandler.CreateTicket)
	}

	router.GET("/swagger/*any", ginSwagger.WrapHandler(swaggerFiles.Handler))

	server := &http.Server{
		Addr:           ":" + cfg.HTTP.Port,
		Handler:        router,
		ReadTimeout:    10 * time.Second,
		WriteTimeout:   10 * time.Second,
		MaxHeaderBytes: 1 << 20,
	}

	err = server.ListenAndServe()
	if err != nil {
		log.Fatal(err)
		return
	}
}
