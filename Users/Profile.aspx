<%@ Page Title="Learner Dashboard" Language="C#" MasterPageFile="~/MasterPages/Site.Master" AutoEventWireup="true" CodeBehind="Profile.aspx.cs" Inherits="binary.Users.Profile" %>
<%@ Register Src="~/Controls/NotificationBell.ascx" TagPrefix="bn" TagName="NotificationBell" %>

<asp:Content ID="BodyContent" ContentPlaceHolderID="MainContent" runat="server">

    <asp:HiddenField ID="hfActiveTab" runat="server" Value="tab-dash" />

    <div class="learner-shell">
        <%-- Vertical Left Navigation Sidebar --%>
        <aside class="learner-sidebar">
            <div>
                <%-- User Profile Card --%>
                <div class="learner-user-card">
                    <div class="learner-user-avatar">
                        <asp:Image ID="imgAvatarSidebar" runat="server" CssClass="avatar-img" Visible="false" AlternateText="" />
                        <asp:Literal ID="litAvatar" runat="server">U</asp:Literal>
                    </div>
                    <div style="min-width:0;flex:1;">
                        <div style="font-size:13.5px;font-weight:800;color:var(--text-primary);white-space:nowrap;overflow:hidden;text-overflow:ellipsis;">
                            <asp:Literal ID="litFullName" runat="server">Learner Name</asp:Literal>
                        </div>
                        <div style="font-size:11px;color:var(--text-muted);font-weight:600;">
                            <asp:Literal ID="litLearnerLevel" runat="server">🌱 Beginner</asp:Literal>
                        </div>
                    </div>
                </div>

                <%-- GENERAL --%>
                <div class="learner-nav-group">
                    <div class="learner-group-title">General</div>
                    <button type="button" id="btnNavDash" class="<%= GetNavBtnClass("tab-dash") %>" onclick="switchLearnerTab('tab-dash', this)">
                        <span class="admin-nav-icon"><svg class="admin-icon" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.75" stroke-linecap="round" stroke-linejoin="round"><rect x="3" y="3" width="7" height="9" rx="1.5"></rect><rect x="14" y="3" width="7" height="5" rx="1.5"></rect><rect x="14" y="12" width="7" height="9" rx="1.5"></rect><rect x="3" y="16" width="7" height="5" rx="1.5"></rect></svg></span>
                        <span>Dashboard</span>
                    </button>
                    <button type="button" id="btnNavPractice" class="<%= GetNavBtnClass("tab-practice") %>" onclick="switchLearnerTab('tab-practice', this)">
                        <span class="admin-nav-icon"><svg class="admin-icon" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.75" stroke-linecap="round" stroke-linejoin="round"><path d="m3 7 2 2 4-4"></path><path d="m3 15 2 2 4-4"></path><line x1="11" y1="8" x2="21" y2="8"></line><line x1="11" y1="16" x2="21" y2="16"></line></svg></span>
                        <span>Vocabulary Practice</span>
                    </button>
                    <a class="learner-nav-btn" runat="server" href="~/Courses">
                        <span class="admin-nav-icon"><svg class="admin-icon" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.75" stroke-linecap="round" stroke-linejoin="round"><path d="M2 4.5h6a4 4 0 0 1 4 4v11a3 3 0 0 0-3-3H2z"></path><path d="M22 4.5h-6a4 4 0 0 0-4 4v11a3 3 0 0 1 3-3h7z"></path></svg></span>
                        <span>Courses Catalogue</span>
                    </a>
                    <a class="learner-nav-btn" runat="server" href="~/Leaderboard">
                        <span class="admin-nav-icon"><svg class="admin-icon" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.75" stroke-linecap="round" stroke-linejoin="round"><path d="M8 21h8"></path><path d="M12 17v4"></path><path d="M7 4h10v5a5 5 0 0 1-10 0V4Z"></path><path d="M7 5H4.5a2.5 2.5 0 0 0 0 5H7"></path><path d="M17 5h2.5a2.5 2.5 0 0 1 0 5H17"></path></svg></span>
                        <span>Global Leaderboard</span>
                    </a>
                </div>

                <%-- SITE --%>
                <div class="learner-nav-group">
                    <div class="learner-group-title">Site</div>
                    <a class="learner-nav-btn" runat="server" href="~/">
                        <span class="admin-nav-icon"><svg class="admin-icon" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.75" stroke-linecap="round" stroke-linejoin="round"><path d="m3 9 9-7 9 7v11a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2z"></path><polyline points="9 22 9 12 15 12 15 22"></polyline></svg></span>
                        <span>Home</span>
                    </a>
                    <a class="learner-nav-btn" runat="server" href="~/Pages/About.aspx">
                        <span class="admin-nav-icon"><svg class="admin-icon" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.75" stroke-linecap="round" stroke-linejoin="round"><circle cx="12" cy="12" r="9"></circle><line x1="12" y1="16" x2="12" y2="12"></line><line x1="12" y1="8" x2="12.01" y2="8"></line></svg></span>
                        <span>About</span>
                    </a>
                    <a class="learner-nav-btn" runat="server" href="~/Pages/Contact.aspx">
                        <span class="admin-nav-icon"><svg class="admin-icon" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.75" stroke-linecap="round" stroke-linejoin="round"><rect x="2" y="4" width="20" height="16" rx="2"></rect><path d="m22 6-10 7L2 6"></path></svg></span>
                        <span>Contact</span>
                    </a>
                    <% if (binary.Core.BLL.AuthBLL.IsAdmin) { %>
                    <a class="learner-nav-btn" runat="server" href="~/Admin">
                        <span class="admin-nav-icon"><svg class="admin-icon" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.75" stroke-linecap="round" stroke-linejoin="round"><path d="M12 2 4 5v6c0 5 3.5 9 8 11 4.5-2 8-6 8-11V5z"></path><path d="m9 12 2 2 4-4"></path></svg></span>
                        <span>Admin Panel</span>
                    </a>
                    <% } %>
                </div>

                <%-- ACCOUNT & SETTINGS --%>
                <div class="learner-nav-group">
                    <div class="learner-group-title">Account & Profile</div>
                    <button type="button" id="btnNavProfile" class="<%= GetNavBtnClass("tab-profile") %>" onclick="switchLearnerTab('tab-profile', this)">
                        <span class="admin-nav-icon"><svg class="admin-icon" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.75" stroke-linecap="round" stroke-linejoin="round"><circle cx="12" cy="12" r="9"></circle><circle cx="12" cy="10" r="3"></circle><path d="M6.5 19a6 6 0 0 1 11 0"></path></svg></span>
                        <span>Profile</span>
                    </button>
                    <button type="button" id="btnNavSecurity" class="<%= GetNavBtnClass("tab-security") %>" onclick="switchLearnerTab('tab-security', this)">
                        <span class="admin-nav-icon"><svg class="admin-icon" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.75" stroke-linecap="round" stroke-linejoin="round"><rect x="4" y="11" width="16" height="10" rx="2"></rect><path d="M8 11V7a4 4 0 0 1 8 0v4"></path></svg></span>
                        <span>Password</span>
                    </button>
                    <button type="button" id="btnNavExp" class="<%= GetNavBtnClass("tab-exp") %>" onclick="switchLearnerTab('tab-exp', this)">
                        <span class="admin-nav-icon"><svg class="admin-icon" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.75" stroke-linecap="round" stroke-linejoin="round"><circle cx="12" cy="8" r="6"></circle><path d="M8.5 13.5 6 22l6-3 6 3-2.5-8.5"></path></svg></span>
                        <span>Exp Earned</span>
                    </button>
                </div>
            </div>

            <%-- BOTTOM SIGN OUT --%>
            <div>
                <a class="learner-nav-btn" runat="server" href="~/Auth/Logout.aspx" style="color:var(--brand-rose);">
                    <span class="admin-nav-icon"><svg class="admin-icon" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.75" stroke-linecap="round" stroke-linejoin="round"><path d="M9 21H5a2 2 0 0 1-2-2V5a2 2 0 0 1 2-2h4"></path><polyline points="16 17 21 12 16 7"></polyline><line x1="21" y1="12" x2="9" y2="12"></line></svg></span>
                    <span>Sign Out</span>
                </a>
            </div>
        </aside>

        <%-- Main Dashboard Viewport --%>
        <main class="learner-viewport">

            <%-- Global Header: search + notifications + profile --%>
            <header class="admin-global-bar dash-global-bar">
                <div class="admin-global-search">
                    <svg class="admin-icon" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.75" stroke-linecap="round" stroke-linejoin="round"><circle cx="11" cy="11" r="8"></circle><line x1="21" y1="21" x2="16.65" y2="16.65"></line></svg>
                    <input type="search" placeholder="Search lessons, courses…" autocomplete="off" />
                </div>
                <div class="admin-global-actions">
                    <bn:NotificationBell ID="NotificationBell" runat="server" />
                    <%-- already on this page, so switch tabs in place instead of reloading --%>
                    <a class="admin-global-avatar" href="?tab=profile" style="text-decoration:none;color:inherit;"
                       title="<%: binary.Core.BLL.AuthBLL.CurrentUserName %> — edit your profile" aria-label="Edit your profile"
                       onclick="switchLearnerTab('tab-profile', document.getElementById('btnNavProfile')); window.scrollTo(0, 0); return false;">
                        <asp:Image ID="imgAvatarHeader" runat="server" CssClass="avatar-img" Visible="false" AlternateText="" />
                        <asp:Literal ID="litHeaderAvatar" runat="server">U</asp:Literal>
                    </a>
                </div>
            </header>

            <%-- Notifications --%>
            <asp:Panel ID="ProfileAlertPanel" runat="server" CssClass="auth-alert auth-alert-success" Visible="false">
                <asp:Literal ID="litProfileAlert" runat="server" />
            </asp:Panel>
            <asp:Panel ID="ProfileErrorPanel" runat="server" CssClass="auth-alert auth-alert-error" Visible="false">
                <asp:Literal ID="litProfileError" runat="server" />
            </asp:Panel>

            <%-- TAB 1: MAIN DASHBOARD OVERVIEW --%>
            <div id="tab-dash" class="<%= GetTabPaneClass("tab-dash") %>">

                <%-- Top Bar --%>
                <div class="dash-topbar" style="justify-content:flex-end;">
                    <div style="display:flex;align-items:center;gap:10px;">
                        <div class="meta-pill" style="font-size:13px;padding:6px 14px;background:#ffffff;border:1px solid var(--border-light);font-weight:700;display:flex;align-items:center;gap:6px;">
                            <svg class="admin-icon" style="width:14px;height:14px;" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.75" stroke-linecap="round" stroke-linejoin="round"><rect x="3" y="4" width="18" height="18" rx="2"></rect><line x1="16" y1="2" x2="16" y2="6"></line><line x1="8" y1="2" x2="8" y2="6"></line><line x1="3" y1="10" x2="21" y2="10"></line></svg>
                            <%: DateTime.Now.Year %>
                        </div>
                        <div class="meta-pill" style="font-size:13px;padding:6px 14px;background:#ffffff;border:1px solid var(--border-light);color:#6366f1;font-weight:700;display:flex;align-items:center;gap:6px;">
                            <svg class="admin-icon" style="width:14px;height:14px;" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.75" stroke-linecap="round" stroke-linejoin="round"><path d="M8.5 14.5A2.5 2.5 0 0 0 11 17a2.5 2.5 0 0 0 2.5-2.5c0-1.38-.5-2-1-3-1.072-2.143-.224-4.054 2-6 .5 2.5 2 4.9 4 6.5 2 1.6 3 3.5 3 5.5a7.5 7.5 0 1 1-15 0c0-1.153.433-2.294 1-3a2.5 2.5 0 0 0 2.5 2.5z"></path></svg>
                            <asp:Literal ID="litStreak" runat="server">0</asp:Literal>-Day Streak
                        </div>
                    </div>
                </div>

                <%-- 4 Metric KPI Cards --%>
                <div class="saas-kpi-grid">
                    <%-- KPI 1: Enrolled --%>
                    <div class="saas-kpi-card">
                        <div class="saas-kpi-top">
                            <div class="saas-kpi-icon">📚</div>
                            <span class="badge badge-success" style="font-size:11px;">● Active</span>
                        </div>
                        <div>
                            <div class="saas-kpi-val"><asp:Literal ID="litActiveCoursesCount" runat="server">0</asp:Literal></div>
                            <div class="saas-kpi-sub">
                                <span>Enrolled Tracks</span>
                                <span style="font-weight:700;color:var(--text-primary);">Active</span>
                            </div>
                        </div>
                    </div>

                    <%-- KPI 2: Total XP --%>
                    <div class="saas-kpi-card">
                        <div class="saas-kpi-top">
                            <div class="saas-kpi-icon" style="color:#d97706;background:rgba(245,158,11,0.12);">⚡</div>
                            <span class="badge" style="background:rgba(245,158,11,0.15);color:#d97706;font-size:11px;">+25 XP/Lesson</span>
                        </div>
                        <div>
                            <div class="saas-kpi-val"><asp:Literal ID="litTotalXp" runat="server">0</asp:Literal></div>
                            <div class="saas-kpi-sub">
                                <span>Total XP Earned</span>
                                <a runat="server" href="~/Leaderboard" style="color:var(--brand-primary);font-weight:700;">View Ranks &rarr;</a>
                            </div>
                        </div>
                    </div>

                    <%-- KPI 3: Lessons Completed --%>
                    <div class="saas-kpi-card">
                        <div class="saas-kpi-top">
                            <div class="saas-kpi-icon" style="color:#059669;background:rgba(16,185,129,0.12);">✅</div>
                            <span class="badge badge-primary" style="font-size:11px;">Mastery</span>
                        </div>
                        <div>
                            <div class="saas-kpi-val"><asp:Literal ID="litCompletedLessonsCount" runat="server">0</asp:Literal></div>
                            <div class="saas-kpi-sub">
                                <span>Lessons Completed</span>
                                <span style="color:var(--text-muted);">Self-Paced</span>
                            </div>
                        </div>
                    </div>

                    <%-- KPI 4: Global Rank --%>
                    <div class="saas-kpi-card">
                        <div class="saas-kpi-top">
                            <div class="saas-kpi-icon" style="color:#db2777;background:rgba(236,72,153,0.12);">🏆</div>
                            <span class="badge" style="background:rgba(236,72,153,0.15);color:#db2777;font-size:11px;">Global</span>
                        </div>
                        <div>
                            <div class="saas-kpi-val">#<asp:Literal ID="litRank" runat="server">-</asp:Literal></div>
                            <div class="saas-kpi-sub">
                                <span>Leaderboard Rank</span>
                                <a runat="server" href="~/Leaderboard" style="color:var(--brand-primary);font-weight:700;">Standing &rarr;</a>
                            </div>
                        </div>
                    </div>
                </div>

                <%-- Middle Grid: Analytics Chart + Track Mastery --%>
                <div class="saas-mid-grid">
                    <%-- Left: Study Activity Bar Chart --%>
                    <div class="card card-body" style="background:#ffffff;">
                        <div style="display:flex;align-items:center;justify-content:space-between;margin-bottom:var(--space-2);">
                            <div>
                                <h3 style="font-size:1.05rem;font-weight:800;">Report Analytics</h3>
                                <p style="font-size:12.5px;color:var(--text-muted);">Weekly learning intensity & streak progression</p>
                            </div>
                            <div style="display:flex;background:#f1f5f9;padding:3px;border-radius:var(--radius-md);gap:2px;">
                                <span style="padding:4px 10px;border-radius:var(--radius-sm);font-size:11.5px;font-weight:700;color:var(--text-muted);cursor:pointer;">Daily</span>
                                <span style="padding:4px 10px;border-radius:var(--radius-sm);font-size:11.5px;font-weight:700;background:#ffffff;color:var(--brand-primary);box-shadow:0 1px 3px rgba(0,0,0,0.06);cursor:pointer;">Weekly</span>
                                <span style="padding:4px 10px;border-radius:var(--radius-sm);font-size:11.5px;font-weight:700;color:var(--text-muted);cursor:pointer;">Monthly</span>
                            </div>
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

                    <%-- Right: Assignment & Goal Breakdown --%>
                    <div class="card card-body" style="background:#ffffff;display:flex;flex-direction:column;justify-content:space-between;">
                        <div>
                            <div style="display:flex;justify-content:space-between;align-items:center;margin-bottom:var(--space-3);">
                                <h3 style="font-size:1.05rem;font-weight:800;">Track Breakdown</h3>
                                <span style="font-size:11px;color:#059669;font-weight:700;">● Active Pace</span>
                            </div>
                            <p style="font-size:12.5px;color:var(--text-muted);margin-bottom:var(--space-3);">Progress breakdown across enrolled language courses.</p>
                            
                            <div class="segment-bar">
                                <div class="segment-part-green" style="width:45%;" title="Completed"></div>
                                <div class="segment-part-purple" style="width:35%;" title="In Progress"></div>
                                <div class="segment-part-gray" style="width:20%;" title="Remaining"></div>
                            </div>
                            <div style="display:flex;flex-wrap:wrap;gap:12px;font-size:11.5px;font-weight:600;margin-top:10px;">
                                <span style="display:flex;align-items:center;gap:4px;"><span style="width:8px;height:8px;border-radius:50%;background:#34d399;"></span> Cleared</span>
                                <span style="display:flex;align-items:center;gap:4px;"><span style="width:8px;height:8px;border-radius:50%;background:#818cf8;"></span> Active</span>
                                <span style="display:flex;align-items:center;gap:4px;"><span style="width:8px;height:8px;border-radius:50%;background:#cbd5e1;"></span> Remaining</span>
                            </div>
                        </div>

                        <div style="margin-top:var(--space-4);padding-top:var(--space-3);border-top:1px solid var(--border-light);">
                            <a class="btn btn-primary" runat="server" href="~/Courses" style="width:100%;height:38px;font-size:13px;">+ Enroll in More Tracks</a>
                        </div>
                    </div>
                </div>

                <%-- Bottom Section: Continue Learning / Enrolled Courses Table --%>
                <div class="card" style="box-shadow:var(--shadow-card);background:#ffffff;">
                    <div class="card-header" style="display:flex;align-items:center;justify-content:space-between;background:#ffffff;">
                        <div>
                            <h3 style="font-size:1.1rem;font-weight:800;">Continue Learning</h3>
                            <p style="font-size:12.5px;color:var(--text-muted);">Your enrolled tracks & active syllabus</p>
                        </div>
                        <a class="btn btn-outline" runat="server" href="~/Courses" style="height:32px;font-size:12px;padding:0 12px;">Browse Catalogue &rarr;</a>
                    </div>
                    <div style="overflow-x:auto;">
                        <table style="width:100%;border-collapse:collapse;font-size:13.5px;">
                            <thead>
                                <tr style="background:#f8fafc;border-bottom:1px solid var(--border-light);text-align:left;color:var(--text-muted);font-size:11px;text-transform:uppercase;letter-spacing:0.05em;">
                                    <th style="padding:12px 16px;">Track / Language</th>
                                    <th style="padding:12px 16px;">Progress</th>
                                    <th style="padding:12px 16px;">Status</th>
                                    <th style="padding:12px 16px;text-align:right;">Action</th>
                                </tr>
                            </thead>
                            <tbody>
                                <asp:Repeater ID="rptEnrollments" runat="server">
                                    <ItemTemplate>
                                        <tr style="border-bottom:1px solid var(--border-light);">
                                            <td style="padding:14px 16px;">
                                                <div style="display:flex;align-items:center;gap:12px;">
                                                    <div style="width:36px;height:36px;border-radius:8px;background:linear-gradient(135deg, #e0e7ff, #c7d2fe);color:#4338ca;font-weight:800;font-size:13px;display:grid;place-items:center;flex-shrink:0;">
                                                        <%# binary.Core.Helpers.DisplayHelper.GetTitleMonogram((string)Eval("CourseTitle")) %>
                                                    </div>
                                                    <div>
                                                        <div style="font-weight:700;color:var(--text-primary);"><%# HttpUtility.HtmlEncode((string)Eval("CourseTitle")) %></div>
                                                        <div style="font-size:12px;color:var(--text-muted);">Self-Paced Track &bull; +25 XP / lesson</div>
                                                    </div>
                                                </div>
                                            </td>
                                            <td style="padding:14px 16px;min-width:180px;">
                                                <div style="display:flex;align-items:center;gap:8px;">
                                                    <div class="progress" style="height:6px;flex:1;"><div class="progress-bar" style="width:<%# Eval("ProgressPercent") %>%;background:linear-gradient(90deg, #10b981, #059669);"></div></div>
                                                    <span style="font-size:12px;font-weight:700;color:var(--text-secondary);"><%# Eval("ProgressPercent") %>%</span>
                                                </div>
                                            </td>
                                            <td style="padding:14px 16px;">
                                                <span class="badge badge-success"><%# (int)Eval("ProgressPercent") == 100 ? "Completed" : "In Progress" %></span>
                                            </td>
                                            <td style="padding:14px 16px;text-align:right;">
                                                <a class="btn btn-primary" href='<%# ResolveUrl("~/Courses/Detail.aspx?id=" + Eval("CourseID")) %>' style="height:32px;font-size:12.5px;padding:0 14px;">Resume Track &rarr;</a>
                                            </td>
                                        </tr>
                                    </ItemTemplate>
                                </asp:Repeater>
                            </tbody>
                        </table>
                        <asp:Panel ID="pnlNoEnrollments" runat="server" Visible="false" style="text-align:center;color:var(--text-muted);padding:var(--space-8) var(--space-4);">
                            <div style="font-size:2.5rem;margin-bottom:var(--space-2);">🎓</div>
                            <h4 style="font-weight:700;color:var(--text-primary);">No active enrollments yet</h4>
                            <p style="font-size:13.5px;color:var(--text-secondary);margin:4px 0 var(--space-4);">Enroll in Spanish, French, German, Japanese, and more to start earning XP.</p>
                            <a class="btn btn-primary" runat="server" href="~/Courses">Browse Language Tracks &rarr;</a>
                        </asp:Panel>
                    </div>
                </div>

            </div>

            <%-- TAB: VOCABULARY PRACTICE --%>
            <div id="tab-practice" class="<%= GetTabPaneClass("tab-practice") %>">

                <asp:Panel ID="pnlQuizList" runat="server">
                    <div class="admin-section-label">Available Practice</div>
                    <div class="grid-2" style="margin-bottom:var(--space-6);">
                        <asp:Repeater ID="rptQuizzes" runat="server" OnItemCommand="rptQuizzes_ItemCommand">
                            <ItemTemplate>
                                <div class="card card-body" style="display:flex;flex-direction:column;gap:var(--space-3);background:#ffffff;">
                                    <div style="display:flex;align-items:center;gap:var(--space-3);">
                                        <div class="kpi-icon" style="background:rgba(99,102,241,0.12);color:#4f46e5;">🧠</div>
                                        <div>
                                            <h3 style="font-size:1.02rem;font-weight:700;"><%# HttpUtility.HtmlEncode((string)Eval("Title")) %></h3>
                                            <p style="font-size:12px;color:var(--text-muted);"><%# HttpUtility.HtmlEncode((string)Eval("CourseTitle")) %></p>
                                        </div>
                                    </div>
                                    <asp:LinkButton runat="server" CssClass="btn btn-primary" style="width:100%;" CommandName="StartQuiz" CommandArgument='<%# Eval("QuizID") %>'>Start Practice</asp:LinkButton>
                                </div>
                            </ItemTemplate>
                        </asp:Repeater>
                    </div>
                    <asp:Panel ID="pnlNoQuizzes" runat="server" Visible="false" style="text-align:center;color:var(--text-muted);padding:var(--space-8) var(--space-4);">
                        <div style="font-size:2.5rem;margin-bottom:var(--space-2);">🧠</div>
                        <h4 style="font-weight:700;color:var(--text-primary);">No practice available yet</h4>
                        <p style="font-size:13.5px;">Enroll in a course to unlock its vocabulary practice quiz.</p>
                    </asp:Panel>

                    <div class="card" style="background:#ffffff;">
                        <div class="card-header"><h3 style="font-size:1.05rem;">Your Recent Attempts</h3></div>
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
                            No attempts yet — take a quiz above to get started.
                        </asp:Panel>
                    </div>
                </asp:Panel>

                <asp:Panel ID="pnlQuizPlay" runat="server" Visible="false">
                    <div class="card" style="max-width:720px;background:#ffffff;">
                        <div class="card-header">
                            <h3 style="font-size:1.1rem;font-weight:800;"><asp:Literal ID="litPlayQuizTitle" runat="server" /></h3>
                            <p style="font-size:13px;color:var(--text-muted);">Choose the best answer for each question, then submit.</p>
                        </div>
                        <div class="card-body">
                            <asp:HiddenField ID="hfPlayQuizId" runat="server" />
                            <asp:Repeater ID="rptQuestions" runat="server">
                                <ItemTemplate>
                                    <div class="quiz-question-card">
                                        <div style="font-weight:700;margin-bottom:var(--space-2);"><%# Container.ItemIndex + 1 %>. <%# HttpUtility.HtmlEncode((string)Eval("QuestionText")) %></div>
                                        <asp:HiddenField runat="server" ID="hfQuestionId" Value='<%# Eval("QuestionID") %>' />
                                        <asp:RadioButtonList runat="server" ID="rblOptions" DataSource='<%# Eval("Options") %>' DataTextField="OptionText" DataValueField="OptionID" RepeatLayout="Flow" CssClass="quiz-option-row" />
                                    </div>
                                </ItemTemplate>
                            </asp:Repeater>
                            <div style="display:flex;gap:var(--space-3);margin-top:var(--space-4);">
                                <asp:Button ID="btnSubmitQuiz" runat="server" CssClass="btn btn-primary" Text="Submit Answers" OnClick="btnSubmitQuiz_Click" OnClientClick="return confirmQuizSubmit();" />
                                <asp:LinkButton ID="lnkCancelQuiz" runat="server" CssClass="btn btn-outline" Text="Cancel" OnClick="lnkCancelQuiz_Click" CausesValidation="false" />
                            </div>
                        </div>
                    </div>
                </asp:Panel>

                <asp:Panel ID="pnlQuizResult" runat="server" Visible="false">
                    <div class="card card-body" style="max-width:480px;text-align:center;background:#ffffff;">
                        <div style="font-size:2.5rem;margin-bottom:var(--space-2);"><asp:Literal ID="litResultEmoji" runat="server" /></div>
                        <h3 style="font-size:1.3rem;font-weight:800;">Score: <asp:Literal ID="litResultScore" runat="server" /></h3>
                        <p style="font-size:13.5px;color:var(--text-muted);margin:6px 0 var(--space-2);"><asp:Literal ID="litResultMessage" runat="server" /></p>
                        <p style="font-size:12.5px;color:#d97706;font-weight:700;margin-bottom:var(--space-4);">+<asp:Literal ID="litResultXp" runat="server" /> XP earned</p>
                        <div style="display:flex;gap:var(--space-3);justify-content:center;">
                            <asp:LinkButton ID="lnkRetryQuiz" runat="server" CssClass="btn btn-primary" Text="Try Again" OnClick="lnkRetryQuiz_Click" />
                            <asp:LinkButton ID="lnkBackToList" runat="server" CssClass="btn btn-outline" Text="Back to Practice List" OnClick="lnkBackToList_Click" />
                        </div>
                    </div>
                </asp:Panel>

            </div>

            <%-- TAB 2: PROFILE --%>
            <div id="tab-profile" class="<%= GetTabPaneClass("tab-profile") %>">
                <div class="card" style="max-width:680px;background:#ffffff;box-shadow:var(--shadow-card);">
                    <div class="card-header">
                        <h3 style="font-size:1.15rem;font-weight:800;">Profile</h3>
                        <p style="font-size:13px;color:var(--text-muted);">Update your personal details and public learner display name</p>
                    </div>
                    <div class="card-body">
                        <div class="form-group">
                            <label class="form-label">Profile Picture</label>
                            <div style="display:flex;align-items:center;gap:var(--space-4);">
                                <div class="learner-user-avatar" style="width:64px;height:64px;font-size:1.3rem;">
                                    <asp:Image ID="imgAvatarPreview" runat="server" CssClass="avatar-img" Visible="false" AlternateText="" />
                                    <asp:Literal ID="litAvatarPreview" runat="server">U</asp:Literal>
                                </div>
                                <div style="flex:1;min-width:0;">
                                    <asp:FileUpload ID="fuAvatar" runat="server" CssClass="form-control" />
                                    <p style="font-size:11.5px;color:var(--text-muted);margin-top:4px;">JPG, PNG, GIF, or WEBP. Max 2 MB.</p>
                                </div>
                            </div>
                        </div>
                        <div class="form-group">
                            <label class="form-label">Title</label>
                            <div class="profile-title-row">
                                <span class="profile-title-pill"><asp:Literal ID="litProfileTitle" runat="server" /></span>
                                <span class="profile-title-hint"><asp:Literal ID="litProfileTitleHint" runat="server" /></span>
                                <a href="?tab=exp" class="profile-title-link" onclick="switchLearnerTab('tab-exp', document.getElementById('btnNavExp')); return false;">View titles &rarr;</a>
                            </div>
                        </div>
                        <div class="grid-2">
                            <div class="form-group">
                                <label class="form-label" for="txtFirstName">First Name</label>
                                <asp:TextBox ID="txtFirstName" runat="server" CssClass="form-control" placeholder="First Name" />
                                <asp:RequiredFieldValidator ID="rfvFirst" runat="server" ControlToValidate="txtFirstName" ValidationGroup="ProfileGroup" CssClass="field-error" ErrorMessage="First name is required." Display="Dynamic" />
                            </div>
                            <div class="form-group">
                                <label class="form-label" for="txtLastName">Last Name</label>
                                <asp:TextBox ID="txtLastName" runat="server" CssClass="form-control" placeholder="Last Name" />
                                <asp:RequiredFieldValidator ID="rfvLast" runat="server" ControlToValidate="txtLastName" ValidationGroup="ProfileGroup" CssClass="field-error" ErrorMessage="Last name is required." Display="Dynamic" />
                            </div>
                        </div>
                        <div class="form-group">
                            <label class="form-label" for="txtEmail">Email Address (Registered)</label>
                            <asp:TextBox ID="txtEmail" runat="server" CssClass="form-control" ReadOnly="true" style="background:#f8fafc;color:var(--text-muted);cursor:not-allowed;" />
                        </div>
                        <div style="margin-top:var(--space-4);">
                            <asp:Button ID="btnSaveProfile" runat="server" CssClass="btn btn-primary" Text="Save Changes" ValidationGroup="ProfileGroup" OnClick="btnSaveProfile_Click" />
                        </div>
                    </div>
                </div>
            </div>

            <%-- TAB 3: PASSWORD --%>
            <div id="tab-security" class="<%= GetTabPaneClass("tab-security") %>">
                <div class="card" style="max-width:680px;background:#ffffff;box-shadow:var(--shadow-card);">
                    <div class="card-header">
                        <h3 style="font-size:1.15rem;font-weight:800;">Password</h3>
                        <p style="font-size:13px;color:var(--text-muted);">Protect your account with a secure password</p>
                    </div>
                    <div class="card-body">
                        <div class="form-group">
                            <label class="form-label" for="txtCurrentPassword">Current Password</label>
                            <asp:TextBox ID="txtCurrentPassword" runat="server" CssClass="form-control" TextMode="Password" placeholder="Enter current password" />
                            <asp:RequiredFieldValidator ID="rfvCurrent" runat="server" ControlToValidate="txtCurrentPassword" ValidationGroup="PasswordGroup" CssClass="field-error" ErrorMessage="Current password is required." Display="Dynamic" />
                        </div>
                        <div class="grid-2">
                            <div class="form-group">
                                <label class="form-label" for="txtNewPassword">New Password</label>
                                <asp:TextBox ID="txtNewPassword" runat="server" CssClass="form-control" TextMode="Password" placeholder="Min. 8 characters" />
                                <asp:RequiredFieldValidator ID="rfvNew" runat="server" ControlToValidate="txtNewPassword" ValidationGroup="PasswordGroup" CssClass="field-error" ErrorMessage="New password is required." Display="Dynamic" />
                            </div>
                            <div class="form-group">
                                <label class="form-label" for="txtConfirmNewPassword">Confirm New Password</label>
                                <asp:TextBox ID="txtConfirmNewPassword" runat="server" CssClass="form-control" TextMode="Password" placeholder="Repeat new password" />
                                <asp:CompareValidator ID="cvNewPass" runat="server" ControlToValidate="txtConfirmNewPassword" ControlToCompare="txtNewPassword" ValidationGroup="PasswordGroup" CssClass="field-error" ErrorMessage="Passwords do not match." Display="Dynamic" />
                            </div>
                        </div>
                        <div style="margin-top:var(--space-4);">
                            <asp:Button ID="btnChangePassword" runat="server" CssClass="btn btn-outline" Text="Update Password" ValidationGroup="PasswordGroup" OnClick="btnChangePassword_Click" />
                        </div>
                    </div>
                </div>
            </div>

            <%-- TAB 4: EXP EARNED --%>
            <div id="tab-exp" class="<%= GetTabPaneClass("tab-exp") %>">
                <div class="card card-body exp-summary">
                    <div class="exp-summary-title">
                        <span class="exp-summary-emoji"><asp:Literal ID="litExpTitleEmoji" runat="server" /></span>
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
                        <div class="progress" style="height:8px;"><div class="progress-bar" id="expProgressBar" runat="server" style="background:linear-gradient(90deg, #f59e0b, #d97706);"></div></div>
                    </div>
                </div>

                <div class="exp-tier-grid">
                    <asp:Repeater ID="rptTitles" runat="server">
                        <ItemTemplate>
                            <div class="card card-body exp-tier <%# Eval("StateClass") %>">
                                <div class="exp-tier-emoji"><%# Eval("Emoji") %></div>
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

    <script>
        // unanswered questions are scored as wrong, so check before submitting
        function confirmQuizSubmit() {
            var cards = document.querySelectorAll('.quiz-question-card');
            var unanswered = 0;
            for (var i = 0; i < cards.length; i++) {
                if (!cards[i].querySelector('input[type="radio"]:checked')) unanswered++;
            }
            if (unanswered === 0) return true;
            return confirm(unanswered + (unanswered === 1 ? ' question is' : ' questions are') +
                ' unanswered and will be marked wrong. Submit anyway?');
        }

        function switchLearnerTab(tabId, btn) {
            document.querySelectorAll('.tab-pane').forEach(function(pane) {
                pane.classList.remove('active');
            });
            document.querySelectorAll('.learner-nav-btn').forEach(function(b) {
                b.classList.remove('active');
            });
            var target = document.getElementById(tabId);
            if (target) {
                target.classList.add('active');
            }
            if (btn) {
                btn.classList.add('active');
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
