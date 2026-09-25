<%@ Page Title="Learner Dashboard" Language="C#" MasterPageFile="~/MasterPages/Site.Master" AutoEventWireup="true" CodeBehind="Profile.aspx.cs" Inherits="binary.Users.Profile" %>
<%@ Register Src="~/Controls/NotificationBell.ascx" TagPrefix="bn" TagName="NotificationBell" %>

<asp:Content ID="BodyContent" ContentPlaceHolderID="MainContent" runat="server">

    <asp:HiddenField ID="hfActiveTab" runat="server" Value="tab-dash" />

    <%-- same shell, sidebar and header components as the admin panel (MasterPages/AdminMaster.master) --%>
    <div class="admin-shell">
        <aside class="admin-sidebar">
            <div>
                <a class="admin-sidebar-header" runat="server" href="~/" title="Binary home">
                    <img class="brand-logo" runat="server" src="~/Content/images/logo-mark.png" alt="" />
                    <div>
                        <div class="admin-brand-title">Binary</div>
                        <span class="admin-badge">Learner Hub</span>
                    </div>
                </a>
                <%-- collapses the sidebar to icons only; the state is remembered in localStorage --%>
                <button type="button" class="sidebar-toggle" onclick="BinaryUI.toggleSidebar()" aria-label="Collapse sidebar" title="Collapse sidebar">
                    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" aria-hidden="true"><polyline points="15 18 9 12 15 6"></polyline></svg>
                </button>

                <nav class="admin-sidebar-nav" aria-label="Dashboard">
                    <div class="admin-nav-group">
                        <div class="admin-nav-group-title">Learn</div>
                        <button type="button" id="btnNavDash" data-tab="tab-dash" class="<%= GetNavBtnClass("tab-dash") %>" onclick="switchLearnerTab('tab-dash', this)">
                            <span class="admin-nav-icon"><svg class="admin-icon" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.75" stroke-linecap="round" stroke-linejoin="round"><rect x="3" y="3" width="7" height="9" rx="1.5"></rect><rect x="14" y="3" width="7" height="5" rx="1.5"></rect><rect x="14" y="12" width="7" height="9" rx="1.5"></rect><rect x="3" y="16" width="7" height="5" rx="1.5"></rect></svg></span>
                            <span>Dashboard</span>
                        </button>
                        <button type="button" id="btnNavPractice" data-tab="tab-practice" class="<%= GetNavBtnClass("tab-practice") %>" onclick="switchLearnerTab('tab-practice', this)">
                            <span class="admin-nav-icon"><svg class="admin-icon" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.75" stroke-linecap="round" stroke-linejoin="round"><path d="m3 7 2 2 4-4"></path><path d="m3 15 2 2 4-4"></path><line x1="11" y1="8" x2="21" y2="8"></line><line x1="11" y1="16" x2="21" y2="16"></line></svg></span>
                            <span>Vocabulary Practice</span>
                        </button>
                        <button type="button" id="btnNavExp" data-tab="tab-exp" class="<%= GetNavBtnClass("tab-exp") %>" onclick="switchLearnerTab('tab-exp', this)">
                            <span class="admin-nav-icon"><svg class="admin-icon" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.75" stroke-linecap="round" stroke-linejoin="round"><circle cx="12" cy="8" r="6"></circle><path d="M8.5 13.5 6 22l6-3 6 3-2.5-8.5"></path></svg></span>
                            <span>Exp Earned</span>
                        </button>
                    </div>

                    <div class="admin-nav-group">
                        <div class="admin-nav-group-title">Explore</div>
                        <a class="admin-nav-item" runat="server" href="~/Courses">
                            <span class="admin-nav-icon"><svg class="admin-icon" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.75" stroke-linecap="round" stroke-linejoin="round"><path d="M2 4.5h6a4 4 0 0 1 4 4v11a3 3 0 0 0-3-3H2z"></path><path d="M22 4.5h-6a4 4 0 0 0-4 4v11a3 3 0 0 1 3-3h7z"></path></svg></span>
                            <span>Courses Catalogue</span>
                        </a>
                        <a class="admin-nav-item" runat="server" href="~/Leaderboard">
                            <span class="admin-nav-icon"><svg class="admin-icon" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.75" stroke-linecap="round" stroke-linejoin="round"><path d="M8 21h8"></path><path d="M12 17v4"></path><path d="M7 4h10v5a5 5 0 0 1-10 0V4Z"></path><path d="M7 5H4.5a2.5 2.5 0 0 0 0 5H7"></path><path d="M17 5h2.5a2.5 2.5 0 0 1 0 5H17"></path></svg></span>
                            <span>Leaderboard</span>
                        </a>
                        <a class="admin-nav-item" runat="server" href="~/Users">
                            <span class="admin-nav-icon"><svg class="admin-icon" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.75" stroke-linecap="round" stroke-linejoin="round"><path d="M17 21v-2a4 4 0 0 0-4-4H5a4 4 0 0 0-4 4v2"></path><circle cx="9" cy="7" r="4"></circle><path d="M23 21v-2a4 4 0 0 0-3-3.87"></path><path d="M16 3.13a4 4 0 0 1 0 7.75"></path></svg></span>
                            <span>Community</span>
                        </a>
                    </div>

                    <div class="admin-nav-group">
                        <div class="admin-nav-group-title">Account</div>
                        <button type="button" id="btnNavProfile" data-tab="tab-profile" class="<%= GetNavBtnClass("tab-profile") %>" onclick="switchLearnerTab('tab-profile', this)">
                            <span class="admin-nav-icon"><svg class="admin-icon" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.75" stroke-linecap="round" stroke-linejoin="round"><circle cx="12" cy="12" r="9"></circle><circle cx="12" cy="10" r="3"></circle><path d="M6.5 19a6 6 0 0 1 11 0"></path></svg></span>
                            <span>Profile</span>
                        </button>
                    </div>

                    <div class="admin-nav-group">
                        <div class="admin-nav-group-title">Website</div>
                        <a class="admin-nav-item" runat="server" href="~/">
                            <span class="admin-nav-icon"><svg class="admin-icon" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.75" stroke-linecap="round" stroke-linejoin="round"><path d="m3 9 9-7 9 7v11a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2z"></path><polyline points="9 22 9 12 15 12 15 22"></polyline></svg></span>
                            <span>Home</span>
                        </a>
                        <a class="admin-nav-item" runat="server" href="~/Pages/About.aspx">
                            <span class="admin-nav-icon"><svg class="admin-icon" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.75" stroke-linecap="round" stroke-linejoin="round"><circle cx="12" cy="12" r="9"></circle><line x1="12" y1="16" x2="12" y2="12"></line><line x1="12" y1="8" x2="12.01" y2="8"></line></svg></span>
                            <span>About</span>
                        </a>
                        <a class="admin-nav-item" runat="server" href="~/Pages/Contact.aspx">
                            <span class="admin-nav-icon"><svg class="admin-icon" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.75" stroke-linecap="round" stroke-linejoin="round"><rect x="2" y="4" width="20" height="16" rx="2"></rect><path d="m22 6-10 7L2 6"></path></svg></span>
                            <span>Contact</span>
                        </a>
                    </div>
                </nav>
            </div>

            <div class="admin-sidebar-footer">
                <a class="admin-user-info" href="?tab=profile" title="Your profile"
                   onclick="switchLearnerTab('tab-profile', document.getElementById('btnNavProfile')); return false;">
                    <div class="admin-user-avatar">
                        <asp:Image ID="imgAvatarSidebar" runat="server" CssClass="avatar-img" Visible="false" AlternateText="" />
                        <asp:Literal ID="litAvatar" runat="server">U</asp:Literal>
                    </div>
                    <div class="admin-user-meta">
                        <div class="admin-user-name"><asp:Literal ID="litFullName" runat="server">Learner</asp:Literal></div>
                        <div class="admin-user-role"><asp:Literal ID="litLearnerLevel" runat="server">Beginner</asp:Literal></div>
                    </div>
                </a>
                <a class="admin-logout-btn" runat="server" href="~/Auth/Logout.aspx" title="Sign out" aria-label="Sign out">
                    <svg class="admin-icon" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.75" stroke-linecap="round" stroke-linejoin="round"><path d="M9 21H5a2 2 0 0 1-2-2V5a2 2 0 0 1 2-2h4"></path><polyline points="16 17 21 12 16 7"></polyline><line x1="21" y1="12" x2="9" y2="12"></line></svg>
                </a>
            </div>
        </aside>

        <div class="admin-viewport">
            <header class="admin-global-bar">
                <div class="admin-global-search">
                    <svg class="admin-icon" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.75" stroke-linecap="round" stroke-linejoin="round"><circle cx="11" cy="11" r="8"></circle><line x1="21" y1="21" x2="16.65" y2="16.65"></line></svg>
                    <input type="search" placeholder="Search courses…" autocomplete="off" aria-label="Search courses" data-search-url="<%= ResolveUrl("~/Courses") %>?q=" />
                    <kbd class="search-kbd" title="Press / to search">/</kbd>
                </div>
                <div class="admin-global-actions">
                    <button type="button" class="admin-icon-btn theme-toggle" onclick="BinaryUI.toggleTheme()" aria-label="Switch to dark theme" title="Switch to dark theme">
                        <svg class="admin-icon theme-icon-moon" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.75" stroke-linecap="round" stroke-linejoin="round" aria-hidden="true"><path d="M21 12.79A9 9 0 1 1 11.21 3 7 7 0 0 0 21 12.79z"></path></svg>
                        <svg class="admin-icon theme-icon-sun" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.75" stroke-linecap="round" stroke-linejoin="round" aria-hidden="true"><circle cx="12" cy="12" r="4"></circle><path d="M12 2v2"></path><path d="M12 20v2"></path><path d="m4.93 4.93 1.41 1.41"></path><path d="m17.66 17.66 1.41 1.41"></path><path d="M2 12h2"></path><path d="M20 12h2"></path><path d="m6.34 17.66-1.41 1.41"></path><path d="m19.07 4.93-1.41 1.41"></path></svg>
                    </button>
                    <bn:NotificationBell ID="NotificationBell" runat="server" />
                    <%-- already on this page, so switch tabs in place instead of reloading --%>
                    <a class="admin-global-avatar" href="?tab=profile"
                       title="<%: binary.Core.BLL.AuthBLL.CurrentUserName %> — edit your profile" aria-label="Edit your profile"
                       onclick="switchLearnerTab('tab-profile', document.getElementById('btnNavProfile')); window.scrollTo(0, 0); return false;">
                        <asp:Image ID="imgAvatarHeader" runat="server" CssClass="avatar-img" Visible="false" AlternateText="" />
                        <asp:Literal ID="litHeaderAvatar" runat="server">U</asp:Literal>
                    </a>
                </div>
            </header>

            <header class="admin-topbar">
                <div>
                    <h1 class="dash-page-title" id="dashTitle"><%: GetTabTitle(ActiveTab) %></h1>
                    <p class="dash-page-subtitle" id="dashSubtitle"><%: GetTabSubtitle(ActiveTab) %></p>
                </div>
            </header>

            <main class="admin-content-container">

            <%-- Notifications --%>
            <asp:Panel ID="ProfileAlertPanel" runat="server" CssClass="auth-alert auth-alert-success" Visible="false">
                <asp:Literal ID="litProfileAlert" runat="server" />
            </asp:Panel>
            <asp:Panel ID="ProfileErrorPanel" runat="server" CssClass="auth-alert auth-alert-error" Visible="false">
                <asp:Literal ID="litProfileError" runat="server" />
            </asp:Panel>

            <%-- TAB 1: MAIN DASHBOARD OVERVIEW (every number here comes from the learner's own data) --%>
            <div id="tab-dash" class="<%= GetTabPaneClass("tab-dash") %>">

                <%-- welcome + resume where you left off --%>
                <div class="card dash-welcome">
                    <div class="dash-welcome-text">
                        <h2><span id="dashGreeting">Welcome back</span>, <asp:Literal ID="litGreetingName" runat="server" /></h2>
                        <p>
                            <span class="profile-title-pill"><asp:Literal ID="litGreetingTitle" runat="server" /></span>
                            <span class="dash-streak"><svg class="admin-icon" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.75" stroke-linecap="round" stroke-linejoin="round"><path d="M8.5 14.5A2.5 2.5 0 0 0 11 17a2.5 2.5 0 0 0 2.5-2.5c0-1.38-.5-2-1-3-1.072-2.143-.224-4.054 2-6 .5 2.5 2 4.9 4 6.5 2 1.6 3 3.5 3 5.5a7.5 7.5 0 1 1-15 0c0-1.153.433-2.294 1-3a2.5 2.5 0 0 0 2.5 2.5z"></path></svg><asp:Literal ID="litStreak" runat="server">0</asp:Literal>-day streak</span>
                        </p>
                    </div>
                    <asp:Panel ID="pnlContinue" runat="server" CssClass="dash-continue" Visible="false">
                        <asp:Literal ID="litContinueFlag" runat="server" />
                        <div class="dash-continue-info">
                            <span class="dash-continue-label">Continue where you left off</span>
                            <span class="dash-continue-course"><asp:Literal ID="litContinueCourse" runat="server" /></span>
                            <span class="dash-continue-lesson"><asp:Literal ID="litContinueLesson" runat="server" /></span>
                        </div>
                        <a class="btn btn-primary" id="lnkContinue" runat="server" href="~/Courses"><svg class="ui-icon ui-icon-before" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.75" stroke-linecap="round" stroke-linejoin="round"><polygon points="6 4 20 12 6 20 6 4"></polygon></svg>Resume</a>
                    </asp:Panel>
                    <asp:Panel ID="pnlStartLearning" runat="server" CssClass="dash-continue" Visible="false">
                        <div class="dash-continue-info">
                            <span class="dash-continue-label">Ready for your first course?</span>
                            <span class="dash-continue-course">Pick a language and start earning XP</span>
                        </div>
                        <a class="btn btn-primary" runat="server" href="~/Courses">Browse courses<svg class="ui-icon ui-icon-after" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" aria-hidden="true"><line x1="5" y1="12" x2="19" y2="12"></line><polyline points="12 5 19 12 12 19"></polyline></svg></a>
                    </asp:Panel>
                </div>

                <%-- KPIs --%>
                <div class="saas-kpi-grid">
                    <div class="saas-kpi-card">
                        <div class="saas-kpi-top">
                            <div class="saas-kpi-icon"><svg class="admin-icon" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.75" stroke-linecap="round" stroke-linejoin="round"><path d="M2 4.5h6a4 4 0 0 1 4 4v11a3 3 0 0 0-3-3H2z"></path><path d="M22 4.5h-6a4 4 0 0 0-4 4v11a3 3 0 0 1 3-3h7z"></path></svg></div>
                            <span class="badge badge-primary" style="font-size:11px;"><asp:Literal ID="litInProgressBadge" runat="server">0 in progress</asp:Literal></span>
                        </div>
                        <div>
                            <div class="saas-kpi-val"><asp:Literal ID="litActiveCoursesCount" runat="server">0</asp:Literal></div>
                            <div class="saas-kpi-sub"><span>Enrolled courses</span></div>
                        </div>
                    </div>

                    <div class="saas-kpi-card">
                        <div class="saas-kpi-top">
                            <div class="saas-kpi-icon" style="color:#d97706;background:rgba(245,158,11,0.12);"><svg class="admin-icon" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.75" stroke-linecap="round" stroke-linejoin="round"><polygon points="13 2 3 14 12 14 11 22 21 10 12 10 13 2"></polygon></svg></div>
                            <span class="badge" style="background:rgba(245,158,11,0.15);color:#d97706;font-size:11px;">+<%= binary.Core.BLL.EnrollmentBLL.LessonXpReward %> XP / lesson</span>
                        </div>
                        <div>
                            <div class="saas-kpi-val"><asp:Literal ID="litTotalXp" runat="server">0</asp:Literal></div>
                            <div class="saas-kpi-sub">
                                <span>Total XP</span>
                                <a href="?tab=exp" onclick="switchLearnerTab('tab-exp', document.getElementById('btnNavExp')); return false;" style="color:var(--brand-primary);font-weight:700;">Titles<svg class="ui-icon ui-icon-after" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" aria-hidden="true"><line x1="5" y1="12" x2="19" y2="12"></line><polyline points="12 5 19 12 12 19"></polyline></svg></a>
                            </div>
                        </div>
                    </div>

                    <div class="saas-kpi-card">
                        <div class="saas-kpi-top">
                            <div class="saas-kpi-icon" style="color:#059669;background:rgba(16,185,129,0.12);"><svg class="admin-icon" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.75" stroke-linecap="round" stroke-linejoin="round"><path d="M22 11.08V12a10 10 0 1 1-5.93-9.14"></path><polyline points="22 4 12 14.01 9 11.01"></polyline></svg></div>
                            <span class="badge badge-success" style="font-size:11px;"><asp:Literal ID="litLessonsThisWeekBadge" runat="server">0 this week</asp:Literal></span>
                        </div>
                        <div>
                            <div class="saas-kpi-val"><asp:Literal ID="litCompletedLessonsCount" runat="server">0</asp:Literal></div>
                            <div class="saas-kpi-sub"><span>Lessons completed</span></div>
                        </div>
                    </div>

                    <div class="saas-kpi-card">
                        <div class="saas-kpi-top">
                            <div class="saas-kpi-icon" style="color:#db2777;background:rgba(236,72,153,0.12);"><svg class="admin-icon" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.75" stroke-linecap="round" stroke-linejoin="round"><path d="M8 21h8"></path><path d="M12 17v4"></path><path d="M7 4h10v5a5 5 0 0 1-10 0V4Z"></path><path d="M7 5H4.5a2.5 2.5 0 0 0 0 5H7"></path><path d="M17 5h2.5a2.5 2.5 0 0 1 0 5H17"></path></svg></div>
                            <span class="badge" style="background:rgba(236,72,153,0.15);color:#db2777;font-size:11px;">Leaderboard</span>
                        </div>
                        <div>
                            <div class="saas-kpi-val">#<asp:Literal ID="litRank" runat="server">-</asp:Literal></div>
                            <div class="saas-kpi-sub">
                                <span>Global rank</span>
                                <a runat="server" href="~/Leaderboard" style="color:var(--brand-primary);font-weight:700;">View<svg class="ui-icon ui-icon-after" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" aria-hidden="true"><line x1="5" y1="12" x2="19" y2="12"></line><polyline points="12 5 19 12 12 19"></polyline></svg></a>
                            </div>
                        </div>
                    </div>
                </div>

                <div class="saas-mid-grid">
                    <div class="card card-body" style="background:var(--bg-surface);">
                        <div class="dash-card-head">
                            <div>
                                <h3>This week's activity</h3>
                                <p>Lessons completed per day, last 7 days</p>
                            </div>
                            <span class="badge badge-primary"><asp:Literal ID="litLessonsThisWeek" runat="server">0</asp:Literal> this week</span>
                        </div>
                        <div class="bar-chart-container">
                            <asp:Repeater ID="rptActivityChart" runat="server">
                                <ItemTemplate>
                                    <div class="bar-col">
                                        <%# binary.Core.Helpers.DisplayHelper.GetChartTooltip(Eval("IsToday"), Eval("Count")) %>
                                        <div class="<%# binary.Core.Helpers.DisplayHelper.GetChartBarClass(Eval("IsToday")) %>" style="height:<%# Eval("HeightPercent") %>%;" title='<%# Eval("Count") %> lessons'></div>
                                        <span class="bar-label" style="<%# binary.Core.Helpers.DisplayHelper.GetChartLabelStyle(Eval("IsToday")) %>"><%# Eval("Label") %></span>
                                    </div>
                                </ItemTemplate>
                            </asp:Repeater>
                        </div>
                    </div>

                    <div class="card card-body" style="background:var(--bg-surface);display:flex;flex-direction:column;justify-content:space-between;">
                        <div>
                            <div class="dash-card-head">
                                <div>
                                    <h3>Course progress</h3>
                                    <p>Across all your enrolled courses</p>
                                </div>
                            </div>
                            <div class="segment-bar">
                                <div class="segment-part-green" id="segCompleted" runat="server" title="Completed"></div>
                                <div class="segment-part-purple" id="segInProgress" runat="server" title="In progress"></div>
                                <div class="segment-part-gray" id="segNotStarted" runat="server" title="Not started"></div>
                            </div>
                            <ul class="dash-legend">
                                <li><span class="dash-legend-dot" style="background:#34d399;"></span>Completed <strong><asp:Literal ID="litCountCompleted" runat="server">0</asp:Literal></strong></li>
                                <li><span class="dash-legend-dot" style="background:#818cf8;"></span>In progress <strong><asp:Literal ID="litCountInProgress" runat="server">0</asp:Literal></strong></li>
                                <li><span class="dash-legend-dot" style="background:#cbd5e1;"></span>Not started <strong><asp:Literal ID="litCountNotStarted" runat="server">0</asp:Literal></strong></li>
                            </ul>
                        </div>
                        <div style="margin-top:var(--space-4);padding-top:var(--space-3);border-top:1px solid var(--border-light);">
                            <a class="btn btn-outline" runat="server" href="~/Courses" style="width:100%;height:38px;font-size:13px;"><svg class="ui-icon ui-icon-before" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" aria-hidden="true"><line x1="12" y1="5" x2="12" y2="19"></line><line x1="5" y1="12" x2="19" y2="12"></line></svg>Enroll in more courses</a>
                        </div>
                    </div>
                </div>

                <%-- enrolled courses --%>
                <div class="card" style="box-shadow:var(--shadow-card);background:var(--bg-surface);">
                    <div class="card-header dash-card-head" style="background:var(--bg-surface);margin:0;">
                        <div>
                            <h3>My courses</h3>
                            <p>Pick up any course where you left off</p>
                        </div>
                        <a class="btn btn-outline" runat="server" href="~/Courses" style="height:32px;font-size:12px;padding:0 12px;">Browse catalogue<svg class="ui-icon ui-icon-after" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" aria-hidden="true"><line x1="5" y1="12" x2="19" y2="12"></line><polyline points="12 5 19 12 12 19"></polyline></svg></a>
                    </div>
                    <asp:Panel ID="pnlEnrollmentFilter" runat="server" CssClass="seg-filter" role="tablist" aria-label="Filter courses">
                        <button type="button" class="seg-filter-btn is-active" data-status="all" onclick="filterEnrollments(this)">All <span><asp:Literal ID="litCountAll" runat="server" /></span></button>
                        <button type="button" class="seg-filter-btn" data-status="progress" onclick="filterEnrollments(this)">In progress <span><asp:Literal ID="litCountProgress" runat="server" /></span></button>
                        <button type="button" class="seg-filter-btn" data-status="new" onclick="filterEnrollments(this)">Not started <span><asp:Literal ID="litCountNew" runat="server" /></span></button>
                        <button type="button" class="seg-filter-btn" data-status="done" onclick="filterEnrollments(this)">Completed <span><asp:Literal ID="litCountDone" runat="server" /></span></button>
                    </asp:Panel>
                    <div style="overflow-x:auto;">
                        <table class="admin-table" id="enrollmentTable">
                            <thead>
                                <tr><th>Course</th><th>Progress</th><th>Status</th><th style="text-align:right;">Action</th></tr>
                            </thead>
                            <tbody>
                                <asp:Repeater ID="rptEnrollments" runat="server">
                                    <ItemTemplate>
                                        <tr data-status="<%# GetEnrollmentStatusKey(Eval("ProgressPercent")) %>">
                                            <td>
                                                <div style="display:flex;align-items:center;gap:12px;">
                                                    <%# binary.Core.Helpers.FlagHelper.Render((string)Eval("CourseFlagUrl"), (string)Eval("CourseTitle"), "flag-md") %>
                                                    <div>
                                                        <div style="font-weight:700;color:var(--text-primary);"><%# HttpUtility.HtmlEncode((string)Eval("CourseTitle")) %></div>
                                                        <div style="font-size:12px;color:var(--text-muted);"><%# HttpUtility.HtmlEncode((string)Eval("CourseLevel")) %> &bull; +<%# binary.Core.BLL.EnrollmentBLL.LessonXpReward %> XP per lesson</div>
                                                    </div>
                                                </div>
                                            </td>
                                            <td style="min-width:180px;">
                                                <div style="display:flex;align-items:center;gap:8px;">
                                                    <div class="progress" style="height:6px;flex:1;"><div class="progress-bar" style="width:<%# Eval("ProgressPercent") %>%;background:#10b981;"></div></div>
                                                    <span style="font-size:12px;font-weight:700;color:var(--text-secondary);"><%# Eval("ProgressPercent") %>%</span>
                                                </div>
                                            </td>
                                            <td><%# GetEnrollmentStatusBadge(Eval("ProgressPercent")) %></td>
                                            <td style="text-align:right;">
                                                <a class="btn btn-primary" href='<%# ResolveUrl("~/Courses/Detail.aspx?id=" + Eval("CourseID")) %>' style="height:32px;font-size:12.5px;padding:0 14px;"><%# (int)Eval("ProgressPercent") >= 100 ? "Review" : ((int)Eval("ProgressPercent") == 0 ? "Start" : "Resume") %><svg class="ui-icon ui-icon-after" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" aria-hidden="true"><line x1="5" y1="12" x2="19" y2="12"></line><polyline points="12 5 19 12 12 19"></polyline></svg></a>
                                            </td>
                                        </tr>
                                    </ItemTemplate>
                                </asp:Repeater>
                            </tbody>
                        </table>
                        <p class="seg-filter-empty" id="enrollmentFilterEmpty" hidden>No courses in this group.</p>
                        <asp:Panel ID="pnlNoEnrollments" runat="server" Visible="false" CssClass="dash-empty">
                            <div class="dash-empty-icon"><svg class="admin-icon" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.75" stroke-linecap="round" stroke-linejoin="round"><path d="M2 4.5h6a4 4 0 0 1 4 4v11a3 3 0 0 0-3-3H2z"></path><path d="M22 4.5h-6a4 4 0 0 0-4 4v11a3 3 0 0 1 3-3h7z"></path></svg></div>
                            <h4>No courses yet</h4>
                            <p>Enroll in Spanish, French, Japanese, and more to start earning XP.</p>
                            <a class="btn btn-primary" runat="server" href="~/Courses">Browse courses<svg class="ui-icon ui-icon-after" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" aria-hidden="true"><line x1="5" y1="12" x2="19" y2="12"></line><polyline points="12 5 19 12 12 19"></polyline></svg></a>
                        </asp:Panel>
                    </div>
                </div>

            </div>

            <%-- TAB: VOCABULARY PRACTICE --%>
            <div id="tab-practice" class="<%= GetTabPaneClass("tab-practice") %>">

                <asp:Panel ID="pnlQuizList" runat="server">
                    <div class="admin-section-label">Your quizzes</div>
                    <div class="quiz-list">
                        <asp:Repeater ID="rptQuizzes" runat="server" OnItemCommand="rptQuizzes_ItemCommand">
                            <ItemTemplate>
                                <div class="quiz-card">
                                    <div class="quiz-card-head">
                                        <%# binary.Core.Helpers.FlagHelper.Render((string)Eval("CourseFlagUrl"), (string)Eval("CourseTitle"), "flag-md") %>
                                        <div class="quiz-card-text">
                                            <h3><%# HttpUtility.HtmlEncode((string)Eval("Title")) %></h3>
                                            <p><%# HttpUtility.HtmlEncode((string)Eval("CourseTitle") + (Eval("LessonTitle") == null ? "" : " · " + Eval("LessonTitle"))) %></p>
                                        </div>
                                    </div>
                                    <div class="quiz-card-meta">
                                        <span><%# Eval("QuestionCount") %> questions</span>
                                        <span><%# GetBestScoreText((int)Eval("QuizID")) %></span>
                                    </div>
                                    <asp:LinkButton runat="server" CssClass="btn btn-primary quiz-card-btn" CommandName="StartQuiz" CommandArgument='<%# Eval("QuizID") %>'><%# HasAttempted((int)Eval("QuizID")) ? "Retake quiz" : "Start quiz" %></asp:LinkButton>
                                </div>
                            </ItemTemplate>
                        </asp:Repeater>
                    </div>
                    <asp:Panel ID="pnlNoQuizzes" runat="server" Visible="false" CssClass="quiz-empty">
                        <h4>No quizzes yet</h4>
                        <p>Enrol in a course and its quiz will show up here.</p>
                        <a runat="server" href="~/Courses" class="btn btn-outline">Browse courses</a>
                    </asp:Panel>

                    <div class="card" style="background:var(--bg-surface);">
                        <div class="card-header"><h3 style="font-size:1.05rem;">Recent attempts</h3></div>
                        <div style="overflow-x:auto;">
                            <table class="admin-table">
                                <thead><tr><th>Quiz</th><th>Score</th><th>Result</th><th>Date</th></tr></thead>
                                <tbody>
                                    <asp:Repeater ID="rptAttempts" runat="server">
                                        <ItemTemplate>
                                            <tr>
                                                <td style="font-weight:700;color:var(--text-primary);"><%# HttpUtility.HtmlEncode((string)Eval("QuizTitle")) %></td>
                                                <td><%# Eval("Score") %>/<%# Eval("MaxScore") %></td>
                                                <td><%# GetScoreBadge((int)Eval("Score"), (int)Eval("MaxScore")) %></td>
                                                <td style="color:var(--text-muted);"><%# Eval("AttemptDate", "{0:MMM d, yyyy}") %></td>
                                            </tr>
                                        </ItemTemplate>
                                    </asp:Repeater>
                                </tbody>
                            </table>
                        </div>
                        <asp:Panel ID="pnlNoAttempts" runat="server" Visible="false" style="text-align:center;color:var(--text-muted);padding:var(--space-6) var(--space-4);font-size:13px;">
                            No attempts yet. Your scores will be listed here.
                        </asp:Panel>
                    </div>
                </asp:Panel>

                <asp:Panel ID="pnlQuizPlay" runat="server" Visible="false">
                    <div class="quiz-play">
                        <div class="quiz-play-head">
                            <asp:Literal ID="litPlayQuizFlag" runat="server" />
                            <div class="quiz-card-text">
                                <h3><asp:Literal ID="litPlayQuizTitle" runat="server" /></h3>
                                <p><asp:Literal ID="litPlayQuizCourse" runat="server" /></p>
                            </div>
                            <span class="quiz-progress-text" id="quizProgressText"></span>
                        </div>
                        <div class="quiz-progress"><div class="quiz-progress-fill" id="quizProgressFill"></div></div>

                        <asp:HiddenField ID="hfPlayQuizId" runat="server" />
                        <asp:Repeater ID="rptQuestions" runat="server">
                            <ItemTemplate>
                                <fieldset class="quiz-question-card">
                                    <legend class="quiz-question-num">Question <%# Container.ItemIndex + 1 %></legend>
                                    <p class="quiz-question-text"><%# HttpUtility.HtmlEncode((string)Eval("QuestionText")) %></p>
                                    <asp:HiddenField runat="server" ID="hfQuestionId" Value='<%# Eval("QuestionID") %>' />
                                    <asp:RadioButtonList runat="server" ID="rblOptions" DataSource='<%# Eval("Options") %>' DataTextField="OptionText" DataValueField="OptionID" RepeatLayout="UnorderedList" CssClass="quiz-options" />
                                </fieldset>
                            </ItemTemplate>
                        </asp:Repeater>

                        <div class="quiz-play-actions">
                            <asp:LinkButton ID="lnkCancelQuiz" runat="server" CssClass="btn btn-outline" Text="Cancel" OnClick="lnkCancelQuiz_Click" CausesValidation="false" />
                            <asp:Button ID="btnSubmitQuiz" runat="server" CssClass="btn btn-primary" Text="Submit answers" OnClick="btnSubmitQuiz_Click" OnClientClick="return confirmQuizSubmit(this);" />
                        </div>
                    </div>
                </asp:Panel>

                <asp:Panel ID="pnlQuizResult" runat="server" Visible="false">
                    <div class="quiz-play">
                        <div class="quiz-result-summary">
                            <div class="quiz-result-badge"><asp:Literal ID="litResultIcon" runat="server" /></div>
                            <div>
                                <h3><asp:Literal ID="litResultScore" runat="server" /></h3>
                                <p><asp:Literal ID="litResultMessage" runat="server" /></p>
                                <asp:Panel ID="pnlResultXp" runat="server" CssClass="quiz-result-xp">+<asp:Literal ID="litResultXp" runat="server" /> XP</asp:Panel>
                            </div>
                        </div>

                        <div class="admin-section-label" style="margin-top:var(--space-6);">Your answers</div>
                        <ol class="quiz-review">
                            <asp:Repeater ID="rptReview" runat="server">
                                <ItemTemplate>
                                    <li class='<%# (bool)Eval("IsCorrect") ? "quiz-review-item is-correct" : "quiz-review-item is-wrong" %>'>
                                        <span class="quiz-review-mark"><%# binary.Core.Helpers.Icons.Svg((bool)Eval("IsCorrect") ? "check" : "x") %></span>
                                        <div>
                                            <p class="quiz-review-question"><%# Eval("Number") %>. <%# HttpUtility.HtmlEncode((string)Eval("QuestionText")) %></p>
                                            <p class="quiz-review-answer">Your answer: <strong><%# HttpUtility.HtmlEncode((string)Eval("YourAnswer") ?? "Not answered") %></strong></p>
                                            <asp:PlaceHolder runat="server" Visible='<%# !(bool)Eval("IsCorrect") %>'>
                                                <p class="quiz-review-answer">Correct answer: <strong><%# HttpUtility.HtmlEncode((string)Eval("CorrectAnswer")) %></strong></p>
                                            </asp:PlaceHolder>
                                        </div>
                                    </li>
                                </ItemTemplate>
                            </asp:Repeater>
                        </ol>

                        <div class="quiz-play-actions">
                            <asp:LinkButton ID="lnkBackToList" runat="server" CssClass="btn btn-outline" Text="Back to quizzes" OnClick="lnkBackToList_Click" />
                            <asp:LinkButton ID="lnkRetryQuiz" runat="server" CssClass="btn btn-primary" Text="Try again" OnClick="lnkRetryQuiz_Click" />
                        </div>
                    </div>
                </asp:Panel>

            </div>

            <%-- TAB 2: PROFILE (details, picture, title and password in one place) --%>
            <div id="tab-profile" class="<%= GetTabPaneClass("tab-profile") %>">

                <div class="card profile-hero">
                    <div class="profile-hero-avatar" id="profileHeroAvatar">
                        <asp:Image ID="imgAvatarPreview" runat="server" CssClass="avatar-img" Visible="false" AlternateText="" />
                        <asp:Literal ID="litAvatarPreview" runat="server">U</asp:Literal>
                    </div>
                    <div class="profile-hero-info">
                        <h2 class="profile-hero-name"><asp:Literal ID="litProfileName" runat="server" /></h2>
                        <div class="profile-hero-meta">
                            <span class="profile-title-pill"><asp:Literal ID="litProfileTitle" runat="server" /></span>
                            <span><asp:Literal ID="litProfileEmail" runat="server" /></span>
                            <span>Member since <asp:Literal ID="litMemberSince" runat="server" /></span>
                            <asp:Literal ID="litOnboardingInfo" runat="server" />
                        </div>
                        <div class="profile-title-row">
                            <span class="profile-title-hint"><asp:Literal ID="litProfileTitleHint" runat="server" /></span>
                            <a href="?tab=exp" class="profile-title-link" onclick="switchLearnerTab('tab-exp', document.getElementById('btnNavExp')); return false;">View all titles<svg class="ui-icon ui-icon-after" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" aria-hidden="true"><line x1="5" y1="12" x2="19" y2="12"></line><polyline points="12 5 19 12 12 19"></polyline></svg></a>
                        </div>
                    </div>
                </div>

                <div class="profile-grid">
                    <div class="card profile-card">
                        <div class="card-header">
                            <h3>Personal details</h3>
                            <p>Your name and picture appear on the leaderboard and community pages.</p>
                        </div>
                        <div class="card-body">
                            <div class="form-group">
                                <label class="form-label" for="<%= fuAvatar.ClientID %>">Profile picture</label>
                                <asp:FileUpload ID="fuAvatar" runat="server" accept="image/jpeg,image/png,image/gif,image/webp" data-drop-label="Choose a picture or drag it here" data-max-mb="2" onchange="previewAvatar(this)" />
                                <p class="form-hint" id="avatarHint">JPG, PNG, GIF, or WEBP · max 2 MB. The preview updates right away; press Save to keep it.</p>
                            </div>
                            <div class="grid-2">
                                <div class="form-group">
                                    <label class="form-label" for="<%= txtFirstName.ClientID %>">First name</label>
                                    <asp:TextBox ID="txtFirstName" runat="server" CssClass="form-control" placeholder="First name" />
                                    <asp:RequiredFieldValidator ID="rfvFirst" runat="server" ControlToValidate="txtFirstName" ValidationGroup="ProfileGroup" CssClass="field-error" ErrorMessage="First name is required." Display="Dynamic" />
                                </div>
                                <div class="form-group">
                                    <label class="form-label" for="<%= txtLastName.ClientID %>">Last name</label>
                                    <asp:TextBox ID="txtLastName" runat="server" CssClass="form-control" placeholder="Last name" />
                                    <asp:RequiredFieldValidator ID="rfvLast" runat="server" ControlToValidate="txtLastName" ValidationGroup="ProfileGroup" CssClass="field-error" ErrorMessage="Last name is required." Display="Dynamic" />
                                </div>
                            </div>
                            <div class="form-group">
                                <label class="form-label" for="<%= txtEmail.ClientID %>">Email address</label>
                                <asp:TextBox ID="txtEmail" runat="server" CssClass="form-control" ReadOnly="true" style="background:var(--bg-overlay);color:var(--text-muted);cursor:not-allowed;" />
                                <p class="form-hint">Your sign-in email can't be changed here. Contact support if you need it updated.</p>
                            </div>
                            <asp:Button ID="btnSaveProfile" runat="server" CssClass="btn btn-primary" Text="Save changes" ValidationGroup="ProfileGroup" OnClick="btnSaveProfile_Click" />
                        </div>
                    </div>

                    <div class="card profile-card" id="password-section">
                        <div class="card-header">
                            <h3>Password</h3>
                            <p>Use at least 8 characters. You'll get a notification whenever it changes.</p>
                        </div>
                        <div class="card-body">
                            <div class="form-group">
                                <label class="form-label" for="<%= txtCurrentPassword.ClientID %>">Current password</label>
                                <asp:TextBox ID="txtCurrentPassword" runat="server" CssClass="form-control" TextMode="Password" placeholder="Enter current password" autocomplete="current-password" />
                                <asp:RequiredFieldValidator ID="rfvCurrent" runat="server" ControlToValidate="txtCurrentPassword" ValidationGroup="PasswordGroup" CssClass="field-error" ErrorMessage="Current password is required." Display="Dynamic" />
                            </div>
                            <div class="form-group">
                                <label class="form-label" for="<%= txtNewPassword.ClientID %>">New password</label>
                                <asp:TextBox ID="txtNewPassword" runat="server" CssClass="form-control" TextMode="Password" placeholder="Min. 8 characters" autocomplete="new-password" />
                                <asp:RequiredFieldValidator ID="rfvNew" runat="server" ControlToValidate="txtNewPassword" ValidationGroup="PasswordGroup" CssClass="field-error" ErrorMessage="New password is required." Display="Dynamic" />
                            </div>
                            <div class="form-group">
                                <label class="form-label" for="<%= txtConfirmNewPassword.ClientID %>">Confirm new password</label>
                                <asp:TextBox ID="txtConfirmNewPassword" runat="server" CssClass="form-control" TextMode="Password" placeholder="Repeat new password" autocomplete="new-password" />
                                <asp:CompareValidator ID="cvNewPass" runat="server" ControlToValidate="txtConfirmNewPassword" ControlToCompare="txtNewPassword" ValidationGroup="PasswordGroup" CssClass="field-error" ErrorMessage="Passwords do not match." Display="Dynamic" />
                            </div>
                            <asp:Button ID="btnChangePassword" runat="server" CssClass="btn btn-outline" Text="Update password" ValidationGroup="PasswordGroup" OnClick="btnChangePassword_Click" />
                        </div>
                    </div>
                </div>
            </div>

            <%-- TAB 4: EXP EARNED --%>
            <div id="tab-exp" class="<%= GetTabPaneClass("tab-exp") %>">
                <div class="card card-body exp-summary">
                    <div class="exp-summary-title">
                        <span class="exp-summary-icon"><asp:Literal ID="litExpTitleIcon" runat="server" /></span>
                        <div>
                            <div class="exp-summary-label">Current title</div>
                            <div class="exp-summary-name"><asp:Literal ID="litExpTitleName" runat="server" /></div>
                        </div>
                    </div>
                    <div class="exp-summary-progress">
                        <div class="exp-summary-numbers">
                            <span><strong><asp:Literal ID="litExpTotal" runat="server">0</asp:Literal></strong> XP earned</span>
                            <span><asp:Literal ID="litExpToNext" runat="server" /></span>
                        </div>
                        <div class="progress" style="height:8px;"><div class="progress-bar" id="expProgressBar" runat="server" style="background:#f59e0b;"></div></div>
                    </div>
                </div>

                <div class="exp-tier-grid">
                    <asp:Repeater ID="rptTitles" runat="server">
                        <ItemTemplate>
                            <div class="card card-body exp-tier <%# Eval("StateClass") %>">
                                <div class="exp-tier-icon"><%# Eval("IconHtml") %></div>
                                <h4><%# Eval("Name") %></h4>
                                <p class="exp-tier-range"><%# Eval("RangeText") %></p>
                                <p class="exp-tier-desc"><%# Eval("Description") %></p>
                                <span class="badge <%# Eval("BadgeClass") %>"><%# Eval("BadgeText") %></span>
                            </div>
                        </ItemTemplate>
                    </asp:Repeater>
                </div>
            </div>

            </main>
        </div>
    </div>

    <script>
        // instant preview of a newly chosen picture (saved only when the learner presses Save)
        function previewAvatar(input) {
            var hint = document.getElementById('avatarHint');
            var file = input.files && input.files[0];
            if (!file) return;
            if (!/^image\/(jpeg|png|gif|webp)$/.test(file.type) || file.size > 2 * 1024 * 1024) {
                hint.textContent = 'Please choose a JPG, PNG, GIF, or WEBP image up to 2 MB.';
                hint.classList.add('text-danger');
                input.value = '';
                return;
            }
            hint.classList.remove('text-danger');
            hint.textContent = 'New picture ready — press Save changes to keep it.';
            var img = document.createElement('img');
            img.className = 'avatar-img';
            img.alt = '';
            img.src = URL.createObjectURL(file);
            var box = document.getElementById('profileHeroAvatar');
            box.innerHTML = '';
            box.appendChild(img);
        }

        // old "Password" links (e.g. in earlier notifications) land on the Profile tab's password card
        if (/[?&]tab=security\b/.test(window.location.search)) {
            var pw = document.getElementById('password-section');
            if (pw) pw.scrollIntoView({ block: 'start' });
        }

        // My courses: show only the rows in the chosen status group
        function filterEnrollments(btn) {
            var status = btn.getAttribute('data-status');
            var buttons = btn.parentNode.querySelectorAll('.seg-filter-btn');
            for (var i = 0; i < buttons.length; i++) {
                buttons[i].classList.toggle('is-active', buttons[i] === btn);
                buttons[i].setAttribute('aria-selected', buttons[i] === btn ? 'true' : 'false');
            }
            var rows = document.querySelectorAll('#enrollmentTable tbody tr');
            var shown = 0;
            for (var j = 0; j < rows.length; j++) {
                var match = status === 'all' || rows[j].getAttribute('data-status') === status;
                rows[j].hidden = !match;
                if (match) shown++;
            }
            document.getElementById('enrollmentFilterEmpty').hidden = shown > 0;
        }

        // quiz: highlight the picked option and keep the "answered" count current
        (function () {
            var cards = document.querySelectorAll('.quiz-question-card');
            if (!cards.length) return;
            var text = document.getElementById('quizProgressText');
            var fill = document.getElementById('quizProgressFill');

            function refresh() {
                var answered = 0;
                for (var i = 0; i < cards.length; i++) {
                    var items = cards[i].querySelectorAll('.quiz-options li');
                    var picked = false;
                    for (var j = 0; j < items.length; j++) {
                        var on = items[j].querySelector('input').checked;
                        items[j].classList.toggle('is-selected', on);
                        if (on) picked = true;
                    }
                    if (picked) answered++;
                }
                if (text) text.textContent = answered + ' of ' + cards.length + ' answered';
                if (fill) fill.style.width = Math.round(answered * 100 / cards.length) + '%';
            }

            document.addEventListener('change', function (e) {
                if (e.target.closest && e.target.closest('.quiz-options')) refresh();
            });
            refresh();
        })();

        // unanswered questions are scored as wrong, so check before submitting
        function confirmQuizSubmit(btn) {
            var cards = document.querySelectorAll('.quiz-question-card');
            var unanswered = 0;
            for (var i = 0; i < cards.length; i++) {
                if (!cards[i].querySelector('input[type="radio"]:checked')) unanswered++;
            }
            if (unanswered === 0) return true;
            return BinaryUI.confirm(btn, {
                title: 'Submit with ' + unanswered + (unanswered === 1 ? ' question' : ' questions') + ' unanswered?',
                text: 'Unanswered questions are marked wrong.',
                ok: 'Submit anyway',
                danger: false
            });
        }

        var TAB_TITLES = <%= GetTabTitlesJson() %>;

        // greeting in the learner's own time zone, not the server's
        (function () {
            var el = document.getElementById('dashGreeting');
            if (!el) return;
            var h = new Date().getHours();
            el.textContent = h < 12 ? 'Good morning' : h < 18 ? 'Good afternoon' : 'Good evening';
        })();

        function switchLearnerTab(tabId, btn) {
            document.querySelectorAll('.tab-pane').forEach(function(pane) {
                pane.classList.remove('active');
            });
            document.querySelectorAll('.admin-sidebar [data-tab]').forEach(function(b) {
                b.classList.toggle('active', b.getAttribute('data-tab') === tabId);
            });
            var target = document.getElementById(tabId);
            if (target) {
                target.classList.add('active');
            }
            var titles = TAB_TITLES[tabId];
            if (titles) {
                document.getElementById('dashTitle').textContent = titles[0];
                document.getElementById('dashSubtitle').textContent = titles[1];
            }
            var hiddenField = document.getElementById('<%= hfActiveTab.ClientID %>');
            if (hiddenField) {
                hiddenField.value = tabId;
            }

            // keep ?tab= in sync (read server-side by ApplyRequestedTab) so a refresh stays on this tab
            if (window.history && history.replaceState) {
                var url = new URL(window.location.href);
                url.searchParams.set('tab', tabId.replace('tab-', ''));
                history.replaceState(null, '', url.toString());
                // postbacks land on the form's action URL, so keep it matching too
                document.forms[0].action = url.pathname + url.search;
            }
        }
    </script>

</asp:Content>
