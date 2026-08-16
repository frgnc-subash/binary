-- =====================================================
-- binary language learning platform — mysql database setup
-- run this script in mysql workbench, phpmyadmin, or mysql cli
-- =====================================================

CREATE DATABASE IF NOT EXISTS auth CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE auth;

-- roles table
CREATE TABLE IF NOT EXISTS Roles (
    RoleID   INT AUTO_INCREMENT PRIMARY KEY,
    RoleName VARCHAR(50) NOT NULL UNIQUE
) ENGINE=InnoDB;

-- users table with lockout support
CREATE TABLE IF NOT EXISTS Users (
    UserID              INT AUTO_INCREMENT PRIMARY KEY,
    FirstName           VARCHAR(100) NOT NULL,
    LastName            VARCHAR(100) NOT NULL,
    Email               VARCHAR(256) NOT NULL UNIQUE,
    PasswordHash        VARCHAR(128) NOT NULL,
    PasswordSalt        VARCHAR(64)  NOT NULL,
    RoleID              INT NOT NULL DEFAULT 2,
    IsActive            TINYINT(1) NOT NULL DEFAULT 1,
    FailedLoginAttempts INT NOT NULL DEFAULT 0,
    LockoutEndUtc       DATETIME NULL,
    CreatedDate         DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_users_roles FOREIGN KEY (RoleID) REFERENCES Roles(RoleID)
) ENGINE=InnoDB;

-- categories table
CREATE TABLE IF NOT EXISTS Categories (
    CategoryID INT AUTO_INCREMENT PRIMARY KEY,
    Name       VARCHAR(100) NOT NULL UNIQUE
) ENGINE=InnoDB;

-- courses table
CREATE TABLE IF NOT EXISTS Courses (
    CourseID     INT AUTO_INCREMENT PRIMARY KEY,
    Title        VARCHAR(200) NOT NULL,
    Description  TEXT NULL,
    CategoryID   INT NOT NULL,
    Level        VARCHAR(50) NOT NULL DEFAULT 'Beginner',
    ThumbnailUrl VARCHAR(500) NULL,
    IsPublished  TINYINT(1) NOT NULL DEFAULT 1,
    CreatedBy    INT NULL,
    CreatedDate  DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_courses_categories FOREIGN KEY (CategoryID) REFERENCES Categories(CategoryID),
    CONSTRAINT fk_courses_users FOREIGN KEY (CreatedBy) REFERENCES Users(UserID)
) ENGINE=InnoDB;

-- lessons table
CREATE TABLE IF NOT EXISTS Lessons (
    LessonID  INT AUTO_INCREMENT PRIMARY KEY,
    CourseID  INT NOT NULL,
    Title     VARCHAR(200) NOT NULL,
    Content   TEXT NULL,
    VideoUrl  VARCHAR(500) NULL,
    SortOrder INT NOT NULL DEFAULT 0,
    CONSTRAINT fk_lessons_courses FOREIGN KEY (CourseID) REFERENCES Courses(CourseID) ON DELETE CASCADE
) ENGINE=InnoDB;

-- enrollments table
CREATE TABLE IF NOT EXISTS Enrollments (
    EnrollmentID    INT AUTO_INCREMENT PRIMARY KEY,
    UserID          INT NOT NULL,
    CourseID        INT NOT NULL,
    ProgressPercent INT NOT NULL DEFAULT 0,
    EnrolledDate    DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_enrollments_users FOREIGN KEY (UserID) REFERENCES Users(UserID),
    CONSTRAINT fk_enrollments_courses FOREIGN KEY (CourseID) REFERENCES Courses(CourseID),
    CONSTRAINT uq_user_course UNIQUE (UserID, CourseID)
) ENGINE=InnoDB;

-- lesson progress table
CREATE TABLE IF NOT EXISTS LessonProgress (
    ProgressID    INT AUTO_INCREMENT PRIMARY KEY,
    EnrollmentID  INT NOT NULL,
    LessonID      INT NOT NULL,
    IsCompleted   TINYINT(1) NOT NULL DEFAULT 0,
    CompletedDate DATETIME NULL,
    CONSTRAINT fk_lp_enrollments FOREIGN KEY (EnrollmentID) REFERENCES Enrollments(EnrollmentID),
    CONSTRAINT fk_lp_lessons FOREIGN KEY (LessonID) REFERENCES Lessons(LessonID) ON DELETE CASCADE,
    CONSTRAINT uq_enrollment_lesson UNIQUE (EnrollmentID, LessonID)
) ENGINE=InnoDB;

-- quizzes table
CREATE TABLE IF NOT EXISTS Quizzes (
    QuizID   INT AUTO_INCREMENT PRIMARY KEY,
    CourseID INT NOT NULL,
    Title    VARCHAR(200) NOT NULL,
    CONSTRAINT fk_quizzes_courses FOREIGN KEY (CourseID) REFERENCES Courses(CourseID) ON DELETE CASCADE
) ENGINE=InnoDB;

-- questions table
CREATE TABLE IF NOT EXISTS Questions (
    QuestionID   INT AUTO_INCREMENT PRIMARY KEY,
    QuizID       INT NOT NULL,
    QuestionText TEXT NOT NULL,
    SortOrder    INT NOT NULL DEFAULT 0,
    CONSTRAINT fk_questions_quizzes FOREIGN KEY (QuizID) REFERENCES Quizzes(QuizID) ON DELETE CASCADE
) ENGINE=InnoDB;

-- question options table
CREATE TABLE IF NOT EXISTS QuestionOptions (
    OptionID   INT AUTO_INCREMENT PRIMARY KEY,
    QuestionID INT NOT NULL,
    OptionText VARCHAR(500) NOT NULL,
    IsCorrect  TINYINT(1) NOT NULL DEFAULT 0,
    CONSTRAINT fk_options_questions FOREIGN KEY (QuestionID) REFERENCES Questions(QuestionID) ON DELETE CASCADE
) ENGINE=InnoDB;

-- quiz attempts table
CREATE TABLE IF NOT EXISTS QuizAttempts (
    AttemptID   INT AUTO_INCREMENT PRIMARY KEY,
    UserID      INT NOT NULL,
    QuizID      INT NOT NULL,
    Score       INT NOT NULL DEFAULT 0,
    MaxScore    INT NOT NULL DEFAULT 0,
    AttemptDate DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_attempts_users FOREIGN KEY (UserID) REFERENCES Users(UserID),
    CONSTRAINT fk_attempts_quizzes FOREIGN KEY (QuizID) REFERENCES Quizzes(QuizID)
) ENGINE=InnoDB;

-- feedback table (userid is nullable for guest messages)
CREATE TABLE IF NOT EXISTS Feedback (
    FeedbackID    INT AUTO_INCREMENT PRIMARY KEY,
    UserID        INT NULL,
    Name          VARCHAR(200) NOT NULL,
    Email         VARCHAR(256) NOT NULL,
    Subject       VARCHAR(200) NULL,
    Message       TEXT NOT NULL,
    SubmittedDate DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_feedback_users FOREIGN KEY (UserID) REFERENCES Users(UserID)
) ENGINE=InnoDB;

-- =====================================================
-- seed data
-- =====================================================

INSERT IGNORE INTO Roles (RoleID, RoleName) VALUES
(1, 'Admin'),
(2, 'Member');

INSERT IGNORE INTO Categories (CategoryID, Name) VALUES
(1, 'European Languages'),
(2, 'Asian Languages'),
(3, 'Middle Eastern Languages'),
(4, 'African Languages');

INSERT IGNORE INTO Courses (CourseID, Title, Description, CategoryID, Level, IsPublished) VALUES
(1, 'Spanish for Beginners', 'Core pronunciation, daily vocabulary, ordering food, and common conversation.', 1, 'Beginner', 1),
(2, 'French Immersion', 'Past tenses, cafe dialogue, and French cultural expressions.', 1, 'Intermediate', 1),
(3, 'German Foundations', 'Articles (der/die/das), cases, and essential German phrases.', 1, 'Beginner', 1),
(4, 'Japanese: Zero to N3', 'Hiragana, Katakana, core Kanji patterns, and conversational JLPT skills.', 2, 'All Levels', 1),
(5, 'Mandarin Chinese', 'Tones, characters, and practical spoken Mandarin.', 2, 'Beginner', 1),
(6, 'Korean Essentials', 'Master Hangeul alphabet, daily expressions, and K-culture phrases.', 2, 'Beginner', 1);

INSERT IGNORE INTO Lessons (LessonID, CourseID, Title, Content, SortOrder) VALUES
(1, 1, 'Greetings & Basics', 'Learn to say Hola, Buenos dias, and introduce yourself.', 1),
(2, 1, 'Numbers 1-100', 'Counting, prices, and everyday quantities.', 2),
(3, 1, 'Ser vs. Estar', 'Understand the two Spanish verbs for "to be".', 3),
(4, 1, 'At the Cafe', 'Ordering coffee, asking for the bill, and polite requests.', 4),
(5, 1, 'Directions', 'Asking where things are and understanding navigation in Spanish.', 5);
