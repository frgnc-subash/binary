
-- Create the database if it doesn't exist
IF DB_ID('BinaryKoData') IS NULL
    CREATE DATABASE BinaryKoData;
GO

USE BinaryKoData;
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
    TotalXP             INT            NOT NULL DEFAULT 0,  -- Moved here to avoid ALTER TABLE issues
    ProfileImageUrl     NVARCHAR(500)  NULL,
    CONSTRAINT FK_Users_Roles FOREIGN KEY (RoleID) REFERENCES Roles(RoleID)
);
GO

-- Safety net for databases created before ProfileImageUrl existed
IF COL_LENGTH('Users', 'ProfileImageUrl') IS NULL
    ALTER TABLE Users ADD ProfileImageUrl NVARCHAR(500) NULL;
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

-- ── Notifications ──
-- Type drives the icon/colour in the notification drawer: info | success | xp | warning | admin | award
-- Users can read and archive notifications but never delete them (no DELETE path exists in the app);
-- rows only go away if the owning user account itself is deleted.
IF OBJECT_ID('Notifications', 'U') IS NULL
CREATE TABLE Notifications (
    NotificationID INT IDENTITY(1,1) PRIMARY KEY,
    UserID         INT           NOT NULL,
    Title          NVARCHAR(150) NOT NULL,
    Message        NVARCHAR(500) NOT NULL,
    Type           NVARCHAR(20)  NOT NULL DEFAULT 'info',
    LinkUrl        NVARCHAR(300) NULL,
    IsRead         BIT           NOT NULL DEFAULT 0,
    IsArchived     BIT           NOT NULL DEFAULT 0,
    CreatedDate    DATETIME      NOT NULL DEFAULT GETUTCDATE(),
    CONSTRAINT FK_Notifications_Users FOREIGN KEY (UserID) REFERENCES Users(UserID) ON DELETE CASCADE
);
GO

-- Safety net for databases created before IsArchived existed
IF COL_LENGTH('Notifications', 'IsArchived') IS NULL
    ALTER TABLE Notifications ADD IsArchived BIT NOT NULL CONSTRAINT DF_Notifications_IsArchived DEFAULT 0;
GO

IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE name = 'IX_Notifications_User_Created')
    CREATE INDEX IX_Notifications_User_Created ON Notifications (UserID, CreatedDate DESC) INCLUDE (IsRead);
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

-- Default Admin User (Credentials: admin@binary.com / AdminPassword123!)
IF NOT EXISTS (SELECT 1 FROM Users WHERE Email = 'admin@binary.com')
BEGIN
    INSERT INTO Users (FirstName, LastName, Email, PasswordHash, PasswordSalt, RoleID, IsActive, FailedLoginAttempts, LockoutEndUtc, CreatedDate, TotalXP)
    VALUES (
        'Admin',
        'User',
        'admin@binary.com',
        '31762b459973ebed71b27fc48617c29ec02e30cff20927711b54f571eb4d32be',
        'd3b07384d113edec49eaa6238ad5ff00',
        1, -- Admin Role (RoleID = 1)
        1, -- IsActive = true
        0,
        NULL,
        GETUTCDATE(),
        0
    );
END
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

-- Sample lessons for all courses
IF NOT EXISTS (SELECT 1 FROM Lessons)
BEGIN
    -- Spanish
    INSERT INTO Lessons (CourseID, Title, Content, SortOrder) VALUES
        (1, 'Greetings & Introductions',    'Learn how to say hello, goodbye, and introduce yourself in Spanish. Covers: ¡Hola!, Buenos días, ¿Cómo te llamas?, Me llamo...', 1),
        (1, 'Numbers 1-100',                'Master counting in Spanish from uno to cien. Practice: Uno, Dos, Tres, Cuatro, Cinco, Diez, Veinte...', 2),
        (1, 'Common Verbs: Ser & Estar',    'Understand the two forms of "to be" in Spanish. SER for permanent traits, ESTAR for temporary states/locations.', 3),
        (1, 'At the Restaurant',            'Order food and drinks confidently: La cuenta, por favor, ¿Qué recomienda?, Quisiera una paella.', 4),
        (1, 'Directions & Transportation',  'Navigate cities in Spanish: ¿Dónde está la estación?, Todo recto, A la izquierda, A la derecha.', 5);

    -- French
    INSERT INTO Lessons (CourseID, Title, Content, SortOrder) VALUES
        (2, 'Les Salutations & Politesse',  'Learn polite French greetings: Bonjour, Bonsoir, Comment allez-vous?, Ça va?, S''il vous plaît, Merci beaucoup.', 1),
        (2, 'Le Passé Composé',             'Master the past tense with avoir and être: J''ai mangé, Je suis allé à Paris.', 2),
        (2, 'Au Café & Boulangerie',        'Ordering food in Paris: Un café noir, s''il vous plaît, Un croissant au beurre, C''est combien?', 3),
        (2, 'Se Déplacer dans la Ville',    'Navigating the city: Où est le métro?, Tout droit, À gauche, À droite.', 4);

    -- German
    INSERT INTO Lessons (CourseID, Title, Content, SortOrder) VALUES
        (3, 'Begrüßung & Kennenlernen',     'German greetings: Hallo!, Guten Tag!, Wie heißen Sie?, Ich heiße Lukas, Freut mich!', 1),
        (3, 'Articles: Der, Die, Das',      'Noun genders in German: Der Mann (masculine), Die Frau (feminine), Das Auto (neuter).', 2),
        (3, 'Im Restaurant & Bestellen',    'Ordering food: Die Speisekarte bitte, Ich hätte gerne ein Wasser, Zusammen oder getrennt?', 3);

    -- Japanese
    INSERT INTO Lessons (CourseID, Title, Content, SortOrder) VALUES
        (4, 'Hiragana: あ to ん',            'Learn the foundational phonetic alphabet with stroke order and pronunciation.', 1),
        (4, 'Katakana: ア to ン',            'Master katakana characters used for foreign loanwords: コーヒー (Coffee), アメリカ (America).', 2),
        (4, 'Self-Introduction: 自己紹介',   'Introduce yourself: 初めまして (Nice to meet you), 私は...です (I am...), よろしくお願いします。', 3);

    -- Chinese
    INSERT INTO Lessons (CourseID, Title, Content, SortOrder) VALUES
        (5, 'The Four Tones & Pinyin',      'Master the 4 tones in Mandarin: 1st (high flat), 2nd (rising), 3rd (dipping), 4th (falling).', 1),
        (5, 'Essential Greetings: 你好',     'Conversational Chinese: 你好 (Nǐ hǎo), 谢谢 (Xièxie), 不客气 (Bú kèqì), 再见 (Zàijiàn).', 2),
        (5, 'Numbers & Shopping',           'Count 1-10 (一, 二, 三...) and ask prices: 这个多少钱？ (Zhège duōshǎo qián?).', 3);

    -- Korean
    INSERT INTO Lessons (CourseID, Title, Content, SortOrder) VALUES
        (6, 'Hangul Masterclass',           'Consonants (ㄱ, ㄴ, ㄷ) and vowels (ㅏ, ㅓ, ㅗ) combined into syllabic blocks: 한 (h-a-n) 글 (g-eu-l).', 1),
        (6, 'K-Drama Expressions',          'Everyday phrases: 안녕하세요 (Hello), 감사합니다 (Thank you), 대박! (Daebak!), 화이팅! (Fighting!).', 2),
        (6, 'Ordering Korean Food',         'K-Food phrases: 삼겹살 2인분 주세요 (2 servings of pork belly, please), 물 좀 주세요 (Water please).', 3);

    -- Italian
    INSERT INTO Lessons (CourseID, Title, Content, SortOrder) VALUES
        (7, 'Saluti & Cortesia',            'Italian basics: Ciao!, Buongiorno, Per favore, Grazie mille.', 1),
        (7, 'Al Ristorante & Caffè',        'Order like a local: Un espresso per favore, Una pizza margherita, Il conto per favore.', 2);

    -- Portuguese
    INSERT INTO Lessons (CourseID, Title, Content, SortOrder) VALUES
        (8, 'Tudo Bem? Greetings',          'Brazilian greetings: Oi! Tudo bem?, Tudo bom!, Por favor, Obrigado/Obrigada.', 1),
        (8, 'Na Praia & Na Cidade',         'City & beach phrases: Onde fica a praia?, Uma água de coco por favor.', 2);

    -- Arabic
    INSERT INTO Lessons (CourseID, Title, Content, SortOrder) VALUES
        (9, 'The Arabic Alphabet',          'Right-to-left script: Alif (أ), Baa (ب), Taa (ت), Thaa (ث).', 1),
        (9, 'Essential Greetings',          'Greetings: السلام عليكم (As-salamu alaykum), شكراً (Shukran).', 2);
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