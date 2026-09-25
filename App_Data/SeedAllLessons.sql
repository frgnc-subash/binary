-- =====================================================
-- Seed Lessons for All Courses in BinaryKoData
-- Run this in SSMS against BinaryKoData
-- =====================================================
USE BinaryKoData;
GO

-- 1. Spanish for Beginners
DECLARE @cSpanish INT = (SELECT TOP 1 CourseID FROM Courses WHERE Title LIKE '%Spanish%');
IF @cSpanish IS NOT NULL AND NOT EXISTS (SELECT 1 FROM Lessons WHERE CourseID = @cSpanish)
BEGIN
    INSERT INTO Lessons (CourseID, Title, Content, SortOrder) VALUES
    (@cSpanish, 'Greetings & Introductions', N'Learn essential Spanish greetings:
- ¡Hola! (Hello!)
- Buenos días (Good morning)
- Buenas tardes (Good afternoon)
- ¿Cómo te llamas? (What is your name?)
- Me llamo... (My name is...)
- Mucho gusto (Nice to meet you)', 1),
    (@cSpanish, 'Numbers 1-100 & Counting', N'Master counting in Spanish:
- 1: Uno, 2: Dos, 3: Tres, 4: Cuatro, 5: Cinco
- 10: Diez, 20: Veinte, 30: Treinta, 50: Cincuenta, 100: Cien
Practice ordering quantities: "Dos cafés, por favor."', 2),
    (@cSpanish, 'Essential Verbs: Ser vs. Estar', 'Understand the two forms of "to be":
- SER is used for permanent characteristics (identity, origin, profession): "Yo soy estudiante."
- ESTAR is used for temporary states and locations: "Yo estoy en Madrid."', 3),
    (@cSpanish, 'Ordering at a Restaurant', N'Navigate a Spanish restaurant:
- La cuenta, por favor (The bill, please)
- ¿Qué recomienda? (What do you recommend?)
- Quisiera una paella (I would like a paella)', 4);
END

-- 2. French Immersion
DECLARE @cFrench INT = (SELECT TOP 1 CourseID FROM Courses WHERE Title LIKE '%French%');
IF @cFrench IS NOT NULL AND NOT EXISTS (SELECT 1 FROM Lessons WHERE CourseID = @cFrench)
BEGIN
    INSERT INTO Lessons (CourseID, Title, Content, SortOrder) VALUES
    (@cFrench, 'Les Salutations & Politesse', N'Learn polite French expressions:
- Bonjour (Hello / Good morning)
- Bonsoir (Good evening)
- Comment allez-vous ? (How are you? formal)
- Ça va ? (How''s it going? informal)
- S''il vous plaît (Please)
- Merci beaucoup (Thank you very much)', 1),
    (@cFrench, N'Le Passé Composé', N'Master past actions in French:
- Formed with auxiliary (avoir / être) + past participle.
- J''ai parlé avec Marie (I spoke with Marie).
- Je suis allé à Paris (I went to Paris with être for movement verbs).', 2),
    (@cFrench, N'Au Café & À la Boulangerie', N'Ordering food and drinks in Paris:
- Un café noir, s''il vous plaît (A black coffee, please)
- Un croissant au beurre (A butter croissant)
- C''est combien ? (How much is it?)', 3),
    (@cFrench, N'Se Déplacer dans la Ville', N'Navigating the city and public transport:
- Où est la station de métro ? (Where is the subway station?)
- Tout droit (Straight ahead)
- À gauche / À droite (To the left / To the right)', 4);
END

-- 3. German: Start to Fluent
DECLARE @cGerman INT = (SELECT TOP 1 CourseID FROM Courses WHERE Title LIKE '%German%');
IF @cGerman IS NOT NULL AND NOT EXISTS (SELECT 1 FROM Lessons WHERE CourseID = @cGerman)
BEGIN
    INSERT INTO Lessons (CourseID, Title, Content, SortOrder) VALUES
    (@cGerman, N'Begrüßung & Kennenlernen', N'German basics for first conversations:
- Hallo! Guten Tag! (Hello! Good day!)
- Wie heißt du? / Wie heißen Sie? (What is your name?)
- Ich heiße Lukas. (My name is Lukas.)
- Freut mich! (Pleased to meet you!)', 1),
    (@cGerman, 'Articles & Genders: Der, Die, Das', 'Master German noun genders:
- Masculine: Der Mann, Der Tisch
- Feminine: Die Frau, Die Lampe
- Neuter: Das Kind, Das Auto
Tip: Always learn the noun together with its article!', 2),
    (@cGerman, 'Im Restaurant & Bestellen', N'Ordering food in Germany:
- Die Speisekarte, bitte (The menu, please)
- Ich hätte gerne ein Mineralwasser (I would like a mineral water)
- Zusammen oder getrennt? (Together or separate?)', 3);
END

-- 4. Japanese: Zero to N3
DECLARE @cJapanese INT = (SELECT TOP 1 CourseID FROM Courses WHERE Title LIKE '%Japanese%');
IF @cJapanese IS NOT NULL AND NOT EXISTS (SELECT 1 FROM Lessons WHERE CourseID = @cJapanese)
BEGIN
    INSERT INTO Lessons (CourseID, Title, Content, SortOrder) VALUES
    (@cJapanese, N'Hiragana Basics: あ い う え お', N'Master the foundational Japanese phonetic alphabet:
- あ (a), い (i), う (u), え (e), お (o)
- か (ka), き (ki), く (ku), け (ke), こ (ko)
Practice stroke order from top-to-bottom, left-to-right.', 1),
    (@cJapanese, N'Katakana & Loanwords: ア イ ウ エ オ', N'Katakana is used for foreign words and emphasis:
- コーヒー (Koohii - Coffee)
- アメリカ (Amerika - America)
- レストラン (Resutoran - Restaurant)', 2),
    (@cJapanese, N'Self-Introduction: 自己紹介 (Jikoshoukai)', N'Introduce yourself in Japanese:
- 初めまして (Hajimemashite - Nice to meet you)
- 私は...です (Watashi wa [Name] desu - I am [Name])
- よろしくお願いします (Yoroshiku onegaishimasu - Please treat me kindly)', 3);
END

-- 5. Mandarin Chinese Essentials
DECLARE @cChinese INT = (SELECT TOP 1 CourseID FROM Courses WHERE Title LIKE '%Chinese%' OR Title LIKE '%Mandarin%');
IF @cChinese IS NOT NULL AND NOT EXISTS (SELECT 1 FROM Lessons WHERE CourseID = @cChinese)
BEGIN
    INSERT INTO Lessons (CourseID, Title, Content, SortOrder) VALUES
    (@cChinese, 'The Four Tones & Pinyin', N'Master the 4 fundamental tones in Mandarin:
- 1st Tone (High flat): mā (Mother)
- 2nd Tone (Rising): má (Hemp)
- 3rd Tone (Falling-rising): mǎ (Horse)
- 4th Tone (Sharp falling): mà (Scold)', 1),
    (@cChinese, N'Essential Greetings: 你好 (Nǐ hǎo)', N'Everyday conversational Chinese:
- 你好 (Nǐ hǎo - Hello)
- 谢谢 (Xièxie - Thank you)
- 不客气 (Bú kèqì - You are welcome)
- 再见 (Zàijiàn - Goodbye)', 2),
    (@cChinese, N'Numbers & Shopping: 这个多少钱？', N'Numbers and asking for prices:
- 一 (yī), 二 (èr), 三 (sān), 四 (sì), 五 (wǔ)
- 这个多少钱？ (Zhège duōshǎo qián? - How much is this?)', 3);
END

-- 6. Korean for K-Culture Fans
DECLARE @cKorean INT = (SELECT TOP 1 CourseID FROM Courses WHERE Title LIKE '%Korean%');
IF @cKorean IS NOT NULL AND NOT EXISTS (SELECT 1 FROM Lessons WHERE CourseID = @cKorean)
BEGIN
    INSERT INTO Lessons (CourseID, Title, Content, SortOrder) VALUES
    (@cKorean, N'Hangul Masterclass: ㄱ ㄴ ㄷ & ㅏ ㅓ ㅗ', N'Learn the scientific Korean alphabet:
- Consonants: ㄱ (g/k), ㄴ (n), ㄷ (d/t), ㄹ (r/l), ㅁ (m)
- Vowels: ㅏ (a), ㅓ (eo), ㅗ (o), ㅜ (u), ㅣ (i)
Combine consonants and vowels into blocks: 한 (h-a-n) 글 (g-eu-l).', 1),
    (@cKorean, 'Essential K-Drama Phrases', N'Popular expressions used in daily life and dramas:
- 안녕하세요 (Annyeonghaseyo - Hello)
- 감사합니다 (Gamsahamnida - Thank you)
- 대박! (Daebak! - Awesome / Jackpot!)
- 화이팅! (Hwaiting! - Fighting / You got this!)', 2),
    (@cKorean, 'Ordering Korean BBQ & Food', N'Food vocabulary:
- 삼겹살 2인분 주세요 (Samgyeopsal 2 inbun juseyo - 2 servings of pork belly, please)
- 물 좀 주세요 (Mul jom juseyo - Water please)', 3);
END

-- 7. Italian: La Dolce Lingua
DECLARE @cItalian INT = (SELECT TOP 1 CourseID FROM Courses WHERE Title LIKE '%Italian%');
IF @cItalian IS NOT NULL AND NOT EXISTS (SELECT 1 FROM Lessons WHERE CourseID = @cItalian)
BEGIN
    INSERT INTO Lessons (CourseID, Title, Content, SortOrder) VALUES
    (@cItalian, 'Primi Passi: Saluti & Cortesia', 'Italian greetings and courtesies:
- Ciao! (Hi / Bye)
- Buongiorno (Good morning)
- Buonasera (Good evening)
- Per favore (Please) & Grazie mille (Thank you so much)', 1),
    (@cItalian, N'Al Ristorante & Caffè', 'Ordering food like a local:
- Un espresso, per favore (An espresso, please)
- Una pizza margherita (A Margherita pizza)
- Il conto, per favore (The check, please)', 2);
END

-- 8. Portuguese: Brazil Edition
DECLARE @cPortuguese INT = (SELECT TOP 1 CourseID FROM Courses WHERE Title LIKE '%Portuguese%');
IF @cPortuguese IS NOT NULL AND NOT EXISTS (SELECT 1 FROM Lessons WHERE CourseID = @cPortuguese)
BEGIN
    INSERT INTO Lessons (CourseID, Title, Content, SortOrder) VALUES
    (@cPortuguese, 'Tudo Bem? Greetings in Brazil', 'Brazilian Portuguese greetings:
- Oi! Tudo bem? (Hi! Everything good?)
- Tudo bom! (Everything is great!)
- Por favor (Please) & Obrigado / Obrigada (Thank you)', 1),
    (@cPortuguese, 'Na Praia & Na Cidade', N'Everyday conversation in Rio & São Paulo:
- Onde fica a praia? (Where is the beach?)
- Uma água de coco, por favor (A coconut water, please)', 2);
END

-- 9. Arabic Script & Basics
DECLARE @cArabic INT = (SELECT TOP 1 CourseID FROM Courses WHERE Title LIKE '%Arabic%');
IF @cArabic IS NOT NULL AND NOT EXISTS (SELECT 1 FROM Lessons WHERE CourseID = @cArabic)
BEGIN
    INSERT INTO Lessons (CourseID, Title, Content, SortOrder) VALUES
    (@cArabic, N'The Arabic Alphabet: أ ب ت ث', N'Arabic is written right-to-left:
- Alif (أ), Baa (ب), Taa (ت), Thaa (ث)
Letters connect in cursive depending on position (initial, medial, final).', 1),
    (@cArabic, 'Essential Greetings & Courtesy', N'Polite phrases:
- السلام عليكم (As-salamu alaykum - Peace be upon you)
- وعليكم السلام (Wa alaykumu s-salam - And upon you be peace)
- شكراً (Shukran - Thank you)', 2);
END

PRINT 'All courses have been seeded with lessons!';
GO
