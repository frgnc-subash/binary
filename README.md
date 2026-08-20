# BINARY

A web-based language learning platform where users can browse courses, view learning materials, and take quizzes to track their progress.

## Features

- User registration and login
- Course browsing and enrollment
- Learning materials (text, image, audio)
- Quizzes with automatic scoring and result history
- Admin dashboard to manage users, courses, materials, and quizzes

## Tech Stack

- **Framework:** ASP.NET (MVC)
- **Database:** MySQL
- **Frontend:** HTML, CSS, JavaScript (custom CSS, no frameworks)

## Getting Started

1. Clone the repository
   ```bash
   git clone https://github.com/frgnc-subash/binary.git
   ```
2. Import the database schema into MySQL
3. Update the connection string in `appsettings.json` (or `Web.config`)
4. Run the project from Visual Studio or via:
   ```bash
   dotnet run
   ```
5. Open `https://localhost:PORT` in your browser


## Roles

- **User:** browse courses, view materials, take quizzes, track results
- **Admin:** manage users, courses, materials, and quizzes
