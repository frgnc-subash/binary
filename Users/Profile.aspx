<%@ Page Title="My Profile" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Profile.aspx.cs" Inherits="binary.Users.Profile" %>

<asp:Content ID="BodyContent" ContentPlaceHolderID="MainContent" runat="server">

    <section class="section-sm">
        <div class="site-container">
            <div class="profile-clean-layout">

                <%-- left sidebar: user card & study stats --%>
                <aside class="profile-sidebar">
                    <div class="card card-body profile-summary-card">
                        <div class="profile-clean-avatar">
                            <asp:Literal ID="litAvatar" runat="server">U</asp:Literal>
                        </div>
                        <h2 class="profile-clean-name"><asp:Literal ID="litFullName" runat="server">Learner Name</asp:Literal></h2>
                        <p class="profile-clean-email"><asp:Literal ID="litEmail" runat="server">user@example.com</asp:Literal></p>
                        
                        <div class="profile-badges" style="margin-top:var(--space-2);margin-bottom:var(--space-4);">
                            <span class="badge badge-primary"><asp:Literal ID="litRoleBadge" runat="server">Member</asp:Literal></span>
                        </div>

                        <%-- daily study rhythm bar --%>
                        <div style="border-top:1px solid var(--border-light);padding-top:var(--space-4);text-align:left;">
                            <div style="display:flex;justify-content:space-between;font-size:12.5px;font-weight:600;color:var(--text-secondary);margin-bottom:6px;">
                                <span>Daily Practice Goal</span>
                                <span>15 / 20 min</span>
                            </div>
                            <div class="progress"><div class="progress-bar" style="width:75%;"></div></div>
                        </div>
                    </div>

                    <%-- clean stats card --%>
                    <div class="card card-body" style="display:flex;flex-direction:column;gap:var(--space-3);">
                        <h4 style="font-size:12.5px;font-weight:700;text-transform:uppercase;letter-spacing:0.04em;color:var(--text-muted);">Learning Activity</h4>
                        
                        <div class="stat-clean-row">
                            <div class="stat-clean-icon bg-warm">
                                <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M8.5 14.5A2.5 2.5 0 0 0 11 12c0-1.38-.5-2-1-3-1.072-2.143-.224-4.054 2-6 .5 2.5 2 4.9 4 6.5 2 1.6 3 3.5 3 5.5a7 7 0 1 1-14 0c0-1.153.433-2.294 1-3a2.5 2.5 0 0 0 2.5 2.5z"/></svg>
                            </div>
                            <div>
                                <div style="font-weight:700;font-size:15px;">7 Days</div>
                                <div style="font-size:12px;color:var(--text-muted);">Active Streak</div>
                            </div>
                        </div>

                        <div class="stat-clean-row">
                            <div class="stat-clean-icon bg-primary">
                                <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><polygon points="12 2 2 7 12 12 22 7 12 2"></polygon><polyline points="2 17 12 22 22 17"></polyline><polyline points="2 12 12 17 22 12"></polyline></svg>
                            </div>
                            <div>
                                <div style="font-weight:700;font-size:15px;"><asp:Literal ID="litActiveCoursesCount" runat="server">2</asp:Literal> Courses</div>
                                <div style="font-size:12px;color:var(--text-muted);">Enrolled Tracks</div>
                            </div>
                        </div>
                    </div>
                </aside>

                <%-- right main area --%>
                <div class="profile-main">

                    <%-- alert notifications --%>
                    <asp:Panel ID="ProfileAlertPanel" runat="server" CssClass="auth-alert auth-alert-success" Visible="false">
                        <asp:Literal ID="litProfileAlert" runat="server" />
                    </asp:Panel>
                    <asp:Panel ID="ProfileErrorPanel" runat="server" CssClass="auth-alert auth-alert-error" Visible="false">
                        <asp:Literal ID="litProfileError" runat="server" />
                    </asp:Panel>

                    <%-- enrolled active courses --%>
                    <div class="card" style="margin-bottom:var(--space-6);">
                        <div class="card-header" style="display:flex;align-items:center;justify-content:space-between;">
                            <h3 style="font-size:1.1rem;">My Courses</h3>
                            <a class="btn btn-primary" runat="server" href="~/Courses" style="height:34px;padding:0 12px;font-size:13px;">Browse All Courses</a>
                        </div>
                        <div class="card-body">
                            <div class="active-course-list">
                                <div class="active-course-row">
                                    <div class="course-lang-icon" style="width:40px;height:40px;font-weight:800;">ES</div>
                                    <div class="active-course-info">
                                        <div class="active-course-name">Spanish for Beginners</div>
                                        <div class="active-course-meta">Lesson 3 of 5 &bull; 60% Completed</div>
                                        <div class="progress" style="margin-top:6px;"><div class="progress-bar" style="width:60%"></div></div>
                                    </div>
                                    <a class="btn btn-outline" runat="server" href="~/Courses" style="height:36px;padding:0 14px;font-size:13px;">Resume Lesson</a>
                                </div>
                                <div class="active-course-row">
                                    <div class="course-lang-icon" style="width:40px;height:40px;font-weight:800;">JP</div>
                                    <div class="active-course-info">
                                        <div class="active-course-name">Japanese: Zero to N3</div>
                                        <div class="active-course-meta">Lesson 1 of 3 &bull; 33% Completed</div>
                                        <div class="progress" style="margin-top:6px;"><div class="progress-bar" style="width:33%"></div></div>
                                    </div>
                                    <a class="btn btn-outline" runat="server" href="~/Courses" style="height:36px;padding:0 14px;font-size:13px;">Resume Lesson</a>
                                </div>
                            </div>
                        </div>
                    </div>

                    <%-- personal information form --%>
                    <div class="card" style="margin-bottom:var(--space-6);">
                        <div class="card-header">
                            <h3 style="font-size:1.1rem;">Personal Information</h3>
                        </div>
                        <div class="card-body">
                            <div class="grid-2">
                                <div class="form-group">
                                    <label class="form-label" for="txtFirstName">First Name</label>
                                    <asp:TextBox ID="txtFirstName" runat="server" CssClass="form-control" />
                                    <asp:RequiredFieldValidator ID="rfvFirst" runat="server" ControlToValidate="txtFirstName" ValidationGroup="ProfileGroup" CssClass="field-error" ErrorMessage="First name is required." Display="Dynamic" />
                                </div>
                                <div class="form-group">
                                    <label class="form-label" for="txtLastName">Last Name</label>
                                    <asp:TextBox ID="txtLastName" runat="server" CssClass="form-control" />
                                    <asp:RequiredFieldValidator ID="rfvLast" runat="server" ControlToValidate="txtLastName" ValidationGroup="ProfileGroup" CssClass="field-error" ErrorMessage="Last name is required." Display="Dynamic" />
                                </div>
                            </div>
                            <div class="form-group">
                                <label class="form-label" for="txtEmail">Email Address</label>
                                <asp:TextBox ID="txtEmail" runat="server" CssClass="form-control" ReadOnly="true" style="background:var(--bg-subtle);color:var(--text-muted);" />
                            </div>
                            <asp:Button ID="btnSaveProfile" runat="server" CssClass="btn btn-primary" Text="Save Changes" ValidationGroup="ProfileGroup" OnClick="btnSaveProfile_Click" />
                        </div>
                    </div>

                    <%-- change password form --%>
                    <div class="card">
                        <div class="card-header">
                            <h3 style="font-size:1.1rem;">Security & Password</h3>
                        </div>
                        <div class="card-body">
                            <div class="form-group">
                                <label class="form-label" for="txtCurrentPassword">Current Password</label>
                                <asp:TextBox ID="txtCurrentPassword" runat="server" CssClass="form-control" TextMode="Password" />
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
                                    <asp:TextBox ID="txtConfirmNewPassword" runat="server" CssClass="form-control" TextMode="Password" />
                                    <asp:CompareValidator ID="cvNewPass" runat="server" ControlToValidate="txtConfirmNewPassword" ControlToCompare="txtNewPassword" ValidationGroup="PasswordGroup" CssClass="field-error" ErrorMessage="Passwords do not match." Display="Dynamic" />
                                </div>
                            </div>
                            <asp:Button ID="btnChangePassword" runat="server" CssClass="btn btn-outline" Text="Update Password" ValidationGroup="PasswordGroup" OnClick="btnChangePassword_Click" />
                        </div>
                    </div>

                </div>
            </div>
        </div>
    </section>

    <style>
        .profile-clean-layout { display: grid; grid-template-columns: 280px 1fr; gap: var(--space-6); align-items: start; }
        .profile-sidebar { display: flex; flex-direction: column; gap: var(--space-4); }
        .profile-summary-card { text-align: center; }
        .profile-clean-avatar { width: 72px; height: 72px; border-radius: 50%; background: var(--brand-primary); color: #fff; font-family: var(--font-heading); font-size: 1.6rem; font-weight: 800; display: inline-grid; place-items: center; margin: 0 auto var(--space-3); box-shadow: 0 4px 14px var(--brand-primary-glow); }
        .profile-clean-name { font-size: 1.25rem; margin-bottom: 2px; }
        .profile-clean-email { color: var(--text-muted); font-size: 13.5px; margin-bottom: var(--space-2); }
        .stat-clean-row { display: flex; align-items: center; gap: var(--space-3); }
        .stat-clean-icon { width: 36px; height: 36px; border-radius: var(--radius-md); display: grid; place-items: center; }
        .stat-clean-icon svg { width: 18px; height: 18px; }
        .bg-warm { background: var(--brand-warm-soft); color: var(--brand-warm); }
        .bg-primary { background: var(--brand-primary-soft); color: var(--brand-primary); }
        .active-course-list { display: flex; flex-direction: column; gap: var(--space-4); }
        .active-course-row { display: flex; align-items: center; gap: var(--space-4); padding-bottom: var(--space-4); border-bottom: 1px solid var(--border-light); }
        .active-course-row:last-child { padding-bottom: 0; border-bottom: none; }
        .active-course-info { flex: 1; min-width: 0; }
        .active-course-name { font-weight: 700; font-size: 14.5px; color: var(--text-primary); }
        .active-course-meta { font-size: 12.5px; color: var(--text-muted); margin-top: 2px; }
        @media (max-width: 860px) { .profile-clean-layout { grid-template-columns: 1fr; } }
    </style>

</asp:Content>
