# Nexspace - an app for buying tickets between planets
<img src="./Screenshots%20and%20GIFs/logo.png" alt="project logo" width="300" height = "400">

## Project description

### A cross-platform mobile application with Flutter frontend and Go backend.:

1) User Authentication JWT: Secure login and registration system to manage individual user accounts.

2) Search page: The main ticket purchase screen where the user can select the departure point, destination and flight time. The bottom panel allows you to access the current page, purchased tickets, the planetarium (brief information about the planets) and settings.

3) My Tickets: allows you to view the tickets you have purchased

4) Planetarium: allows you to study the climate and interesting facts about the planets to which we sell tickets

5) Settings Page: allows the user to select a language, a light/dark mode, log out of the account, and view user information.

6) Real-Time Multiplayer Infrastructure: A database system to store user accounts and manage flight.

7) Error Handling and UI Feedback: Friendly error messages and loading states for smoother UX.

## 🛠 Tech Stack

### **Frontend**  
📱 Flutter 3.32.5

📦 Used resources:  
  - 'material'
  - 'provider': ^6.1.5
  - 'shared_preferences': ^2.5.3
  - 'http': ^1.4.0
  - 'foundation'
  - 'intl': ^0.20.2
  - 'dart:convert'
  - 'email_validator': ^3.0.0

### **Backend**  
🖥 Go 1.24.4  

📦 Used resources:    
  - 'Gin': ^1.10.1
  - 'GORM': ^1.25.10
  - 'godotenv' ^1.5.1
  - 'swag': ^2.0

## Team member

**Bairamov Amir**: Frontend developer

**Gazizov Bulat**: Backend developer

**Permiakov Lev**: DevOps

## Running with Docker

1. To get the file .env write permyakovlev345@gmail.com

2. Build and start all services:
   ```sh
   docker-compose up --build
   ```

3. Access to the website at:
 [http://localhost:8000](http://localhost:8080)

 ## Main function

 1. Demonstration of operation and validation during registration and account login (GIFs)
 
  <img src="./Screenshots%20and%20GIFs/registration.gif" alt="Описание" width="800" />

 2. Selecting and buying tickets, saving them in your account(GIFs)
 
  <img src="./Screenshots%20and%20GIFs/ticket purchase.gif" alt="Описание" width="800" />

 3. Application personalization dark/light theme, Russian/English(GIFs)
 
  <img src="./Screenshots%20and%20GIFs/personalization.gif" alt="Описание" width="800" />

 4. Information about the planet and background information about the weather on it(GIFs)
 
 <img src="./Screenshots%20and%20GIFs/information about the planets.gif" alt="Описание" width="800" />

## Presentation link

Link: https://drive.google.com/file/d/1gG01dnHijQTdpOuG_4dkzMCO-iD3i5J6/view?usp=drive_link

## Demo video link

Link: https://drive.google.com/file/d/1JmXDxFSBf05L8EDf1lUXs9uD-fGKO2yG/view?usp=sharing

## Architecture diagrams

 <img src="./Screenshots%20and%20GIFs/Architecture_1.png" alt="Описание" width="800" />

Explanations: All repositories are independable, services communicate with each other. 

## Database with proper schema design

<img src="./Screenshots%20and%20GIFs/graphviz.svg" alt="Описание" width="800" />


## API documentation

<img src="./Screenshots%20and%20GIFs/Architecture.png" alt="Описание" width="800" />

## Implementation checklist

### Technical requirements (20 points)
#### Backend development (8 points)
- [X] Go-based backend (3 points)
- [X] RESTful API with Swagger documentation (2 points)
- [X] PostgreSQL database with proper schema design (1 point)
- [X] JWT-based authentication and authorization (1 point)
- [ ] Comprehensive unit and integration tests (1 point)

#### Frontend development (8 points)
- [X] Flutter-based cross-platform application (mobile + web) (3 points)
- [X] Responsive UI design with custom widgets (1 point)
- [X] State management implementation (1 point)
- [X] Offline data persistence (1 point)
- [ ] Unit and widget tests (1 point)
- [X] Support light and dark mode (1 point)

#### DevOps & deployment (4 points)
- [X] Docker compose for all services (1 point)
- [X] CI/CD pipeline implementation (1 point)
- [X] Environment configuration management using config files (1 point)
- [X] GitHub pages for the project (1 point)

### Non-Technical Requirements (10 points)
#### Project management (4 points)
- [X] GitHub organization with well-maintained repository (1 point)
- [X] Regular commits and meaningful pull requests from all team members (1 point)
- [X] Project board (GitHub Projects) with task tracking (1 point)
- [X] Team member roles and responsibilities documentation (1 point)

#### Documentation (4 points)
- [X] Project overview and setup instructions (1 point)
- [X] Screenshots and GIFs of key features (1 point)
- [X] API documentation (1 point)
- [X] Architecture diagrams and explanations (1 point)

#### Code quality (2 points)
- [X] Consistent code style and formatting during CI/CD pipeline (1 point)
- [X] Code review participation and resolution (1 point)

### Bonus Features (up to 10 points)
- [X] Localization for Russian (RU) and English (ENG) languages (2 points)
- [X] Good UI/UX design (up to 3 points)
- [ ] Integration with external APIs (fitness trackers, health devices) (up to 5 points)
- [X] Comprehensive error handling and user feedback (up to 2 points)
- [X] Advanced animations and transitions (up to 3 points)
- [ ] Widget implementation for native mobile elements (up to 2 points)

Total points implemented: 38/30 (excluding bonus points)

Note: For each implemented feature, provide a brief description or link to the relevant implementation below the checklist.