# Nexspace - an app for buying tickets between planets
<img src="./Screenshots%20and%20GIFs/logo.png" alt="project logo" width="300" height = "400">

## Project description

### A cross-platform mobile application with Flutter frontend and Go backend.:

1) User Authentication: Secure login and registration system to manage individual user accounts.

2) The main ticket purchase screen where the user can select the departure point, destination and flight time. The bottom panel allows you to access the current page, purchased tickets, the planetarium (brief information about the planets) and settings.

3) Settings Page: allows the user to select a language, a topic, log out of the account, and view user information.

4) Planetarium: allows you to study the climate and interesting facts about the planets to which we sell tickets

5) My Tickets: allows you to view the tickets you have purchased

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

Bairamov Amir: Frontend developer

Gazizov Bulat: Backend developer

Permiakov Lev: Devops

## Running with Docker

1. To get the file .env write permyakovlev345@gmail.com

2. Build and start all services:
   ```sh
   docker-compose up --build
   ```

3. Access to the website at:
 [http://localhost:8000](http://localhost:8080)

 ## Main function

 1. Demonstration of operation and validation during registration and account login
 
  <img src="./Screenshots%20and%20GIFs/registration.gif" alt="Описание" width="800" />

 2. Selecting and buying tickets, saving them in your account
 
  <img src="./Screenshots%20and%20GIFs/ticket purchase.gif" alt="Описание" width="800" />

 3. Application personalization dark/light theme, Russian/English
 
  <img src="./Screenshots%20and%20GIFs/personalization.gif" alt="Описание" width="800" />

 4. Information about the planet and background information about the weather on it
 
 <img src="./Screenshots%20and%20GIFs/information about the planets.gif" alt="Описание" width="800" />