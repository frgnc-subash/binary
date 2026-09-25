
-- Create the database if it doesn't exist
IF DB_ID('BinaryDB') IS NULL
    CREATE DATABASE BinaryDB;
GO

USE BinaryDB;
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
    NativeLanguage      NVARCHAR(50)   NULL,   -- onboarding: the language the learner already speaks
    LearningReason      NVARCHAR(50)   NULL,   -- onboarding: why they're learning
    CONSTRAINT FK_Users_Roles FOREIGN KEY (RoleID) REFERENCES Roles(RoleID)
);
GO

-- Safety net for databases created before ProfileImageUrl existed
IF COL_LENGTH('Users', 'ProfileImageUrl') IS NULL
    ALTER TABLE Users ADD ProfileImageUrl NVARCHAR(500) NULL;
GO

IF COL_LENGTH('Users', 'NativeLanguage') IS NULL
    ALTER TABLE Users ADD NativeLanguage NVARCHAR(50) NULL;
GO

IF COL_LENGTH('Users', 'LearningReason') IS NULL
    ALTER TABLE Users ADD LearningReason NVARCHAR(50) NULL;
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
    FlagImageUrl NVARCHAR(300)  NULL,   -- e.g. ~/Content/images/flags/spain.png
    IsPublished  BIT            NOT NULL DEFAULT 0,
    CreatedBy    INT            NULL,
    CreatedDate  DATETIME       NOT NULL DEFAULT GETUTCDATE(),
    CONSTRAINT FK_Courses_Categories FOREIGN KEY (CategoryID) REFERENCES Categories(CategoryID),
    CONSTRAINT FK_Courses_Users      FOREIGN KEY (CreatedBy)  REFERENCES Users(UserID)
);
GO

-- Safety net for databases created before FlagImageUrl existed
IF COL_LENGTH('Courses', 'FlagImageUrl') IS NULL
    ALTER TABLE Courses ADD FlagImageUrl NVARCHAR(300) NULL;
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

-- Flags for the seeded courses (files in Content/images/flags). Only fills empty values,
-- so a flag an admin picks later is never overwritten by re-running this script.
UPDATE Courses SET FlagImageUrl = '~/Content/images/flags/spain.png'       WHERE FlagImageUrl IS NULL AND Title LIKE 'Spanish%';
UPDATE Courses SET FlagImageUrl = '~/Content/images/flags/france.png'      WHERE FlagImageUrl IS NULL AND Title LIKE 'French%';
UPDATE Courses SET FlagImageUrl = '~/Content/images/flags/germany.png'     WHERE FlagImageUrl IS NULL AND Title LIKE 'German%';
UPDATE Courses SET FlagImageUrl = '~/Content/images/flags/japan.png'       WHERE FlagImageUrl IS NULL AND Title LIKE 'Japanese%';
UPDATE Courses SET FlagImageUrl = '~/Content/images/flags/china.png'       WHERE FlagImageUrl IS NULL AND Title LIKE 'Mandarin%';
UPDATE Courses SET FlagImageUrl = '~/Content/images/flags/south-korea.png' WHERE FlagImageUrl IS NULL AND Title LIKE 'Korean%';
UPDATE Courses SET FlagImageUrl = '~/Content/images/flags/italy.png'       WHERE FlagImageUrl IS NULL AND Title LIKE 'Italian%';
UPDATE Courses SET FlagImageUrl = '~/Content/images/flags/portugal.png'    WHERE FlagImageUrl IS NULL AND Title LIKE 'Portuguese%';
UPDATE Courses SET FlagImageUrl = '~/Content/images/flags/arab-league.png' WHERE FlagImageUrl IS NULL AND Title LIKE 'Arabic%';
GO

-- Sample lessons for all courses
IF NOT EXISTS (SELECT 1 FROM Lessons)
BEGIN
    -- Spanish
    INSERT INTO Lessons (CourseID, Title, Content, SortOrder) VALUES
        (1, 'Greetings & Introductions',    N'Learn how to say hello, goodbye, and introduce yourself in Spanish. Covers: ¡Hola!, Buenos días, ¿Cómo te llamas?, Me llamo...', 1),
        (1, 'Numbers 1-100',                'Master counting in Spanish from uno to cien. Practice: Uno, Dos, Tres, Cuatro, Cinco, Diez, Veinte...', 2),
        (1, 'Common Verbs: Ser & Estar',    'Understand the two forms of "to be" in Spanish. SER for permanent traits, ESTAR for temporary states/locations.', 3),
        (1, 'At the Restaurant',            N'Order food and drinks confidently: La cuenta, por favor, ¿Qué recomienda?, Quisiera una paella.', 4),
        (1, 'Directions & Transportation',  N'Navigate cities in Spanish: ¿Dónde está la estación?, Todo recto, A la izquierda, A la derecha.', 5);

    -- French
    INSERT INTO Lessons (CourseID, Title, Content, SortOrder) VALUES
        (2, 'Les Salutations & Politesse',  N'Learn polite French greetings: Bonjour, Bonsoir, Comment allez-vous?, Ça va?, S''il vous plaît, Merci beaucoup.', 1),
        (2, N'Le Passé Composé',             N'Master the past tense with avoir and être: J''ai mangé, Je suis allé à Paris.', 2),
        (2, N'Au Café & Boulangerie',        N'Ordering food in Paris: Un café noir, s''il vous plaît, Un croissant au beurre, C''est combien?', 3),
        (2, N'Se Déplacer dans la Ville',    N'Navigating the city: Où est le métro?, Tout droit, À gauche, À droite.', 4);

    -- German
    INSERT INTO Lessons (CourseID, Title, Content, SortOrder) VALUES
        (3, N'Begrüßung & Kennenlernen',     N'German greetings: Hallo!, Guten Tag!, Wie heißen Sie?, Ich heiße Lukas, Freut mich!', 1),
        (3, 'Articles: Der, Die, Das',      'Noun genders in German: Der Mann (masculine), Die Frau (feminine), Das Auto (neuter).', 2),
        (3, 'Im Restaurant & Bestellen',    N'Ordering food: Die Speisekarte bitte, Ich hätte gerne ein Wasser, Zusammen oder getrennt?', 3);

    -- Japanese
    INSERT INTO Lessons (CourseID, Title, Content, SortOrder) VALUES
        (4, N'Hiragana: あ to ん',            'Learn the foundational phonetic alphabet with stroke order and pronunciation.', 1),
        (4, N'Katakana: ア to ン',            N'Master katakana characters used for foreign loanwords: コーヒー (Coffee), アメリカ (America).', 2),
        (4, N'Self-Introduction: 自己紹介',   N'Introduce yourself: 初めまして (Nice to meet you), 私は...です (I am...), よろしくお願いします。', 3);

    -- Chinese
    INSERT INTO Lessons (CourseID, Title, Content, SortOrder) VALUES
        (5, 'The Four Tones & Pinyin',      'Master the 4 tones in Mandarin: 1st (high flat), 2nd (rising), 3rd (dipping), 4th (falling).', 1),
        (5, N'Essential Greetings: 你好',     N'Conversational Chinese: 你好 (Nǐ hǎo), 谢谢 (Xièxie), 不客气 (Bú kèqì), 再见 (Zàijiàn).', 2),
        (5, 'Numbers & Shopping',           N'Count 1-10 (一, 二, 三...) and ask prices: 这个多少钱？ (Zhège duōshǎo qián?).', 3);

    -- Korean
    INSERT INTO Lessons (CourseID, Title, Content, SortOrder) VALUES
        (6, 'Hangul Masterclass',           N'Consonants (ㄱ, ㄴ, ㄷ) and vowels (ㅏ, ㅓ, ㅗ) combined into syllabic blocks: 한 (h-a-n) 글 (g-eu-l).', 1),
        (6, 'K-Drama Expressions',          N'Everyday phrases: 안녕하세요 (Hello), 감사합니다 (Thank you), 대박! (Daebak!), 화이팅! (Fighting!).', 2),
        (6, 'Ordering Korean Food',         N'K-Food phrases: 삼겹살 2인분 주세요 (2 servings of pork belly, please), 물 좀 주세요 (Water please).', 3);

    -- Italian
    INSERT INTO Lessons (CourseID, Title, Content, SortOrder) VALUES
        (7, 'Saluti & Cortesia',            'Italian basics: Ciao!, Buongiorno, Per favore, Grazie mille.', 1),
        (7, N'Al Ristorante & Caffè',        'Order like a local: Un espresso per favore, Una pizza margherita, Il conto per favore.', 2);

    -- Portuguese
    INSERT INTO Lessons (CourseID, Title, Content, SortOrder) VALUES
        (8, 'Tudo Bem? Greetings',          'Brazilian greetings: Oi! Tudo bem?, Tudo bom!, Por favor, Obrigado/Obrigada.', 1),
        (8, 'Na Praia & Na Cidade',         N'City & beach phrases: Onde fica a praia?, Uma água de coco por favor.', 2);

    -- Arabic
    INSERT INTO Lessons (CourseID, Title, Content, SortOrder) VALUES
        (9, 'The Arabic Alphabet',          N'Right-to-left script: Alif (أ), Baa (ب), Taa (ت), Thaa (ث).', 1),
        (9, 'Essential Greetings',          N'Greetings: السلام عليكم (As-salamu alaykum), شكراً (Shukran).', 2);
END
GO

-- Practice quizzes for every seeded course (5 questions, 4 options each).
-- Safe to re-run: courses are matched by title and only missing quizzes, questions
-- and options are added, so existing attempts and admin edits are left alone.
DECLARE @QuizSeed TABLE (
    CourseTitle  NVARCHAR(200),
    QuizTitle    NVARCHAR(200),
    SortOrder    INT,
    QuestionText NVARCHAR(500),
    OptionA      NVARCHAR(200),
    OptionB      NVARCHAR(200),
    OptionC      NVARCHAR(200),
    OptionD      NVARCHAR(200),
    Correct      CHAR(1)
);

INSERT INTO @QuizSeed VALUES
        (N'Spanish for Beginners', N'Spanish Basics Quiz', 1, N'How do you say "Good morning" in Spanish?',
            N'Buenas noches', N'Buenos días', N'Buenas tardes', N'Hola', 'B'),
        (N'Spanish for Beginners', N'Spanish Basics Quiz', 2, N'What does "Me llamo" mean?',
            N'My name is', N'I like', N'I want', N'I have', 'A'),
        (N'Spanish for Beginners', N'Spanish Basics Quiz', 3, N'Which verb means "to be" (permanent state)?',
            N'Estar', N'Tener', N'Ser', N'Haber', 'C'),
        (N'Spanish for Beginners', N'Spanish Basics Quiz', 4, N'How do you ask for the bill in a restaurant?',
            N'Mucho gusto', N'¿Dónde está la estación?', N'¿Qué recomienda?', N'La cuenta, por favor', 'D'),
        (N'Spanish for Beginners', N'Spanish Basics Quiz', 5, N'What does "A la izquierda" mean?',
            N'To the right', N'To the left', N'Straight ahead', N'Next to', 'B'),
        (N'French Immersion', N'French Immersion Quiz', 1, N'Which greeting is used in the evening?',
            N'Bonjour', N'Bonsoir', N'Salut', N'Merci', 'B'),
        (N'French Immersion', N'French Immersion Quiz', 2, N'What does "S''il vous plaît" mean?',
            N'Thank you', N'Excuse me', N'Please', N'You''re welcome', 'C'),
        (N'French Immersion', N'French Immersion Quiz', 3, N'"Je suis allé à Paris" uses which helper verb?',
            N'Être', N'Avoir', N'Aller', N'Faire', 'A'),
        (N'French Immersion', N'French Immersion Quiz', 4, N'How do you ask "How much is it?"',
            N'Où est le métro ?', N'Ça va ?', N'Tout droit', N'C''est combien ?', 'D'),
        (N'French Immersion', N'French Immersion Quiz', 5, N'What does "À droite" mean?',
            N'To the left', N'Straight ahead', N'To the right', N'Behind', 'C'),
        (N'German: Start to Fluent', N'German Basics Quiz', 1, N'How do you say "My name is Lukas"?',
            N'Ich heiße Lukas', N'Wie heißen Sie?', N'Freut mich', N'Guten Tag, Lukas', 'A'),
        (N'German: Start to Fluent', N'German Basics Quiz', 2, N'Which article goes with "Frau" (woman)?',
            N'Der', N'Die', N'Das', N'Den', 'B'),
        (N'German: Start to Fluent', N'German Basics Quiz', 3, N'Which article goes with "Auto" (car)?',
            N'Der', N'Die', N'Dem', N'Das', 'D'),
        (N'German: Start to Fluent', N'German Basics Quiz', 4, N'What does "Freut mich!" mean?',
            N'Good night!', N'See you later!', N'Nice to meet you!', N'Thank you!', 'C'),
        (N'German: Start to Fluent', N'German Basics Quiz', 5, N'"Zusammen oder getrennt?" asks whether you want to...',
            N'order now or later', N'pay together or separately', N'sit inside or outside', N'have water or juice', 'B'),
        (N'Japanese: Zero to N3', N'Japanese Basics Quiz', 1, N'Which script is mainly used for foreign loanwords?',
            N'Hiragana', N'Kanji', N'Katakana', N'Romaji', 'C'),
        (N'Japanese: Zero to N3', N'Japanese Basics Quiz', 2, N'What does 初めまして (hajimemashite) mean?',
            N'Nice to meet you', N'Good morning', N'Goodbye', N'Thank you', 'A'),
        (N'Japanese: Zero to N3', N'Japanese Basics Quiz', 3, N'How is コーヒー read?',
            N'kēki (cake)', N'kōhī (coffee)', N'kōra (cola)', N'hoteru (hotel)', 'B'),
        (N'Japanese: Zero to N3', N'Japanese Basics Quiz', 4, N'In 私は...です, what does 私 (watashi) mean?',
            N'You', N'We', N'He', N'I', 'D'),
        (N'Japanese: Zero to N3', N'Japanese Basics Quiz', 5, N'Which character is the hiragana "a"?',
            N'ア', N'い', N'あ', N'ん', 'C'),
        (N'Mandarin Chinese Essentials', N'Mandarin Basics Quiz', 1, N'How many main tones does Mandarin have?',
            N'Two', N'Four', N'Three', N'Six', 'B'),
        (N'Mandarin Chinese Essentials', N'Mandarin Basics Quiz', 2, N'What does 谢谢 (xièxie) mean?',
            N'Thank you', N'Hello', N'Goodbye', N'Sorry', 'A'),
        (N'Mandarin Chinese Essentials', N'Mandarin Basics Quiz', 3, N'Which tone falls sharply from high to low?',
            N'1st tone', N'2nd tone', N'3rd tone', N'4th tone', 'D'),
        (N'Mandarin Chinese Essentials', N'Mandarin Basics Quiz', 4, N'What does 再见 (zàijiàn) mean?',
            N'You''re welcome', N'Excuse me', N'Goodbye', N'Good morning', 'C'),
        (N'Mandarin Chinese Essentials', N'Mandarin Basics Quiz', 5, N'How do you ask "How much is this?"',
            N'你好', N'这个多少钱？', N'不客气', N'谢谢', 'B'),
        (N'Korean for K-Culture Fans', N'Korean Basics Quiz', 1, N'What is the Korean alphabet called?',
            N'Hangul', N'Kanji', N'Hiragana', N'Pinyin', 'A'),
        (N'Korean for K-Culture Fans', N'Korean Basics Quiz', 2, N'What does 감사합니다 mean?',
            N'Hello', N'Goodbye', N'Please', N'Thank you', 'D'),
        (N'Korean for K-Culture Fans', N'Korean Basics Quiz', 3, N'Which of these is a vowel?',
            N'ㄱ', N'ㅏ', N'ㄴ', N'ㄷ', 'B'),
        (N'Korean for K-Culture Fans', N'Korean Basics Quiz', 4, N'How do you ask for some water?',
            N'안녕하세요', N'대박!', N'물 좀 주세요', N'화이팅!', 'C'),
        (N'Korean for K-Culture Fans', N'Korean Basics Quiz', 5, N'What does 안녕하세요 mean?',
            N'Thank you', N'Cheers', N'Delicious', N'Hello', 'D'),
        (N'Italian: La Dolce Lingua', N'Italian Basics Quiz', 1, N'What does "Grazie mille" mean?',
            N'Good morning', N'Thanks a lot', N'Excuse me', N'See you soon', 'B'),
        (N'Italian: La Dolce Lingua', N'Italian Basics Quiz', 2, N'How do you ask for the bill?',
            N'Il conto, per favore', N'Un espresso, per favore', N'Buongiorno', N'Ciao', 'A'),
        (N'Italian: La Dolce Lingua', N'Italian Basics Quiz', 3, N'Which one means "Good morning"?',
            N'Ciao', N'Arrivederci', N'Grazie', N'Buongiorno', 'D'),
        (N'Italian: La Dolce Lingua', N'Italian Basics Quiz', 4, N'What does "Per favore" mean?',
            N'Thank you', N'Please', N'Sorry', N'You''re welcome', 'B'),
        (N'Italian: La Dolce Lingua', N'Italian Basics Quiz', 5, N'Where would you say "Una pizza margherita, per favore"?',
            N'At the airport', N'At the doctor', N'At a restaurant', N'At the train station', 'C'),
        (N'Portuguese: Brazil Edition', N'Portuguese Basics Quiz', 1, N'What does "Tudo bem?" mean?',
            N'Where is it?', N'How are you?', N'How much is it?', N'Good night', 'B'),
        (N'Portuguese: Brazil Edition', N'Portuguese Basics Quiz', 2, N'How does a man say "thank you"?',
            N'Obrigado', N'Obrigada', N'Por favor', N'Oi', 'A'),
        (N'Portuguese: Brazil Edition', N'Portuguese Basics Quiz', 3, N'What does "Onde fica a praia?" ask?',
            N'Is the beach open?', N'How far is the city?', N'Do you like the beach?', N'Where is the beach?', 'D'),
        (N'Portuguese: Brazil Edition', N'Portuguese Basics Quiz', 4, N'"Uma água de coco, por favor" is asking for...',
            N'a cold juice', N'a coffee', N'a coconut water', N'a bottle of water', 'C'),
        (N'Portuguese: Brazil Edition', N'Portuguese Basics Quiz', 5, N'Which one is an informal "Hi"?',
            N'Tchau', N'Bom dia', N'Obrigado', N'Oi', 'D'),
        (N'Arabic Script & Basics', N'Arabic Basics Quiz', 1, N'Which direction is Arabic written?',
            N'Left to right', N'Right to left', N'Top to bottom', N'Either way', 'B'),
        (N'Arabic Script & Basics', N'Arabic Basics Quiz', 2, N'What does شكراً (shukran) mean?',
            N'Hello', N'Please', N'Thank you', N'Goodbye', 'C'),
        (N'Arabic Script & Basics', N'Arabic Basics Quiz', 3, N'Which letter is Baa?',
            N'أ', N'ت', N'ث', N'ب', 'D'),
        (N'Arabic Script & Basics', N'Arabic Basics Quiz', 4, N'When do you say السلام عليكم (as-salamu alaykum)?',
            N'When greeting someone', N'When saying sorry', N'When asking a price', N'When saying thank you', 'A'),
        (N'Arabic Script & Basics', N'Arabic Basics Quiz', 5, N'Which letter is Alif?',
            N'ب', N'أ', N'ت', N'ث', 'B');

INSERT INTO Quizzes (CourseID, Title)
SELECT DISTINCT c.CourseID, s.QuizTitle
FROM @QuizSeed s
INNER JOIN Courses c ON c.Title = s.CourseTitle
WHERE NOT EXISTS (SELECT 1 FROM Quizzes q WHERE q.CourseID = c.CourseID);

INSERT INTO Questions (QuizID, QuestionText, SortOrder)
SELECT q.QuizID, s.QuestionText, s.SortOrder
FROM @QuizSeed s
INNER JOIN Courses c ON c.Title = s.CourseTitle
INNER JOIN Quizzes q ON q.CourseID = c.CourseID AND q.Title = s.QuizTitle
WHERE NOT EXISTS (SELECT 1 FROM Questions x WHERE x.QuizID = q.QuizID AND x.QuestionText = s.QuestionText)
ORDER BY q.QuizID, s.SortOrder;

INSERT INTO QuestionOptions (QuestionID, OptionText, IsCorrect)
SELECT x.QuestionID, o.OptionText, CASE WHEN o.Letter = s.Correct THEN 1 ELSE 0 END
FROM @QuizSeed s
INNER JOIN Courses c ON c.Title = s.CourseTitle
INNER JOIN Quizzes q ON q.CourseID = c.CourseID AND q.Title = s.QuizTitle
INNER JOIN Questions x ON x.QuizID = q.QuizID AND x.QuestionText = s.QuestionText
CROSS APPLY (VALUES ('A', s.OptionA), ('B', s.OptionB), ('C', s.OptionC), ('D', s.OptionD)) o (Letter, OptionText)
WHERE NOT EXISTS (SELECT 1 FROM QuestionOptions y WHERE y.QuestionID = x.QuestionID)
ORDER BY x.QuestionID, o.Letter;
GO

PRINT 'Database setup complete. Tables created and seed data inserted.';
GO