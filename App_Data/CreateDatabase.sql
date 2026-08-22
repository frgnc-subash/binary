-- =====================================================
-- Binary Language Learning Platform — Database Setup
-- Run once in SSMS (or VS Server Explorer) to create
-- the entire database, tables, and sample data.
-- =====================================================

-- Create the database if it doesn't exist
IF DB_ID('Auth') IS NULL
    CREATE DATABASE Auth;
GO

USE Auth;
GO

-- ── Roles ──
IF OBJECT_ID('Roles', 'U') IS NULL
CREATE TABLE Roles (
    RoleID   INT IDENTITY(1,1) PRIMARY KEY,
    RoleName NVARCHAR(50) NOT NULL UNIQUE
);
GO

-- ── Users ──
IF OBJECT_ID('Users', 'U') IS NULL
CREATE TABLE Users (
    UserID              INT IDENTITY(1,1) PRIMARY KEY,
    FirstName           NVARCHAR(100)  NOT NULL,
    LastName            NVARCHAR(100)  NOT NULL,
    Email               NVARCHAR(256)  NOT NULL UNIQUE,
    PasswordHash        NVARCHAR(128)  NOT NULL,
    PasswordSalt        NVARCHAR(64)   NOT NULL,
    RoleID              INT            NOT NULL DEFAULT 2,
    IsActive            BIT            NOT NULL DEFAULT 1,
    FailedLoginAttempts INT            NOT NULL DEFAULT 0,
    LockoutEndUtc       DATETIME       NULL,
    CreatedDate         DATETIME       NOT NULL DEFAULT GETUTCDATE(),
    CONSTRAINT FK_Users_Roles FOREIGN KEY (RoleID) REFERENCES Roles(RoleID)
);
GO

-- ── Categories ──
IF OBJECT_ID('Categories', 'U') IS NULL
CREATE TABLE Categories (
    CategoryID INT IDENTITY(1,1) PRIMARY KEY,
    Name       NVARCHAR(100) NOT NULL UNIQUE
);
GO

-- ── Courses ──
IF OBJECT_ID('Courses', 'U') IS NULL
CREATE TABLE Courses (
    CourseID     INT IDENTITY(1,1) PRIMARY KEY,
    Title        NVARCHAR(200)  NOT NULL,
    Description  NVARCHAR(MAX)  NULL,
    CategoryID   INT            NOT NULL,
    Level        NVARCHAR(50)   NOT NULL DEFAULT 'Beginner',
    ThumbnailUrl NVARCHAR(500)  NULL,
    IsPublished  BIT            NOT NULL DEFAULT 0,
    CreatedBy    INT            NULL,
    CreatedDate  DATETIME       NOT NULL DEFAULT GETUTCDATE(),
    CONSTRAINT FK_Courses_Categories FOREIGN KEY (CategoryID) REFERENCES Categories(CategoryID),
    CONSTRAINT FK_Courses_Users      FOREIGN KEY (CreatedBy)  REFERENCES Users(UserID)
);
GO

-- ── Lessons ──
IF OBJECT_ID('Lessons', 'U') IS NULL
CREATE TABLE Lessons (
    LessonID  INT IDENTITY(1,1) PRIMARY KEY,
    CourseID  INT            NOT NULL,
    Title     NVARCHAR(200)  NOT NULL,
    Content   NVARCHAR(MAX)  NULL,
    VideoUrl  NVARCHAR(500)  NULL,
    SortOrder INT            NOT NULL DEFAULT 0,
    CONSTRAINT FK_Lessons_Courses FOREIGN KEY (CourseID) REFERENCES Courses(CourseID) ON DELETE CASCADE
);
GO

-- ── Enrollments ──
IF OBJECT_ID('Enrollments', 'U') IS NULL
CREATE TABLE Enrollments (
    EnrollmentID   INT IDENTITY(1,1) PRIMARY KEY,
    UserID         INT      NOT NULL,
    CourseID       INT      NOT NULL,
    ProgressPercent INT     NOT NULL DEFAULT 0,
    EnrolledDate   DATETIME NOT NULL DEFAULT GETUTCDATE(),
    CONSTRAINT FK_Enrollments_Users   FOREIGN KEY (UserID)   REFERENCES Users(UserID),
    CONSTRAINT FK_Enrollments_Courses FOREIGN KEY (CourseID) REFERENCES Courses(CourseID),
    CONSTRAINT UQ_Enrollments UNIQUE (UserID, CourseID)
);
GO

-- ── LessonProgress ──
IF OBJECT_ID('LessonProgress', 'U') IS NULL
CREATE TABLE LessonProgress (
    ProgressID   INT IDENTITY(1,1) PRIMARY KEY,
    EnrollmentID INT      NOT NULL,
    LessonID     INT      NOT NULL,
    IsCompleted  BIT      NOT NULL DEFAULT 0,
    CompletedDate DATETIME NULL,
    CONSTRAINT FK_LP_Enrollments FOREIGN KEY (EnrollmentID) REFERENCES Enrollments(EnrollmentID),
    CONSTRAINT FK_LP_Lessons     FOREIGN KEY (LessonID)     REFERENCES Lessons(LessonID) ON DELETE CASCADE,
    CONSTRAINT UQ_LessonProgress UNIQUE (EnrollmentID, LessonID)
);
GO

-- ── Quizzes ──
IF OBJECT_ID('Quizzes', 'U') IS NULL
CREATE TABLE Quizzes (
    QuizID   INT IDENTITY(1,1) PRIMARY KEY,
    CourseID INT            NOT NULL,
    Title    NVARCHAR(200)  NOT NULL,
    CONSTRAINT FK_Quizzes_Courses FOREIGN KEY (CourseID) REFERENCES Courses(CourseID) ON DELETE CASCADE
);
GO

-- ── Questions ──
IF OBJECT_ID('Questions', 'U') IS NULL
CREATE TABLE Questions (
    QuestionID   INT IDENTITY(1,1) PRIMARY KEY,
    QuizID       INT            NOT NULL,
    QuestionText NVARCHAR(MAX)  NOT NULL,
    SortOrder    INT            NOT NULL DEFAULT 0,
    CONSTRAINT FK_Questions_Quizzes FOREIGN KEY (QuizID) REFERENCES Quizzes(QuizID) ON DELETE CASCADE
);
GO

-- ── QuestionOptions ──
IF OBJECT_ID('QuestionOptions', 'U') IS NULL
CREATE TABLE QuestionOptions (
    OptionID   INT IDENTITY(1,1) PRIMARY KEY,
    QuestionID INT            NOT NULL,
    OptionText NVARCHAR(500)  NOT NULL,
    IsCorrect  BIT            NOT NULL DEFAULT 0,
    CONSTRAINT FK_Options_Questions FOREIGN KEY (QuestionID) REFERENCES Questions(QuestionID) ON DELETE CASCADE
);
GO

-- ── QuizAttempts ──
IF OBJECT_ID('QuizAttempts', 'U') IS NULL
CREATE TABLE QuizAttempts (
    AttemptID   INT IDENTITY(1,1) PRIMARY KEY,
    UserID      INT      NOT NULL,
    QuizID      INT      NOT NULL,
    Score       INT      NOT NULL DEFAULT 0,
    MaxScore    INT      NOT NULL DEFAULT 0,
    AttemptDate DATETIME NOT NULL DEFAULT GETUTCDATE(),
    CONSTRAINT FK_Attempts_Users  FOREIGN KEY (UserID) REFERENCES Users(UserID),
    CONSTRAINT FK_Attempts_Quizzes FOREIGN KEY (QuizID) REFERENCES Quizzes(QuizID)
);
GO

-- ── Feedback ──
IF OBJECT_ID('Feedback', 'U') IS NULL
CREATE TABLE Feedback (
    FeedbackID    INT IDENTITY(1,1) PRIMARY KEY,
    UserID        INT           NULL,
    Name          NVARCHAR(200) NOT NULL,
    Email         NVARCHAR(256) NOT NULL,
    Subject       NVARCHAR(200) NULL,
    Message       NVARCHAR(MAX) NOT NULL,
    SubmittedDate DATETIME      NOT NULL DEFAULT GETUTCDATE(),
    CONSTRAINT FK_Feedback_Users FOREIGN KEY (UserID) REFERENCES Users(UserID)
);
GO

-- =====================================================
-- Seed Data
-- =====================================================

-- Roles
IF NOT EXISTS (SELECT 1 FROM Roles WHERE RoleName = 'Admin')
    INSERT INTO Roles (RoleName) VALUES ('Admin');
IF NOT EXISTS (SELECT 1 FROM Roles WHERE RoleName = 'Member')
    INSERT INTO Roles (RoleName) VALUES ('Member');
GO

-- Categories
IF NOT EXISTS (SELECT 1 FROM Categories)
BEGIN
    INSERT INTO Categories (Name) VALUES
        ('European Languages'),
        ('Asian Languages'),
        ('Middle Eastern Languages'),
        ('African Languages'),
        ('Sign Languages');
END
GO

-- Sample published courses (CreatedBy is NULL since no admin user exists yet)
IF NOT EXISTS (SELECT 1 FROM Courses)
BEGIN
    INSERT INTO Courses (Title, Description, CategoryID, Level, IsPublished) VALUES
        ('Spanish for Beginners',       'Start your journey into Spanish with essential vocabulary, pronunciation, and everyday phrases. Perfect for absolute beginners.', 1, 'Beginner', 1),
        ('French Immersion',            'Dive deep into French with real conversation practice, grammar drills, and cultural context. Designed for learners with some basics.', 1, 'Intermediate', 1),
        ('German: Start to Fluent',     'A comprehensive path from zero German to confident conversation. Covers grammar, vocabulary, listening, and writing.', 1, 'All Levels', 1),
        ('Japanese: Zero to N3',        'Learn Japanese reading (hiragana, katakana, basic kanji), grammar patterns, and speaking practice aimed at JLPT N3.', 2, 'All Levels', 1),
        ('Mandarin Chinese Essentials', 'Master tones, pinyin, and essential Mandarin vocabulary. Includes stroke-order practice for the 200 most common characters.', 2, 'Beginner', 1),
        ('Korean for K-Culture Fans',   'Learn Korean through K-dramas, K-pop lyrics, and everyday scenarios. Fun and engaging with cultural deep-dives.', 2, 'Beginner', 1),
        ('Italian: La Dolce Lingua',    'Experience Italian through food, travel, and art. Practical phrases and grammar for your next trip to Italy.', 1, 'Beginner', 1),
        ('Portuguese: Brazil Edition',  'Brazilian Portuguese with a focus on everyday conversation, slang, and pronunciation unique to Brazil.', 1, 'Intermediate', 1),
        ('Arabic Script & Basics',      'Learn to read and write Arabic script, plus essential greetings, numbers, and basic grammar.', 3, 'Beginner', 1);
END
GO

-- Sample lessons for "Spanish for Beginners" (CourseID = 1)
IF NOT EXISTS (SELECT 1 FROM Lessons)
BEGIN
    INSERT INTO Lessons (CourseID, Title, Content, SortOrder) VALUES
        (1, 'Greetings & Introductions',    'Learn how to say hello, goodbye, and introduce yourself in Spanish. Covers: Hola, Buenos días, ¿Cómo te llamas?, Me llamo...', 1),
        (1, 'Numbers 1-100',                'Master counting in Spanish from uno to cien. Practice with listening exercises and flashcards.', 2),
        (1, 'Common Verbs: Ser & Estar',    'Understand the two forms of "to be" in Spanish. When to use ser vs. estar with clear examples.', 3),
        (1, 'At the Restaurant',            'Order food and drinks confidently. Vocabulary for menus, asking for the bill, and dietary requests.', 4),
        (1, 'Directions & Transportation',  'Navigate cities in Spanish. Ask for and give directions, buy tickets, and use public transport.', 5),
        (2, 'Les Salutations',              'French greetings for formal and informal situations. Bonjour, Bonsoir, Comment allez-vous?', 1),
        (2, 'Le Passé Composé',             'Master the most important past tense in French. Formation with avoir and être, plus irregular participles.', 2),
        (2, 'Au Marché',                    'Shopping at a French market. Quantities, prices, and polite requests.', 3),
        (4, 'Hiragana: あ to ん',            'Learn all 46 hiragana characters with stroke order, pronunciation, and memory tricks.', 1),
        (4, 'Katakana: ア to ン',            'Master all 46 katakana characters used for foreign words, sounds, and emphasis.', 2),
        (4, 'Self-Introduction: 自己紹介',   'Introduce yourself in Japanese. Name, nationality, occupation, and hobbies.', 3);
END
GO

-- Sample quiz for "Spanish for Beginners"
IF NOT EXISTS (SELECT 1 FROM Quizzes)
BEGIN
    INSERT INTO Quizzes (CourseID, Title) VALUES
        (1, 'Spanish Basics Quiz');

    DECLARE @QuizID INT = SCOPE_IDENTITY();

    INSERT INTO Questions (QuizID, QuestionText, SortOrder) VALUES
        (@QuizID, 'How do you say "Good morning" in Spanish?', 1),
        (@QuizID, 'What does "Me llamo" mean?', 2),
        (@QuizID, 'Which verb means "to be" (permanent state)?', 3);

    -- Q1 options
    DECLARE @Q1 INT = (SELECT TOP 1 QuestionID FROM Questions WHERE QuestionText LIKE '%Good morning%');
    INSERT INTO QuestionOptions (QuestionID, OptionText, IsCorrect) VALUES
        (@Q1, 'Buenos días', 1),
        (@Q1, 'Buenas noches', 0),
        (@Q1, 'Buenas tardes', 0),
        (@Q1, 'Hola', 0);

    -- Q2 options
    DECLARE @Q2 INT = (SELECT TOP 1 QuestionID FROM Questions WHERE QuestionText LIKE '%Me llamo%');
    INSERT INTO QuestionOptions (QuestionID, OptionText, IsCorrect) VALUES
        (@Q2, 'My name is', 1),
        (@Q2, 'I like', 0),
        (@Q2, 'I want', 0),
        (@Q2, 'I have', 0);

    -- Q3 options
    DECLARE @Q3 INT = (SELECT TOP 1 QuestionID FROM Questions WHERE QuestionText LIKE '%permanent state%');
    INSERT INTO QuestionOptions (QuestionID, OptionText, IsCorrect) VALUES
        (@Q3, 'Ser', 1),
        (@Q3, 'Estar', 0),
        (@Q3, 'Tener', 0),
        (@Q3, 'Haber', 0);
END
GO

PRINT 'Database setup complete. Tables created and seed data inserted.';
GO
