# Techspire LMS

## Project Documentation

**sampada kharel**  
**August 2026**

> This README is a Markdown conversion of the supplied `Project_documentation.pdf`. The source wording and information have been preserved as closely as possible; formatting has been changed only to suit Markdown.

---

## Contents

1. [What Is This Project?](#1-what-is-this-project)
2. [Technology Stack](#2-technology-stack)
3. [Project Structure](#3-project-structure)
4. [How the Code Is Organized (Architecture)](#4-how-the-code-is-organized-architecture)
5. [Entity Relationship Diagram](#5-entity-relationship-diagram)
6. [Use Case Diagram](#6-use-case-diagram)
7. [Setup Guide: From Zero to Running](#7-setup-guide-from-zero-to-running)
8. [User Roles and What Each Can Do](#8-user-roles-and-what-each-can-do)
9. [Complete Feature List](#9-complete-feature-list)
10. [Database Schema](#10-database-schema)
11. [Security, Authentication, Authorization and Validation](#11-security-authentication-authorization-and-validation)
12. [Known Limitations](#12-known-limitations)
13. [Making This Your Own Project](#13-making-this-your-own-project)
14. [Conclusion](#14-conclusion)

---

Contents
## 1 What Is This Project?
2
## 2 Technology Stack
2
## 3 Project Structure
2
## 4 How the Code Is Organized (Architecture)
3
## 5 Entity Relationship Diagram
5
## 6 Use Case Diagram
6
## 7 Setup Guide: From Zero to Running
8
## 8 User Roles and What Each Can Do
9
## 9 Complete Feature List
9
## 10 Database Schema
10
## 11 Security, Authentication, Authorization and Validation
10
11.1 Authentication vs. Authorization . . . . . . . . . . . . . . . . . . . . . . . . . . . . .
10
11.2 Sessions: How the Server Remembers You Are Logged In . . . . . . . . . . . . . . . .
11
11.3 Password Hashing and Salting . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . .
11
11.4 Login Lockout . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . .
12
### 11.5 Authorization: Protecting Every Admin Page in One Place
. . . . . . . . . . . . . .
13
### 11.6 SQL Injection and Parameterized Queries
. . . . . . . . . . . . . . . . . . . . . . . .
13
### 11.7 Insecure Direct Object Reference (IDOR)
. . . . . . . . . . . . . . . . . . . . . . . .
14
### 11.8 Form Validation: Client-Side and Server-Side
. . . . . . . . . . . . . . . . . . . . . .
14
11.9 File Upload Safety . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . .
15
11.10Summary Table . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . .
16
## 12 Known Limitations
16
## 13 Making This Your Own Project
16
## 14 Conclusion
17
1

## 1 What Is This Project?
Techspire LMS is a Learning Management System, a website where an Admin publishes courses
made up of lessons and quizzes, and a registered Member can browse, enrol, work through the
lessons, take the quiz, and track their progress.
It is built as a generic base template, deliberately. Nothing in the database, the business
logic, or the pages assumes a specific subject: the same code works unmodified for a programmingskills platform, a cybersecurity-training platform, or any other course-based subject. Only the data
changes (course titles, categories); the code never does.
**CONCEPT**
If you have never worked on a project like this before, think of it as three separate concerns
stacked on top of one another:
- The database, where everything is permanently stored (users, courses, quiz scores).
- The C# code, the rules (“you cannot enrol twice”, “a password must be at least 8
characters”).
- The web pages, what a visitor actually sees and clicks on in their browser.
This document walks through all three, plus how the whole system is kept secure end to end.
## 2 Technology Stack
Layer
Technology
Language
C#
Web framework
ASP.NET Web Forms, a Web Application Project (not a
“Website” project; this affects how every code-behind file is compiled)
Target framework
.NET Framework 4.8
Database
Microsoft SQL Server (developed against SQL Server Express)
Database tool
SQL Server Management Studio (SSMS)
Front end
Plain HTML5, CSS3, and ASP.NET server controls
IDE
Visual Studio 2019 or 2022
Required before starting: Visual Studio (with the “ASP.NET and web development” workload
installed), a SQL Server instance, and SQL Server Management Studio.
## 3 Project Structure
Every folder has exactly one job. Understanding this layout is the fastest way to know where to
look for anything.
Techspire_LMS /
|
|-- Models/
Plain C# classes
describing
each "thing" in the
|
system (Course , User , Quiz ...). No logic , no
|
SQL , just
properties .
|
|-- Data_Access_Layer /
ALL SQL
lives here , and
only
here. One
class
per
|
(the "DAL")
database
table
-- CourseDAL.cs , UserDAL.cs , etc.
|
Also
DbHelper.cs , shared
connection /parameter
|
plumbing
every
DAL
class
uses.
|
|-- BLL/
Business
Logic
Layer. Validation
rules ,
|
authentication , quiz
scoring , password
hashing

|
calls , the "is this
actually
allowed ?" layer.
|
|-- Helpers/
Small
reusable
```text
utilities: PasswordHelper .cs
```
|
(hashing), ErrorLogger .cs , SqlErrorHelper .cs.
|
|-- Masterpages /
Shared
page
layout. Site.master (public
and
|
member
pages) and
Admin.master (admin
section ,
|
and
where
admin -only
access is
enforced).
|
|-- Pages/
Public
pages: Default.aspx (home), Courses.aspx
|
(catalogue), CourseDetails .aspx ,
|
LessonDetails .aspx , Contact.aspx.
|
|-- Account/
Login.aspx , Register.aspx , Logout.aspx ,
|
Profile.aspx.
|
|-- Member/
Pages
requiring
login: Quiz.aspx , MyLearning.aspx.
|
|-- Admin/
Pages
requiring
an Admin
account: manage
|
Categories , Courses , Lessons , Quizzes , Users ,
|
Feedback.
|
|-- Errors/
Friendly
404 and 500
error
pages.
|
|-- Content/
site.css , the one
stylesheet
the
whole
site
|
shares.
|
|-- App_Data/
Where
ErrorLogger .cs writes
errors.log.
|
|-- Web.config
Database
connection
string , session
settings ,
|
error -page
routing.
|
|-- Web.sitemap
Defines
the
breadcrumb
trail on every
page.
|
|-- Default.aspx
Sits at the
PROJECT
ROOT (not
inside
Pages /).
|
Redirects
the
bare
site
URL to Pages/Default.aspx.
|
‘-- CreateDatabase .sql
Run
once in SSMS to create
the
entire
database.
## 4 How the Code Is Organized (Architecture)
Every request to this site flows through four layers, in a fixed order, and each layer only ever
talks to the one directly below it. A restaurant makes the idea concrete:
- Models = the menu. Plain descriptions of what a “Course” or “User” is: a Title, an Email, a
Price. No behaviour, just shape.
- Data Access Layer (DAL) = the kitchen staff who physically go into the pantry. Every SQL
query in the entire project lives here, nowhere else is allowed to talk to the database directly.
- Business Logic Layer (BLL) = the head chef, enforcing the recipe rules (“a course must have
a title”, “you cannot enrol in the same course twice”). The kitchen staff do whatever they are
told; the chef is what stops a bad order from ever reaching the pantry.
- Pages (.aspx) = the waiter. Takes the visitor’s click, asks the chef (BLL) what is allowed, and
serves the result back as a web page. A waiter never walks into the pantry directly.
**IN OUR PROJECT**
Open any file inside Pages/, Account/, Member/, or Admin/ and search it for the word
```text
SqlCommand. You will never find one: every button-click handler calls a method on a BLL
```
class instead (e.g. new CourseBLL().Add(...)), and that BLL class is the only thing that
calls a DAL class, which is the only thing that ever builds a SQL query.
An example, end to end: a student clicking “Enrol”:
1. CourseDetails.aspx.cs’s btnEnrol_Click calls new EnrollmentBLL().Enroll(userId, courseId).

2. EnrollmentBLL.Enroll checks the course exists, is published, and the user is not already enrolled, throwing a friendly ValidationException if any check fails.
3. Only if all checks pass does it call EnrollmentDAL.Insert(userId, courseId).
4. EnrollmentDAL.Insert runs one parameterized INSERT statement and returns the new row’s
ID.

## 5 Entity Relationship Diagram
The database has 15 tables. Underlined fields are primary keys; italic fields are foreign keys. Deleting a Course cascades to its Lessons, Resources,
Quizzes, Questions and QuestionOptions, but never to Enrollments or QuizAttempts: a learner’s history survives even if the course is later removed.
Roles
RoleID
Users
UserID
RoleID
Enrollments
EnrollmentID
UserID, CourseID
LessonProgress
EnrollmentID, LessonID
Feedback
FeedbackID
UserID (nullable)
Categories
CategoryID
Courses
CourseID
CategoryID, CreatedBy
Lessons
LessonID
CourseID
Resources
ResourceID
LessonID
Tags
TagID
CourseTags
CourseID, TagID
Quizzes
QuizID
CourseID
Questions
QuestionID
QuizID
QuestionOptions
QuestionID
QuizAttempts
AttemptID
UserID, QuizID
1:N
1:N
1:N
1:N
1:N
1:N
N:M
1:N
1:N
N:M
1:N
1:N
1:N
1:N
1:N

## 6 Use Case Diagram
The hollow-triangle arrows are UML generalization: Member literally “is a kind of” Guest in this system (an Admin account is still a normal logged-in
Member underneath, plus admin rights), so each actor’s diagram only shows the capabilities added at that level. Member also has every Guest capability,
and Admin also has every Member capability.

Guest
Member
Admin
Browse
Courses
Search / Filter
Courses
View Course
Details
Register
Account
Log In
Submit
Feedback
Enrol in
Course
View Lesson
Content
Mark Lesson
Complete
Take Quiz
View My
Learning Dashboard
Edit Profile /
Change Password
Unenrol from
Course
Manage
Categories
Manage Courses
& Lessons
Manage Quizzes
& Questions
Manage Users
(promote / lock)
View
Feedback
Preview Unpublished
Content
Guest capabilities
Member capabilities (in addition to Guest)
Admin capabilities (in addition to Member)

## 7 Setup Guide: From Zero to Running
Follow these in order.
Step 1: Open the project
Open Techspire_LMS.sln in Visual Studio (File →Open →Project/Solution).
Step 2: Create the database
1. Open SQL Server Management Studio and connect to your SQL Server instance.
2. Open CreateDatabase.sql and click Execute.
3. This creates a database called LearningPlatformDB, all 15 tables, and a small amount of sample
data.
Step 3: Point the app at your database
Open Web.config and edit the connection string’s Data Source to match your SQL Server instance
name (visible in SSMS’s “Server name” box when you connected in Step 2):
<connectionStrings >
<add name=" LearningPlatformDB "
connectionString ="Data
Source =.\ SQLEXPRESS;Initial
Catalog=
LearningPlatformDB ;Integrated
Security=True; TrustServerCertificate =
True;Connect
Timeout =30"
providerName="System.Data.SqlClient" />
</ connectionStrings >
Step 4: Fix designer files (a one-time Visual Studio quirk)
Each .aspx page needs a matching .aspx.designer.cs file, auto-generated by Visual Studio, declaring every control on the page. Right-click the project →Convert to Web Application to regenerate all of them at once. If that option is unavailable, open each .aspx page in the designer and
save it (Ctrl+S) to regenerate that page’s file individually.
Step 5: Build
Build →Rebuild Solution. The Error List window should show zero errors before continuing.
Step 6: Create the first Admin account
There is no Admin account yet. A standalone tool, CreateAdmin.cs, creates the first one by writing
directly to the database using the same password-hashing code the login page verifies against (see
Section 11.3 for exactly how that guarantee works). Compile and run it once from a terminal in the
project folder.
Step 7: Run
Right-click Pages/Default.aspx →Set as Start Page, then press F5.
Step 8: Explore
Log in as the Admin you just created. Add a real Category, add a real Course under it, publish it.
Log out, register a second (Member) account, enrol, and take its quiz.

## 8 User Roles and What Each Can Do
Role
Can do
Cannot do
Guest
(not logged in)
Browse the catalogue, search, filter by
category/tag; view a published course’s
details; submit the Contact form;
register; log in
Enrol; view lesson content; take
a quiz; see draft courses
Member
(registered,
logged in)
Everything a Guest can, plus:
enrol;
read lessons; watch embedded lesson
video; download resources; mark lessons
complete; take quizzes; view “My Learning” (progress + quiz history); edit profile; change password; unenrol from a
course
Anything under /Admin/, redirected home automatically
Admin
(logged in,
Admin role)
Everything a Member can, plus:
full
CRUD on Categories, Courses, Lessons,
Quizzes (with nested Questions and
Answer Options),
Users,
and Feedback; preview unpublished content; promote/demote/deactivate/unlock users
None
**WORTH KNOWING**
Feedback does not require login. The Contact form (Pages/Contact.aspx) has no login
check anywhere in its code, anyone can submit it. A guest submission is simply stored with
no linked account.
An Admin account is still a normal Member underneath. That is why Admin accounts
also see “My Learning” and “Profile” in the navigation, useful for previewing a course or testing
a quiz before publishing it, not a bug.
## 9 Complete Feature List
Public browsing
Home page with featured courses; full catalogue with keyword search, category filter, tag filter, and
true SQL-level pagination; course details with description, tags, lesson list, quiz list.
Accounts and security
Registration and login with salted password hashing; login lockout after five failed attempts (fifteen
minutes); profile editing and password change; client-side and server-side validation on every form.
Learning
Enrolment (and unenrolment); lesson viewing with real embedded video; downloadable lesson resources; per-lesson completion tracking with progress recalculated from actual completions; quiztaking with exact-match grading; permanent quiz-attempt history.

Admin management
Full Create/Read/Update/Delete on Categories, Courses, Lessons, Quizzes (with nested Questions
and Answer Options), Users, and Feedback; file uploads for thumbnails and lesson resources with
safety checks; in-memory pagination on every admin grid.
Navigation and reliability
Breadcrumb trail on every page; friendly 404/500 error pages; centralized error logging.
## 10 Database Schema
Fifteen tables, created by CreateDatabase.sql:
Table
What it stores
Roles
The two roles: Admin, Member
Users
Accounts: name, email, password hash and salt, role, lockout state
Categories
Top-level course groupings
Tags
Free-form labels a course can have
CourseTags
Junction table linking Courses and Tags (many-to-many)
Courses
Course records: title, description, category, published status
Lessons
Lessons belonging to a course, in order
Resources
Downloadable files attached to a lesson
Enrollments
Which user is enrolled in which course, and their progress percentage
LessonProgress
Which specific lessons a given enrolment has completed
Quizzes
Quizzes belonging to a course
Questions
Questions belonging to a quiz
QuestionOptions
Answer options belonging to a question, flagged correct or incorrect
QuizAttempts
Permanent record of every quiz attempt and its score
Feedback
Contact form submissions, guest or Member
## 11 Security, Authentication, Authorization and Validation
This is the section to read most carefully. Each idea is explained from zero, then shown exactly
where and how it lives in this project’s actual code.
### 11.1 Authentication vs. Authorization
**CONCEPT**
Two different questions, easy to confuse:
- Authentication = “who are you?”, proven by logging in with a correct email and password.
- Authorization = “now that we know who you are, what are you allowed to do?”, e.g., is
this account an Admin?
A site can authenticate someone perfectly and still be broken if it forgets to check authorization
before letting them into an admin page. This project checks both, separately, every time.

### 11.2 Sessions: How the Server Remembers You Are Logged In
**CONCEPT**
HTTP itself has no memory, every request is independent. After a successful login, the server
stores “this browser is User #5” in Session, server-side memory tied to that visitor via a
cookie. Every later request checks Session to answer “who is this?” without asking for the
password again on every single page.
**IN OUR PROJECT**
```text
AuthBLL is the only class in the entire project that reads or writes Session. Every page asks
```
it static questions instead of touching Session directly:
```text
AuthBLL.IsLoggedIn
```
// bool: is anyone
logged in right now?
```text
AuthBLL.CurrentUserId
```
// int: their UserID , or 0 if not logged in
```text
AuthBLL.IsAdmin
```
// bool: is the logged -in user an Admin?
Centralizing this in one class means there is exactly one place that defines what “logged in”
means for the whole application.
### 11.3 Password Hashing and Salting
**CONCEPT**
Never store a password as typed. If the database is ever stolen, a plain password list hands
over every account instantly.
Instead, store a hash, a one-way scramble that cannot be
reversed back to the original password, only checked (“does hashing THIS input give the same
result?”).
A hash alone still has a weakness: two users with the same password get the same hash, and
an attacker can pre-compute hashes for every common password once (“rainbow tables”) and
match them instantly against a stolen database. The fix is a salt, a random value unique to
each user, mixed in before hashing, so the same password produces a different hash for every
account.
**IN OUR PROJECT**
```text
Helpers/PasswordHelper.cs is the only place this logic lives:
```
public
static
string
GenerateSalt ()
```text
{
byte [] bytes = new byte [16];
using ( RNGCryptoServiceProvider
```
rng = new
RNGCryptoServiceProvider ())
rng.GetBytes(bytes);
return
ToHex(bytes);
// 16 random
bytes
-> 32 hex chars
```text
}
```
public
static
string
Hash(string
password , string
salt)
```text
{
using (SHA256 sha = SHA256.Create ())
{
byte [] combined = Encoding.UTF8.GetBytes (( password ?? "") + salt);
```
return
ToHex(sha.ComputeHash(combined));
// -> 64 hex chars
```text
}
}
```
public
static
bool
Verify(string
password , string salt , string
expectedHash)
```text
{
```
string
actualHash = Hash(password , salt);

return
string.Equals(actualHash , expectedHash , StringComparison .
OrdinalIgnoreCase );
```text
}
```
Notice Verify never “decrypts” anything, hashing is not reversible. It re-hashes the login
attempt with the SAME stored salt and compares the two hashes. This is why Users has two
password columns, PasswordHash and PasswordSalt, and never a plain Password column.
### 11.4 Login Lockout
**CONCEPT**
Even with hashed passwords, an attacker who can try unlimited password guesses against
the login form will eventually succeed on a weak password. Locking an account after a small
number of wrong attempts makes that attack impractical.
**IN OUR PROJECT**
```text
BLL/AuthBLL.cs’s Login method, five wrong passwords locks the account for fifteen minutes:
```
User u = _userDal.SelectByEmail (email.Trim (). ToLowerInvariant ());
```text
if (u == null || !u.IsActive)
throw new
```
ValidationException ("Invalid
email or password.");
```text
if (u. LockoutEndUtc.HasValue && u. LockoutEndUtc .Value > DateTime.UtcNow)
{
```
int
minutesLeft = ...;
```text
throw new
```
ValidationException (
"Too many
failed
attempts. Try again in " + minutesLeft + "
minutes.");
```text
}
if (! PasswordHelper.Verify(password , u.PasswordSalt , u.PasswordHash))
{
```
int
newCount = u. FailedLoginAttempts + 1;
```text
if (newCount
```
>= MaxFailedAttempts )
// 5 attempts
lockoutEnd = DateTime.UtcNow.Add( LockoutDuration ); // 15 minutes
_userDal. RecordFailedLogin (u.UserID , newCount , lockoutEnd);
```text
throw new
```
ValidationException ("Invalid
email or password.");
```text
}
```
Two design decisions worth understanding here, not just the code:
- “Invalid email or password” is deliberately the SAME message whether the email
does not exist or the password is wrong. Telling an attacker which one it was (“no account
with that email”) would let them discover which emails are registered, this is called a userenumeration leak, and avoiding it is a real, considered security decision, not an accident.
- The lockout message is a small, deliberate exception to that same rule: it does
say “too many attempts,” which is more honest to a real, confused user who is sure their
password is correct. Explicitly accepting a narrow trade-off, and being able to explain
why, is better engineering than an unexplained inconsistency.

### 11.5 Authorization: Protecting Every Admin Page in One Place
**CONCEPT**
The naive way to protect ten admin pages is to copy-paste the same “is this user an Admin?”
check into all ten Page_Load methods. This works until an eleventh page is added and someone
forgets. A much safer pattern: enforce the check in exactly one place that every protected
page is forced to pass through.
**IN OUR PROJECT**
Masterpages/Admin.master.cs is that one place:
protected
void
Page_Load(object sender , EventArgs e)
```text
{
if (! AuthBLL.IsLoggedIn)
{
```
Response.Redirect("~/ Account/Login.aspx?ReturnUrl=" + ...);
return;
```text
}
if (! AuthBLL.IsAdmin)
{
```
Response.Redirect("~/ Pages/Default.aspx");
return;
```text
}
```
// ... only
Admins
reach
past this
point
```text
}
```
Every admin page sets MasterPageFile="~/Masterpages/Admin.master", and that one
check runs for all of them, automatically, because the master page’s own code always executes first. A new admin page added next year is protected the moment it picks this master
page; there is nothing to remember to add.
### 11.6 SQL Injection and Parameterized Queries
**CONCEPT**
If a page builds a query by joining text together, "SELECT * FROM Users WHERE Email = ’"
+ email + "’", a user can type ’ OR ’1’=’1 into the email box and turn the query into
something that always matches, bypassing login entirely. Or worse, end the query and start
a new, destructive one.
The fix: parameterized queries. The value is sent to the database separately from the
SQL text, tagged as “this is data, never code”, no matter what characters it contains.
**IN OUR PROJECT**
Every single query in every Data_Access_Layer class follows this exact pattern, with zero
exceptions:
public
Category
SelectById(int
categoryId)
```text
{
```
const
string sql = "SELECT * FROM
Categories
WHERE
CategoryID =
@CategoryID;";
```text
using (SqlCommand
```
cmd = DbHelper. CreateCommand (con , sql))
```text
{
```
DbHelper.AddParam(cmd , "@CategoryID", categoryId);
```text
...
}
}
```
@CategoryID is a placeholder; the actual value is attached separately via AddParam. Search

any .cs file inside Data_Access_Layer/ for a plus sign (+) joining a variable into a SQL
string, there is not one.
### 11.7 Insecure Direct Object Reference (IDOR)
**CONCEPT**
A URL like CourseDetails.aspx?id=7 is fine, course #7 is public information, anyone can
see it. A URL like ChangePassword.aspx?userId=7 would NOT be fine, it lets anyone edit
the number in the address bar and act as a different account. The rule: never trust an
identity value that comes from the URL, a hidden form field, or a button’s posted
argument. Identity always comes from server-side Session, set once at login.
**IN OUR PROJECT**
Pages/CourseDetails.aspx.cs states the rule directly in a code comment:
// Identity
for the enrol
action
comes
from
```text
Session (AuthBLL), never
```
from
// the query
string: the query
string
only ever
carries
the COURSE id ,
// which is public
information. Using ?userid =.. here
would be an
// Insecure
Direct
Object
Reference.
private int
CourseId { get { ...
Request.QueryString["id"] ... } }
protected
void
btnEnrol_Click(object sender , EventArgs e)
```text
{
```
new
```text
EnrollmentBLL ().Enroll(AuthBLL.CurrentUserId , CourseId);
```
//
^^^^^^^^^^^^^^^^^^^^^
from Session , not
the URL
```text
}
```
The same discipline applies everywhere an action needs to know “whose data is this”, for
example, EnrollmentBLL.Unenroll takes the calling user’s ID as a required parameter and
verifies the enrolment actually belongs to them before deleting anything, rather than trusting
whatever enrolment ID a button happened to post.
### 11.8 Form Validation: Client-Side and Server-Side
**CONCEPT**
Client-side validation (JavaScript in the browser, or ASP.NET’s Validator controls which
generate that JavaScript automatically) gives instant feedback with no round trip to the
server. It is pure convenience, a user can disable JavaScript, or skip the browser entirely and
send a raw request. It stops nothing.
Server-side validation runs no matter what the browser did or did not check. This is the
actual security boundary. A correct application always has both: client-side for a good
experience, server-side because the client can never be trusted.
**IN OUR PROJECT**
Client-side, in Account/Register.aspx:
<asp:TextBox ID="txtPassword" runat="server" TextMode="Password" />
<asp:RequiredFieldValidator
ControlToValidate ="txtPassword"
ErrorMessage="Password is required." runat="server" />
<asp:RegularExpressionValidator
ControlToValidate ="txtPassword"
ValidationExpression =".{8,}"
ErrorMessage="Password
must be at least 8 characters." runat="server"
/>

<asp:CompareValidator
ControlToValidate =" txtConfirmPassword "
ControlToCompare ="txtPassword"
ErrorMessage="Passwords do not match." runat="server" />
These block the form from even submitting until every rule passes, instant, no server round
trip.
Server-side, in BLL/CourseBLL.cs (every BLL class’s write methods follow this identical
pattern):
private
void
Validate(Course c)
```text
{
if (c == null) throw new
```
ValidationException ("No course
data was
supplied.");
```text
if (string. IsNullOrWhiteSpace (c.Title))
throw new
```
ValidationException ("Title is required.");
c.Title = c.Title.Trim ();
```text
if (c.Title.Length > 200)
throw new
```
ValidationException ("Title
must be 200
characters or
fewer.");
```text
if (c.CategoryID
```
<= 0)
```text
throw new
```
ValidationException ("Please
choose a category.");
```text
...
}
```
This runs on every Add/Edit call regardless of how the request arrived:
browser with
JavaScript on, JavaScript disabled, or a raw request built by a tool that skips the browser
entirely.
**WORTH KNOWING**
A
real
bug
this
project
hit
while
adding
validators,
worth
knowing:
Account/Profile.aspx has TWO separate forms on one page (edit profile, change password). Without a ValidationGroup on every validator and button, clicking “Save changes”
on the profile form also ran the empty password fields’ RequiredFieldValidators and blocked
the save with unrelated errors. Fix: every control belonging to one form shares the same
ValidationGroup value, a validator only fires for the button in its own group. A second,
related trap: GridView row buttons (Edit/Delete) default to CausesValidation="true", the
moment a page’s Add/Edit form gains a validator, clicking Edit or Delete on an existing
row can get silently blocked by that validator unless those buttons are explicitly marked
CausesValidation="false".
### 11.9 File Upload Safety
**CONCEPT**
Accepting an uploaded file safely means checking more than “did a file arrive.” Three separate
things matter: what type of file, how big, and, the check students most often miss, never
trusting the file’s own claimed name.
**IN OUR PROJECT**
Admin/ManageCourses.aspx.cs, uploading a course thumbnail:
string
extension = Path.GetExtension(fuThumbnail.FileName).
ToLowerInvariant ();
```text
if (Array.IndexOf(AllowedImageExtensions , extension) < 0)
throw new
```
ValidationException ("Thumbnail
must be a JPG , PNG , GIF or
WEBP
image.");

```text
if (fuThumbnail.PostedFile.ContentLength > MaxThumbnailBytes )
```
// 2 MB
```text
throw new
```
ValidationException ("Thumbnail
must be 2 MB or smaller.");
// A random
filename , never the visitor -supplied one , sidesteps
path
// traversal (a filename
like
"..\..\ web.config ") and
collisions
between
// two
different
admins ’ uploads.
string
safeFileName = Guid.NewGuid ().ToString("N") + extension;
fuThumbnail.SaveAs(Path.Combine(folderPath , safeFileName));
A visitor could name a file ..\..\Web.config, hoping to overwrite the application’s configuration. Generating a random name on the server makes that impossible regardless of what
the file claims to be called.
### 11.10 Summary Table
Risk
How it is prevented
Where
SQL Injection
Every query parameterized, no exceptions
Every
Data_Access_Layer
class
Stolen
password
database
Salted SHA-256 hashing, never plain
text
```text
Helpers/PasswordHelper.cs
```
Brute-force login guessing
Lockout after 5 failed attempts, 15
minutes
```text
BLL/AuthBLL.cs
```
Unauthorized admin access
One centralized check, inherited by every admin page
Masterpages/Admin.master.cs
Acting as another user
(IDOR)
Identity always from Session, ownership verified server-side
EnrollmentBLL,
CourseDetails.aspx.cs
Invalid/malicious
form
input
Client-side
instant
feedback
plus
server-side enforced boundary
Every .aspx form +
every BLL.Validate
Malicious file upload
Extension allowlist, size cap, randomized filename
ManageCourses.aspx.cs,
ManageLessons.aspx.cs
## 12 Known Limitations
**LIMITATION**
Named deliberately, each is a scoped decision made along the way, not an oversight:
- Session-based authentication, not ASP.NET Forms Authentication.
- Static navigation breadcrumbs: a specific course’s page shows a generic label, not that
course’s actual title.
- No forgot-password or email flow, no email sending is configured.
- Seed data is placeholder content, by design, replacing it with a real subject is the first step
in making this project your own.
## 13 Making This Your Own Project
1. Pick a real subject. Nothing in the code needs to change for this, only the data does.
2. Replace the seed data in CreateDatabase.sql, or use the Admin pages once the site is
running.

3. Rebrand two files: Masterpages/Site.master’s title text, and Content/site.css’s colour
variables near the top. Every page repaints from those two changes automatically.
4. Write the report. Documentation is graded separately from, and roughly equally to, the code,
the Entity Relationship Diagram and Use Case Diagram in this document are a starting point
for that report’s Design and Modelling section, not a replacement for it.
## 14 Conclusion
Techspire LMS demonstrates a complete, working three-tier web application: a normalized relational
database, a Data Access Layer with zero SQL outside it, a Business Logic Layer enforcing every
rule server-side, and a Presentation layer that never bypasses either. Security is not a bolted-on
afterthought: parameterized queries, salted password hashing, centralized authorization, IDORaware identity handling, and layered validation appear consistently across every feature, not just a
few showcase pages. Understanding why each of these choices was made, not only that they exist,
is what this document has tried to make possible from a standing start.
