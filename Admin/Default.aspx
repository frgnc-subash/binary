<%@ Page Title="Admin Dashboard" Language="C#" MasterPageFile="~/MasterPages/AdminMaster.master" AutoEventWireup="true" CodeBehind="Default.aspx.cs" Inherits="binary.Admin.AdminHome" %>

<asp:Content ID="HeaderTitle" ContentPlaceHolderID="AdminHeaderTitle" runat="server">Admin Dashboard</asp:Content>
<asp:Content ID="HeaderSubtitle" ContentPlaceHolderID="AdminHeaderSubtitle" runat="server">Platform overview — <%: DateTime.Now.ToString("dddd, MMMM d, yyyy") %></asp:Content>
<asp:Content ID="HeaderActions" ContentPlaceHolderID="AdminHeaderActions" runat="server">
    <a class="btn btn-outline" runat="server" href="~/Admin/Courses.aspx">Manage Courses</a>
    <a class="btn btn-primary" runat="server" href="~/Admin/Users.aspx">Manage Users</a>
</asp:Content>

<asp:Content ID="BodyContent" ContentPlaceHolderID="AdminMainContent" runat="server">

    <div class="admin-section-label">Overview</div>

    <%-- Modern KPI Metrics Grid --%>
    <div class="grid-4 admin-kpis" style="margin-bottom:var(--space-8);">
        <div class="card kpi-card">
            <div class="kpi-icon"><svg class="admin-icon" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.75" stroke-linecap="round" stroke-linejoin="round"><path d="M17 21v-2a4 4 0 0 0-4-4H5a4 4 0 0 0-4 4v2"></path><circle cx="9" cy="7" r="4"></circle><path d="M23 21v-2a4 4 0 0 0-3-3.87"></path><path d="M16 3.13a4 4 0 0 1 0 7.75"></path></svg></div>
            <div>
                <div class="kpi-value"><asp:Literal ID="litTotalUsers" runat="server">0</asp:Literal></div>
                <div class="kpi-label">Total Learners</div>
            </div>
        </div>

        <div class="card kpi-card">
            <div class="kpi-icon"><svg class="admin-icon" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.75" stroke-linecap="round" stroke-linejoin="round"><path d="M2 4.5h6a4 4 0 0 1 4 4v11a3 3 0 0 0-3-3H2z"></path><path d="M22 4.5h-6a4 4 0 0 0-4 4v11a3 3 0 0 1 3-3h7z"></path></svg></div>
            <div>
                <div class="kpi-value"><asp:Literal ID="litActiveCourses" runat="server">0</asp:Literal></div>
                <div class="kpi-label">Published Tracks</div>
            </div>
        </div>

        <div class="card kpi-card">
            <div class="kpi-icon"><svg class="admin-icon" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.75" stroke-linecap="round" stroke-linejoin="round"><path d="M22 11.08V12a10 10 0 1 1-5.93-9.14"></path><polyline points="22 4 12 14.01 9 11.01"></polyline></svg></div>
            <div>
                <div class="kpi-value"><asp:Literal ID="litLessonsCompleted" runat="server">0</asp:Literal></div>
                <div class="kpi-label">Lessons Cleared</div>
            </div>
        </div>

        <div class="card kpi-card">
            <div class="kpi-icon"><svg class="admin-icon" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.75" stroke-linecap="round" stroke-linejoin="round"><path d="M16 21v-2a4 4 0 0 0-4-4H5a4 4 0 0 0-4 4v2"></path><circle cx="8.5" cy="7" r="4"></circle><line x1="19" y1="8" x2="19" y2="14"></line><line x1="16" y1="11" x2="22" y2="11"></line></svg></div>
            <div>
                <div class="kpi-value"><asp:Literal ID="litNewThisWeek" runat="server">0</asp:Literal></div>
                <div class="kpi-label">New This Week</div>
            </div>
        </div>
    </div>

    <%-- Main Grid: Table + Quick Actions --%>
    <div class="admin-main-grid">

        <div style="display:flex;flex-direction:column;gap:var(--space-6);min-width:0;">

            <%-- Weekly Signups Chart --%>
            <div class="card card-body">
                <div style="margin-bottom:var(--space-4);">
                    <h3 style="font-size:1.05rem;font-weight:700;">New Signups</h3>
                    <p style="font-size:12.5px;color:var(--text-muted);margin-top:2px;">Daily registrations over the last 7 days</p>
                </div>
                <div class="bar-chart-container">
                    <asp:Repeater ID="rptSignupChart" runat="server">
                        <ItemTemplate>
                            <div class="bar-col">
                                <%# binary.Core.Helpers.DisplayHelper.GetChartTooltip(Eval("IsToday"), Eval("Count")) %>
                                <div class="<%# binary.Core.Helpers.DisplayHelper.GetChartBarClass(Eval("IsToday")) %>" style="height:<%# Eval("HeightPercent") %>%;" title='<%# Eval("Count") %> signups'></div>
                                <span class="bar-label" style="<%# binary.Core.Helpers.DisplayHelper.GetChartLabelStyle(Eval("IsToday")) %>"><%# Eval("Label") %></span>
                            </div>
                        </ItemTemplate>
                    </asp:Repeater>
                </div>
            </div>

            <%-- Recent Users --%>
            <div class="card">
                <div class="card-header" style="display:flex;align-items:center;justify-content:space-between;">
                    <div>
                        <h3 style="font-size:1.1rem;font-weight:700;">Recent Registrations</h3>
                        <p style="font-size:12.5px;color:var(--text-muted);margin-top:2px;">Latest learners joined on Binary</p>
                    </div>
                    <a class="btn btn-outline" style="height:32px;font-size:12px;padding:0 12px;" runat="server" href="~/Admin/Users.aspx">View All Users &rarr;</a>
                </div>
                <asp:Panel ID="pnlRecentUsers" runat="server">
                    <div style="overflow-x:auto;">
                        <table class="admin-table">
                            <thead>
                                <tr>
                                    <th>Learner</th>
                                    <th>Email</th>
                                    <th>Joined</th>
                                    <th>Status</th>
                                    <th style="text-align:right;">Action</th>
                                </tr>
                            </thead>
                            <tbody>
                                <asp:Repeater ID="rptRecentUsers" runat="server">
                                    <ItemTemplate>
                                        <tr>
                                            <td>
                                                <div class="tbl-user">
                                                    <div class="tbl-avatar"><%# binary.Core.Helpers.DisplayHelper.GetInitials((string)Eval("FirstName"), (string)Eval("LastName")) %></div>
                                                    <span><%# HttpUtility.HtmlEncode((string)Eval("FirstName") + " " + (string)Eval("LastName")) %></span>
                                                </div>
                                            </td>
                                            <td><%# HttpUtility.HtmlEncode((string)Eval("Email")) %></td>
                                            <td style="color:var(--text-muted);"><%# Eval("CreatedDate", "{0:MMM d, yyyy}") %></td>
                                            <td>
                                                <%# (bool)Eval("IsActive") ? "<span class=\"badge badge-success\">Active</span>" : "<span class=\"badge badge-muted\">Suspended</span>" %>
                                            </td>
                                            <td style="text-align:right;">
                                                <a class="btn btn-ghost" style="height:28px;font-size:12px;padding:0 8px;" runat="server" href="~/Admin/Users.aspx">Manage</a>
                                            </td>
                                        </tr>
                                    </ItemTemplate>
                                </asp:Repeater>
                            </tbody>
                        </table>
                    </div>
                </asp:Panel>
                <asp:Panel ID="pnlNoRecentUsers" runat="server" Visible="false" style="text-align:center;color:var(--text-muted);padding:var(--space-8) var(--space-4);">
                    <div style="width:44px;height:44px;margin:0 auto var(--space-3);border-radius:50%;background:rgba(67,56,202,0.1);color:var(--brand-primary);display:grid;place-items:center;"><svg class="admin-icon" style="width:22px;height:22px;" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.75" stroke-linecap="round" stroke-linejoin="round"><path d="M22 10 12 5 2 10l10 5 10-5Z"></path><path d="M6 12v5c0 1.5 3 3 6 3s6-1.5 6-3v-5"></path></svg></div>
                    <h4 style="font-weight:700;color:var(--text-primary);">No learners yet</h4>
                    <p style="font-size:13.5px;">New registrations will show up here.</p>
                </asp:Panel>
            </div>

        </div>

        <%-- Quick Actions --%>
        <div class="admin-side">
            <div class="card card-body">
                <h3 style="font-size:1.05rem;font-weight:700;margin-bottom:var(--space-3);">Management Tools</h3>
                <div style="display:flex;flex-direction:column;gap:var(--space-2);">
                    <a class="quick-action-btn" runat="server" href="~/Admin/Courses.aspx?new=1">
                        <span class="quick-action-icon"><svg class="admin-icon" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.75" stroke-linecap="round" stroke-linejoin="round"><line x1="12" y1="5" x2="12" y2="19"></line><line x1="5" y1="12" x2="19" y2="12"></line></svg></span>
                        <span>Create New Course</span>
                    </a>
                    <a class="quick-action-btn" runat="server" href="~/Admin/Courses.aspx">
                        <span class="quick-action-icon"><svg class="admin-icon" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.75" stroke-linecap="round" stroke-linejoin="round"><path d="M2 4.5h6a4 4 0 0 1 4 4v11a3 3 0 0 0-3-3H2z"></path><path d="M22 4.5h-6a4 4 0 0 0-4 4v11a3 3 0 0 1 3-3h7z"></path></svg></span>
                        <span>Manage Course Tracks</span>
                    </a>
                    <a class="quick-action-btn" runat="server" href="~/Admin/Users.aspx">
                        <span class="quick-action-icon"><svg class="admin-icon" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.75" stroke-linecap="round" stroke-linejoin="round"><path d="M17 21v-2a4 4 0 0 0-4-4H5a4 4 0 0 0-4 4v2"></path><circle cx="9" cy="7" r="4"></circle><path d="M23 21v-2a4 4 0 0 0-3-3.87"></path><path d="M16 3.13a4 4 0 0 1 0 7.75"></path></svg></span>
                        <span>Manage Learner Roles</span>
                    </a>
                    <a class="quick-action-btn" runat="server" href="~/Leaderboard">
                        <span class="quick-action-icon"><svg class="admin-icon" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.75" stroke-linecap="round" stroke-linejoin="round"><path d="M8 21h8"></path><path d="M12 17v4"></path><path d="M7 4h10v5a5 5 0 0 1-10 0V4Z"></path><path d="M7 5H4.5a2.5 2.5 0 0 0 0 5H7"></path><path d="M17 5h2.5a2.5 2.5 0 0 1 0 5H17"></path></svg></span>
                        <span>View XP Rankings</span>
                    </a>
                    <a class="quick-action-btn" runat="server" href="~/Admin/Reports.aspx">
                        <span class="quick-action-icon"><svg class="admin-icon" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.75" stroke-linecap="round" stroke-linejoin="round"><line x1="18" y1="20" x2="18" y2="10"></line><line x1="12" y1="20" x2="12" y2="4"></line><line x1="6" y1="20" x2="6" y2="14"></line></svg></span>
                        <span>View Reports</span>
                    </a>
                    <a class="quick-action-btn" runat="server" href="~/Admin/Feedback.aspx">
                        <span class="quick-action-icon"><svg class="admin-icon" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.75" stroke-linecap="round" stroke-linejoin="round"><polyline points="22 12 16 12 14 15 10 15 8 12 2 12"></polyline><path d="M5.45 5.11 2 12v6a2 2 0 0 0 2 2h16a2 2 0 0 0 2-2v-6l-3.45-6.89A2 2 0 0 0 16.76 4H7.24a2 2 0 0 0-1.79 1.11Z"></path></svg></span>
                        <span>Check Feedback</span>
                    </a>
                </div>
            </div>
        </div>

    </div>
</asp:Content>
