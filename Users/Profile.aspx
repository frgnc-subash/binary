<%@ Page Title="My Profile" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Profile.aspx.cs" Inherits="binary.Users.Profile" %>

<asp:Content ID="BodyContent" ContentPlaceHolderID="MainContent" runat="server">

    <section class="section-sm">
        <div class="site-container">
            <div class="profile-layout">

                <%-- Sidebar --%>
                <aside class="profile-sidebar">
                    <div class="card card-body profile-card">
                        <div class="profile-avatar">JD</div>
                        <h2 class="profile-name">Jane Doe</h2>
                        <p class="profile-handle">@jane.doe</p>
                        <div class="profile-badges">
                            <span class="badge badge-primary">Pro Learner</span>
                            <span class="badge badge-success">&#128293; 42-day streak</span>
                        </div>
                        <div class="profile-xp">
                            <div style="display:flex;justify-content:space-between;margin-bottom:6px;">
                                <span style="font-size:13px;font-weight:600;color:var(--text-muted);">XP Progress</span>
                                <span style="font-size:13px;font-weight:700;">3,820 / 5,000 XP</span>
                            </div>
                            <div class="progress"><div class="progress-bar" style="width:76%"></div></div>
                        </div>
                        <a class="btn btn-outline" style="width:100%;margin-top:var(--space-5);" href="#">Edit Profile</a>
                    </div>

                    <div class="card card-body profile-stats">
                        <div class="profile-stat">
                            <div class="profile-stat-num">3</div>
                            <div class="profile-stat-label">Courses Active</div>
                        </div>
                        <div class="profile-stat">
                            <div class="profile-stat-num">12</div>
                            <div class="profile-stat-label">Completed</div>
                        </div>
                        <div class="profile-stat">
                            <div class="profile-stat-num">42</div>
                            <div class="profile-stat-label">Day Streak</div>
                        </div>
                        <div class="profile-stat">
                            <div class="profile-stat-num">3.8k</div>
                            <div class="profile-stat-label">XP Earned</div>
                        </div>
                    </div>
                </aside>

                <%-- Main --%>
                <div class="profile-main">

                    <%-- Active Courses --%>
                    <div class="card">
                        <div class="card-header" style="display:flex;align-items:center;justify-content:space-between;">
                            <h3 style="font-size:1.1rem;">Active Courses</h3>
                            <a class="btn btn-primary" runat="server" href="~/Courses">+ Add Course</a>
                        </div>
                        <div class="card-body">
                            <div class="active-course-list">
                                <div class="active-course-item">
                                    <div class="active-course-flag">&#127480;&#127477;</div>
                                    <div class="active-course-info">
                                        <div class="active-course-name">Spanish for Beginners</div>
                                        <div class="active-course-meta">Lesson 18 of 40 &bull; Beginner</div>
                                        <div class="progress" style="margin-top:8px;"><div class="progress-bar" style="width:45%"></div></div>
                                    </div>
                                    <span class="active-course-pct">45%</span>
                                    <a class="btn btn-primary" href="#">Continue</a>
                                </div>
                                <div class="active-course-item">
                                    <div class="active-course-flag">&#127471;&#127477;</div>
                                    <div class="active-course-info">
                                        <div class="active-course-name">Japanese: Zero to N3</div>
                                        <div class="active-course-meta">Lesson 32 of 80 &bull; All Levels</div>
                                        <div class="progress" style="margin-top:8px;"><div class="progress-bar" style="width:40%"></div></div>
                                    </div>
                                    <span class="active-course-pct">40%</span>
                                    <a class="btn btn-primary" href="#">Continue</a>
                                </div>
                                <div class="active-course-item">
                                    <div class="active-course-flag">&#127467;&#127479;</div>
                                    <div class="active-course-info">
                                        <div class="active-course-name">French Immersion</div>
                                        <div class="active-course-meta">Lesson 8 of 55 &bull; Intermediate</div>
                                        <div class="progress" style="margin-top:8px;"><div class="progress-bar" style="width:15%"></div></div>
                                    </div>
                                    <span class="active-course-pct">15%</span>
                                    <a class="btn btn-primary" href="#">Continue</a>
                                </div>
                            </div>
                        </div>
                    </div>

                    <%-- Achievements --%>
                    <div class="card" style="margin-top:var(--space-5);">
                        <div class="card-header">
                            <h3 style="font-size:1.1rem;">Achievements</h3>
                        </div>
                        <div class="card-body">
                            <div class="achievement-grid">
                                <div class="achievement earned"><div class="achievement-icon">&#127775;</div><div class="achievement-name">First Lesson</div></div>
                                <div class="achievement earned"><div class="achievement-icon">&#128293;</div><div class="achievement-name">7-Day Streak</div></div>
                                <div class="achievement earned"><div class="achievement-icon">&#127942;</div><div class="achievement-name">Course Complete</div></div>
                                <div class="achievement earned"><div class="achievement-icon">&#129504;</div><div class="achievement-name">100 Words</div></div>
                                <div class="achievement"><div class="achievement-icon">&#127760;</div><div class="achievement-name">Polyglot</div></div>
                                <div class="achievement"><div class="achievement-icon">&#128197;</div><div class="achievement-name">30-Day Streak</div></div>
                                <div class="achievement"><div class="achievement-icon">&#128218;</div><div class="achievement-name">5 Courses</div></div>
                                <div class="achievement"><div class="achievement-icon">&#127908;</div><div class="achievement-name">Perfect Score</div></div>
                            </div>
                        </div>
                    </div>

                </div>
            </div>
        </div>
    </section>

    <style>
        .profile-layout { display:grid;grid-template-columns:280px 1fr;gap:var(--space-6);align-items:start; }
        .profile-sidebar { display:flex;flex-direction:column;gap:var(--space-4); }
        .profile-card { text-align:center; }
        .profile-avatar { width:72px;height:72px;border-radius:50%;background:linear-gradient(135deg,var(--brand-primary),hsl(280,80%,60%));color:#fff;font-size:1.4rem;font-weight:800;display:inline-grid;place-items:center;margin:0 auto var(--space-4);box-shadow:var(--shadow-brand); }
        .profile-name { font-size:1.2rem;margin-bottom:4px; }
        .profile-handle { color:var(--text-muted);font-size:14px;margin-bottom:var(--space-4); }
        .profile-badges { display:flex;flex-wrap:wrap;gap:var(--space-2);justify-content:center;margin-bottom:var(--space-5); }
        .profile-xp { text-align:left; }
        .profile-stats { display:grid;grid-template-columns:1fr 1fr;gap:var(--space-4); }
        .profile-stat { text-align:center; }
        .profile-stat-num { font-size:1.6rem;font-weight:900;font-family:'Plus Jakarta Sans',sans-serif;background:linear-gradient(135deg,var(--brand-primary),hsl(280,80%,60%));-webkit-background-clip:text;-webkit-text-fill-color:transparent;background-clip:text; }
        .profile-stat-label { font-size:12px;font-weight:600;color:var(--text-muted);margin-top:2px; }
        .active-course-list { display:flex;flex-direction:column;gap:var(--space-4); }
        .active-course-item { display:flex;align-items:center;gap:var(--space-4); }
        .active-course-flag { font-size:2rem;flex-shrink:0; }
        .active-course-info { flex:1;min-width:0; }
        .active-course-name { font-weight:700;font-size:15px; }
        .active-course-meta { font-size:13px;color:var(--text-muted);margin-top:2px; }
        .active-course-pct { font-size:13px;font-weight:700;color:var(--brand-primary);flex-shrink:0; }
        .achievement-grid { display:grid;grid-template-columns:repeat(4,1fr);gap:var(--space-4); }
        .achievement { text-align:center;padding:var(--space-4);border-radius:var(--radius-md);background:var(--surface-overlay);opacity:0.4; }
        .achievement.earned { opacity:1; }
        .achievement-icon { font-size:2rem;margin-bottom:var(--space-2); }
        .achievement-name { font-size:12px;font-weight:600;color:var(--text-secondary); }
        @media (max-width:820px) { .profile-layout { grid-template-columns:1fr; } .achievement-grid { grid-template-columns:repeat(4,1fr); } }
        @media (max-width:500px) { .achievement-grid { grid-template-columns:repeat(2,1fr); } .active-course-item { flex-wrap:wrap; } }
    </style>

</asp:Content>
