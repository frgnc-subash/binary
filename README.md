# BINARY

A language-learning platform built with ASP.NET Web Forms. Learners enrol in language courses, work through lessons with text and video, take quizzes, and earn XP to climb the leaderboard. Admins manage courses, lessons, quizzes, and users from a separate dashboard.

**Live site:** http://binarylms.runasp.net

## Features

### Learners
- **Get Started onboarding**: pick the languages you want to learn, the languages you already speak, and why you're learning, then create an account
- **Course catalogue**: browse published courses by language, each with its country flag and level
- **Lessons**: text content plus an optional video (YouTube, Vimeo, or an uploaded MP4/WEBM/OGV file)
- **Quizzes**: multiple-choice quizzes per lesson, scored automatically, with an answer review and attempt history
- **Progress tracking**: per-course progress, plus daily streaks and a weekly activity chart on your profile
- **XP and titles**: earn XP and unlock titles from *Beginner* to *Master Polyglot*
- **Leaderboard**: learners ranked by XP
- **Notifications**: in-app notification drawer for enrolments, quiz results, and new titles
- **Profile**: profile picture, account details, and password change
- **Light and dark themes**, and a responsive layout with slide-in menus on phones

### Admins
- **Dashboard and reports**: enrolment counts, top courses, recent registrations and activity
- **Courses and lessons**: create, edit, publish or hide courses, set lesson order, attach videos
- **Lesson quizzes**: build questions and answer options for each lesson
- **Languages**: manage the language families courses are grouped under
- **Users**: edit details, change roles, activate or deactivate accounts
- **Feedback**: read messages sent through the Contact page

### XP rules

| Action | XP |
|---|---|
| Complete a lesson | +20 |
| Complete every lesson in a course | +100 bonus |
| Each correct quiz answer | +5 |

| Title | XP needed |
|---|---|
| Beginner | 0 |
| Active Learner | 50 |
| Avid Explorer | 200 |
| Language Scholar | 500 |
| Master Polyglot | 1000 |

## Tech stack

| Layer | Technology |
|---|---|
| Framework | ASP.NET Web Forms on .NET Framework 4.7.2 (C#) |
| Database | Microsoft SQL Server, accessed with ADO.NET (parameterised SQL, no ORM) |
| Frontend | Server-rendered HTML, custom CSS (`Content/Site.css`), plain JavaScript (`Scripts/binary-ui.js`) |
| Server | IIS / IIS Express |
| Libraries | FriendlyUrls (clean URLs), Web Optimization (bundling), jQuery, Newtonsoft.Json |

## Project structure

```
binary/
├── Admin/              Admin pages (courses, lessons, quizzes, users, reports, feedback)
├── Auth/               Get Started, Register, Login, Logout
├── Courses/            Course catalogue and course detail (lessons, videos, quizzes)
├── Users/              Learner dashboard and profile
├── Leaderboard/        XP leaderboard
├── Pages/              About and Contact
├── MasterPages/        Shared layouts: Site.Master (learners), AdminMaster.master (admins)
├── Controls/           Reusable user controls (notification bell)
├── Handlers/           JSON endpoint for the notification drawer
├── Models/             Plain data classes mirroring the database tables
├── Core/
│   ├── BLL/            Business logic (auth, enrolment, quizzes, XP, notifications)
│   ├── DAL/            Data access, one class per table
│   └── Helpers/        Database, password hashing, video, avatar, and flag helpers
├── App_Data/           CreateDatabase.sql: schema and seed data
├── Content/            CSS and images (logos, country flags)
└── Scripts/            JavaScript
```

The code follows a three-layer design: **pages → BLL → DAL → SQL Server**. Pages never query the database directly.

## Getting started

### Prerequisites
- Windows with **Visual Studio 2022** and the *ASP.NET and web development* workload (includes .NET Framework 4.7.2 and IIS Express)
- **SQL Server**: Express, LocalDB, or a hosted instance

### 1. Clone the repository
```bash
git clone https://github.com/frgnc-subash/binary.git
```

### 2. Create the database
Create an empty database, then run `App_Data/CreateDatabase.sql` against it (in SQL Server Management Studio or Visual Studio's SQL Server Object Explorer). The script creates all the tables and seeds the roles, categories, nine courses, and their lessons. It is safe to run more than once.

### 3. Add your connection string
The connection string is kept out of source control. Copy the template and fill in your database details:

```bash
copy ConnectionStrings.example.config ConnectionStrings.config
```

`ConnectionStrings.config` is git-ignored, so **never commit it**. Without it the site shows a configuration error at startup.

### 4. Run
Open `binary.slnx` in Visual Studio and press **F5**. NuGet packages are restored on the first build, and the site opens at `https://localhost:44372/`.

### 5. Create your first admin
No admin account is seeded, so no credentials live in the repo.

1. Register a normal account through the site.
2. Promote it to admin by running this against the database:
   ```sql
   UPDATE Users
   SET RoleID = (SELECT RoleID FROM Roles WHERE RoleName = 'Admin')
   WHERE Email = 'you@example.com';
   ```
3. Log out and back in. Admins are sent to `/Admin` after signing in.

From then on, admins can change other users' roles on the **Users** page.

## Roles

| Role | Can do |
|---|---|
| **Member** | Browse and enrol in courses, complete lessons, take quizzes, earn XP, edit their profile |
| **Admin** | Everything above, plus manage courses, lessons, quizzes, languages, users, and feedback |

## Security

- Passwords are hashed with SHA-256 and a random per-user salt
- Accounts lock for 15 minutes after 5 failed sign-in attempts
- Sign-in errors don't reveal whether an email is registered
- All SQL uses parameters, which prevents SQL injection
- Uploads are restricted by file type, renamed to random names, and can't run as scripts
- Database credentials live in the git-ignored `ConnectionStrings.config`

## Deployment

The site is published to a shared ASP.NET host over FTP from Visual Studio, using `Properties/PublishProfiles/FTPProfile.pubxml`:

1. Make sure `ConnectionStrings.config` in the project folder has the **production** database details. It is uploaded with the site.
2. Right-click the project → **Publish** → choose the FTP profile → **Publish**. Visual Studio asks for the FTP password the first time on each machine.
3. If the live site shows *"Unable to open configSource file 'ConnectionStrings.config'"*, upload that file by hand to `wwwroot`, next to `Web.config`.

Uploaded videos and profile pictures in `Uploads/` are kept between publishes.

## License

[MIT](LICENSE)
