<%@ Page Title="About Us" Language="C#" MasterPageFile="~/MasterPages/Site.Master" AutoEventWireup="true" CodeBehind="About.aspx.cs" Inherits="binary.Pages.About" %>

<asp:Content ID="BodyContent" ContentPlaceHolderID="MainContent" runat="server">

    <%-- hero --%>
    <section class="page-hero">
        <div class="site-container">
            <div class="page-hero-badge">
                <svg class="ui-icon" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" aria-hidden="true"><path d="M2 4.5h6a4 4 0 0 1 4 4v11a3 3 0 0 0-3-3H2z"></path><path d="M22 4.5h-6a4 4 0 0 0-4 4v11a3 3 0 0 1 3-3h7z"></path></svg>
                About Binary
            </div>
            <h1>Learn a new language, <span class="gradient-text">one lesson at a time</span></h1>
            <p class="lead">Binary is a free web-based language learning platform with structured courses, video lessons, vocabulary quizzes, and progress you can actually see.</p>
            <div class="page-hero-actions">
                <a class="btn btn-primary btn-lg" runat="server" href="~/Courses">Browse courses</a>
                <a class="btn btn-outline btn-lg" id="lnkHeroSecondary" runat="server" href="~/Auth/Register.aspx">Create a free account</a>
            </div>
        </div>
    </section>

    <%-- live platform numbers (straight from the database, never hardcoded) --%>
    <section class="section-sm" aria-label="Platform in numbers">
        <div class="site-container">
            <div class="about-stats">
                <div class="about-stat">
                    <span class="about-stat-num"><asp:Literal ID="litStatCourses" runat="server">0</asp:Literal></span>
                    <span class="about-stat-label">Published courses</span>
                </div>
                <div class="about-stat">
                    <span class="about-stat-num"><asp:Literal ID="litStatLessons" runat="server">0</asp:Literal></span>
                    <span class="about-stat-label">Lessons to study</span>
                </div>
                <div class="about-stat">
                    <span class="about-stat-num"><asp:Literal ID="litStatFamilies" runat="server">0</asp:Literal></span>
                    <span class="about-stat-label">Language families</span>
                </div>
                <div class="about-stat">
                    <span class="about-stat-num"><asp:Literal ID="litStatLearners" runat="server">0</asp:Literal></span>
                    <span class="about-stat-label">Registered learners</span>
                </div>
            </div>
        </div>
    </section>

    <%-- mission --%>
    <section class="section-sm">
        <div class="site-container about-mission">
            <div>
                <span class="eyebrow">Our mission</span>
                <h2>Make language learning structured, visible, and free</h2>
                <p class="lead" style="margin-top:var(--space-4);">
                    Most people who try to learn a language give up because they can't see their progress or don't know what to study next.
                    Binary breaks each language into short, ordered lessons, checks understanding with quick quizzes, and turns every step into XP you can watch grow.
                </p>
            </div>
            <ul class="about-checklist">
                <li><span class="about-check" aria-hidden="true"></span>Every course is free — no subscriptions, no paywalls</li>
                <li><span class="about-check" aria-hidden="true"></span>Short lessons with key phrases and optional video</li>
                <li><span class="about-check" aria-hidden="true"></span>Instant feedback from auto-scored vocabulary quizzes</li>
                <li><span class="about-check" aria-hidden="true"></span>XP, titles, streaks, and a leaderboard to keep you going</li>
            </ul>
        </div>
    </section>

    <%-- what you can do --%>
    <section class="section" style="background:#ffffff;border-top:1px solid var(--border-light);border-bottom:1px solid var(--border-light);">
        <div class="site-container">
            <header class="section-header">
                <span class="eyebrow">What you can do</span>
                <h2>Everything you need to keep learning</h2>
                <p>Built around how people actually stick with a language: small steps, quick wins, and clear progress.</p>
            </header>
            <div class="about-features">
                <article class="about-feature">
                    <div class="icon-tile"><svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.75" stroke-linecap="round" stroke-linejoin="round" aria-hidden="true"><path d="M2 4.5h6a4 4 0 0 1 4 4v11a3 3 0 0 0-3-3H2z"></path><path d="M22 4.5h-6a4 4 0 0 0-4 4v11a3 3 0 0 1 3-3h7z"></path></svg></div>
                    <h3>Structured courses</h3>
                    <p>Courses for Spanish, French, Japanese, and more, organised into ordered lessons from beginner upward.</p>
                </article>
                <article class="about-feature">
                    <div class="icon-tile icon-tile-rose"><svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.75" stroke-linecap="round" stroke-linejoin="round" aria-hidden="true"><polygon points="23 7 16 12 23 17 23 7"></polygon><rect x="1" y="5" width="15" height="14" rx="2"></rect></svg></div>
                    <h3>Video lessons</h3>
                    <p>Watch lessons right on the course page, with players that only load when you open a lesson.</p>
                </article>
                <article class="about-feature">
                    <div class="icon-tile icon-tile-green"><svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.75" stroke-linecap="round" stroke-linejoin="round" aria-hidden="true"><path d="m3 7 2 2 4-4"></path><path d="m3 15 2 2 4-4"></path><line x1="11" y1="8" x2="21" y2="8"></line><line x1="11" y1="16" x2="21" y2="16"></line></svg></div>
                    <h3>Vocabulary quizzes</h3>
                    <p>Multiple-choice practice for each course, scored instantly, with every attempt saved to your history.</p>
                </article>
                <article class="about-feature">
                    <div class="icon-tile icon-tile-amber"><svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.75" stroke-linecap="round" stroke-linejoin="round" aria-hidden="true"><polygon points="13 2 3 14 12 14 11 22 21 10 12 10 13 2"></polygon></svg></div>
                    <h3>XP &amp; titles</h3>
                    <p>Earn XP for lessons, quizzes, and finished courses, and unlock titles from Beginner to Master Polyglot.</p>
                </article>
                <article class="about-feature">
                    <div class="icon-tile"><svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.75" stroke-linecap="round" stroke-linejoin="round" aria-hidden="true"><line x1="18" y1="20" x2="18" y2="10"></line><line x1="12" y1="20" x2="12" y2="4"></line><line x1="6" y1="20" x2="6" y2="14"></line></svg></div>
                    <h3>Progress you can see</h3>
                    <p>A personal dashboard with weekly activity, study streaks, course progress, and where to pick up next.</p>
                </article>
                <article class="about-feature">
                    <div class="icon-tile icon-tile-green"><svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.75" stroke-linecap="round" stroke-linejoin="round" aria-hidden="true"><path d="M8 21h8"></path><path d="M12 17v4"></path><path d="M7 4h10v5a5 5 0 0 1-10 0V4Z"></path><path d="M7 5H4.5a2.5 2.5 0 0 0 0 5H7"></path><path d="M17 5h2.5a2.5 2.5 0 0 1 0 5H17"></path></svg></div>
                    <h3>Leaderboard &amp; community</h3>
                    <p>See how your XP compares with other learners and find people studying alongside you.</p>
                </article>
            </div>
        </div>
    </section>

    <%-- how it works --%>
    <section class="section">
        <div class="site-container">
            <header class="section-header">
                <span class="eyebrow">How it works</span>
                <h2>Start learning in three steps</h2>
            </header>
            <ol class="about-steps">
                <li class="about-step">
                    <span class="about-step-num">1</span>
                    <h3>Create a free account</h3>
                    <p>Sign up in under a minute. All you need is your name and an email address.</p>
                </li>
                <li class="about-step">
                    <span class="about-step-num">2</span>
                    <h3>Enroll in a course</h3>
                    <p>Pick a language from the catalogue and enroll to unlock its lessons, videos, and quiz.</p>
                </li>
                <li class="about-step">
                    <span class="about-step-num">3</span>
                    <h3>Learn and earn XP</h3>
                    <p>Complete lessons for +<%= binary.Core.BLL.EnrollmentBLL.LessonXpReward %> XP each, finish courses for a +<%= binary.Core.BLL.EnrollmentBLL.CourseCompletionBonusXp %> XP bonus, and climb the titles.</p>
                </li>
            </ol>
        </div>
    </section>

    <%-- team --%>
    <section class="section" style="background:#ffffff;border-top:1px solid var(--border-light);">
        <div class="site-container">
            <header class="section-header">
                <span class="eyebrow">The team</span>
                <h2>Built by students, for learners</h2>
                <p>Binary was designed and developed as a web application project at Asia Pacific University of Technology &amp; Innovation.</p>
            </header>
            <div class="about-team">
                <div class="about-member">
                    <span class="about-member-avatar">DR</span>
                    <strong>Dikchya Rai</strong>
                    <span>Team member</span>
                </div>
                <div class="about-member">
                    <span class="about-member-avatar">SL</span>
                    <strong>Subash Lama Tamang</strong>
                    <span>Team member</span>
                </div>
                <div class="about-member">
                    <span class="about-member-avatar">SL</span>
                    <strong>Sumit Limbu</strong>
                    <span>Team member</span>
                </div>
            </div>
        </div>
    </section>

    <%-- call to action --%>
    <section class="section-sm">
        <div class="site-container">
            <div class="about-cta">
                <div>
                    <h2>Ready to start your first lesson?</h2>
                    <p>Every course is free. Pick a language and earn your first XP today.</p>
                </div>
                <a class="btn btn-lg about-cta-btn" id="lnkCtaBottom" runat="server" href="~/Auth/Register.aspx">Get started free</a>
            </div>
        </div>
    </section>

    <style>
        .about-stats { display: grid; grid-template-columns: repeat(4, 1fr); gap: var(--space-4); margin-top: calc(-1 * var(--space-12)); position: relative; }
        .about-stat { display: flex; flex-direction: column; align-items: center; gap: 2px; padding: var(--space-5); background: #ffffff; border: 1px solid var(--border-light); border-radius: var(--radius-lg); box-shadow: var(--shadow-card); }
        .about-stat-num { font-family: var(--font-heading); font-size: 2rem; font-weight: 800; letter-spacing: -0.02em; color: var(--brand-primary); }
        .about-stat-label { font-size: 13px; font-weight: 600; color: var(--text-muted); }
        .about-mission { display: grid; grid-template-columns: 1.2fr 1fr; gap: var(--space-12); align-items: center; }
        .about-mission h2 { font-size: clamp(1.6rem, 3vw, 2.1rem); font-weight: 800; letter-spacing: -0.02em; }
        .about-checklist { list-style: none; margin: 0; padding: var(--space-6); display: flex; flex-direction: column; gap: var(--space-4); background: #ffffff; border: 1px solid var(--border-light); border-radius: var(--radius-lg); box-shadow: var(--shadow-card); }
        .about-checklist li { display: flex; align-items: flex-start; gap: var(--space-3); font-size: 14.5px; font-weight: 600; color: var(--text-primary); }
        .about-check { width: 22px; height: 22px; border-radius: 50%; flex-shrink: 0; background: var(--brand-accent-soft) url("data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 24 24' fill='none' stroke='%23059669' stroke-width='3' stroke-linecap='round' stroke-linejoin='round'%3E%3Cpolyline points='20 6 9 17 4 12'/%3E%3C/svg%3E") center / 12px no-repeat; }
        .about-features { display: grid; grid-template-columns: repeat(3, 1fr); gap: var(--space-5); }
        .about-feature { padding: var(--space-6); border: 1px solid var(--border-light); border-radius: var(--radius-lg); background: var(--bg-page); transition: transform 0.2s ease, box-shadow 0.2s ease, border-color 0.2s ease; }
        .about-feature:hover { transform: translateY(-2px); box-shadow: var(--shadow-card-hover); border-color: rgba(67, 56, 202, 0.25); background: #ffffff; }
        .about-feature h3 { font-size: 1.05rem; font-weight: 800; margin: var(--space-4) 0 var(--space-2); }
        .about-feature p { font-size: 14px; color: var(--text-secondary); line-height: 1.65; }
        .about-steps { list-style: none; margin: 0; padding: 0; display: grid; grid-template-columns: repeat(3, 1fr); gap: var(--space-5); counter-reset: none; }
        .about-step { position: relative; padding: var(--space-6); background: #ffffff; border: 1px solid var(--border-light); border-radius: var(--radius-lg); box-shadow: var(--shadow-subtle); }
        .about-step-num { width: 36px; height: 36px; border-radius: 50%; display: grid; place-items: center; background: var(--brand-primary); color: #ffffff; font-weight: 800; box-shadow: 0 4px 10px var(--brand-primary-glow); }
        .about-step h3 { font-size: 1.05rem; font-weight: 800; margin: var(--space-4) 0 var(--space-2); }
        .about-step p { font-size: 14px; color: var(--text-secondary); line-height: 1.65; }
        .about-team { display: grid; grid-template-columns: repeat(3, minmax(0, 220px)); justify-content: center; gap: var(--space-5); }
        .about-member { display: flex; flex-direction: column; align-items: center; gap: 4px; padding: var(--space-6) var(--space-4); border: 1px solid var(--border-light); border-radius: var(--radius-lg); background: var(--bg-page); text-align: center; }
        .about-member-avatar { width: 64px; height: 64px; border-radius: 50%; margin-bottom: var(--space-3); display: grid; place-items: center; background: linear-gradient(135deg, #6366f1, #8b5cf6); color: #ffffff; font-family: var(--font-heading); font-size: 1.3rem; font-weight: 800; }
        .about-member strong { font-size: 15px; color: var(--text-primary); }
        .about-member span:last-child { font-size: 12.5px; color: var(--text-muted); }
        .about-cta { display: flex; align-items: center; justify-content: space-between; gap: var(--space-6); flex-wrap: wrap; padding: var(--space-8) var(--space-10); border-radius: var(--radius-xl); background: linear-gradient(135deg, var(--brand-primary) 0%, #6d28d9 100%); color: #ffffff; box-shadow: var(--shadow-float); }
        .about-cta h2 { color: #ffffff; font-size: 1.6rem; font-weight: 800; }
        .about-cta p { color: rgba(255, 255, 255, 0.82); margin-top: 4px; }
        .about-cta-btn { background: #ffffff; color: var(--brand-primary); }
        .about-cta-btn:hover { background: var(--brand-primary-soft); transform: translateY(-1px); }
        @media (max-width: 900px) {
            .about-stats { grid-template-columns: repeat(2, 1fr); }
            .about-mission, .about-features, .about-steps { grid-template-columns: 1fr; }
            .about-team { grid-template-columns: 1fr; }
            .about-cta { padding: var(--space-6); }
        }
    </style>

</asp:Content>
