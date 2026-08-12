<%@ Page Title="Admin Dashboard" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Default.aspx.cs" Inherits="binary.Admin.AdminHome" %>

<asp:Content ID="BodyContent" ContentPlaceHolderID="MainContent" runat="server">

    <%-- Dashboard Header --%>
    <div class="admin-header">
        <div class="site-container admin-header-inner">
            <div>
                <h1>Admin Dashboard</h1>
                <p style="color:var(--text-muted);font-size:15px;">Platform overview — <%: DateTime.Now.ToString("dddd, MMMM d, yyyy") %></p>
            </div>
            <div style="display:flex;gap:var(--space-3);">
                <a class="btn btn-outline" runat="server" href="~/Admin/Courses.aspx">Manage Courses</a>
                <a class="btn btn-primary" runat="server" href="~/Admin/Users.aspx">Manage Users</a>
            </div>
        </div>
    </div>

    <section class="section-sm">
        <div class="site-container">

            <%-- KPI Cards --%>
            <div class="grid-4 admin-kpis">
                <div class="kpi-card card card-body">
                    <div class="kpi-icon" style="color:var(--brand-primary);">&#128100;</div>
                    <div class="kpi-value">2,148,309</div>
                    <div class="kpi-label">Total Users</div>
                    <div class="kpi-trend kpi-trend-up">&#8593; 12.4% this month</div>
                </div>
                <div class="kpi-card card card-body">
                    <div class="kpi-icon" style="color:var(--brand-secondary);">&#128218;</div>
                    <div class="kpi-value">54</div>
                    <div class="kpi-label">Active Courses</div>
                    <div class="kpi-trend kpi-trend-up">&#8593; 3 new this week</div>
                </div>
                <div class="kpi-card card card-body">
                    <div class="kpi-icon" style="color:var(--brand-accent);">&#127942;</div>
                    <div class="kpi-value">841,220</div>
                    <div class="kpi-label">Lessons Completed</div>
                    <div class="kpi-trend kpi-trend-up">&#8593; 8.1% this month</div>
                </div>
                <div class="kpi-card card card-body">
                    <div class="kpi-icon" style="color:hsl(0,75%,60%);">&#128293;</div>
                    <div class="kpi-value">73%</div>
                    <div class="kpi-label">Avg. Retention</div>
                    <div class="kpi-trend kpi-trend-down">&#8595; 2.1% vs last month</div>
                </div>
            </div>

            <%-- Main Grid: Table + Side --%>
            <div class="admin-main-grid">

                <%-- Recent Users --%>
                <div class="card">
                    <div class="card-header" style="display:flex;align-items:center;justify-content:space-between;">
                        <h3 style="font-size:1.05rem;">Recent Registrations</h3>
                        <a class="btn btn-ghost" style="font-size:13px;" runat="server" href="~/Admin/Users.aspx">View All &rarr;</a>
                    </div>
                    <div style="overflow-x:auto;">
                        <table class="admin-table">
                            <thead>
                                <tr>
                                    <th>User</th>
                                    <th>Email</th>
                                    <th>Joined</th>
                                    <th>Status</th>
                                    <th>Action</th>
                                </tr>
                            </thead>
                            <tbody>
                                <tr>
                                    <td><div class="tbl-user"><div class="tbl-avatar" style="background:hsl(246,80%,60%);">AM</div>Alex Martinez</div></td>
                                    <td>alex.m@email.com</td>
                                    <td>Aug 12, 2026</td>
                                    <td><span class="badge badge-success">Active</span></td>
                                    <td><a class="btn btn-ghost" style="height:30px;font-size:12px;padding:0 10px;" href="#">Edit</a></td>
                                </tr>
                                <tr>
                                    <td><div class="tbl-user"><div class="tbl-avatar" style="background:hsl(168,78%,42%);">SK</div>Sara Kim</div></td>
                                    <td>sara.kim@email.com</td>
                                    <td>Aug 11, 2026</td>
                                    <td><span class="badge badge-success">Active</span></td>
                                    <td><a class="btn btn-ghost" style="height:30px;font-size:12px;padding:0 10px;" href="#">Edit</a></td>
                                </tr>
                                <tr>
                                    <td><div class="tbl-user"><div class="tbl-avatar" style="background:hsl(32,100%,60%);">JL</div>James Lee</div></td>
                                    <td>james.lee@email.com</td>
                                    <td>Aug 10, 2026</td>
                                    <td><span class="badge badge-muted">Inactive</span></td>
                                    <td><a class="btn btn-ghost" style="height:30px;font-size:12px;padding:0 10px;" href="#">Edit</a></td>
                                </tr>
                                <tr>
                                    <td><div class="tbl-user"><div class="tbl-avatar" style="background:hsl(280,80%,60%);">NP</div>Nadia Patel</div></td>
                                    <td>nadia.p@email.com</td>
                                    <td>Aug 9, 2026</td>
                                    <td><span class="badge badge-success">Active</span></td>
                                    <td><a class="btn btn-ghost" style="height:30px;font-size:12px;padding:0 10px;" href="#">Edit</a></td>
                                </tr>
                                <tr>
                                    <td><div class="tbl-user"><div class="tbl-avatar" style="background:hsl(200,80%,50%);">CO</div>Carlos Ortiz</div></td>
                                    <td>c.ortiz@email.com</td>
                                    <td>Aug 8, 2026</td>
                                    <td><span class="badge badge-warning">Pending</span></td>
                                    <td><a class="btn btn-ghost" style="height:30px;font-size:12px;padding:0 10px;" href="#">Edit</a></td>
                                </tr>
                            </tbody>
                        </table>
                    </div>
                </div>

                <%-- Quick Actions --%>
                <div class="admin-side">
                    <div class="card card-body">
                        <h3 style="font-size:1.05rem;margin-bottom:var(--space-4);">Quick Actions</h3>
                        <div class="quick-actions">
                            <a class="quick-action-btn" runat="server" href="~/Admin/Courses.aspx">
                                <span class="quick-action-icon">&#128218;</span>
                                <span>Add New Course</span>
                            </a>
                            <a class="quick-action-btn" runat="server" href="~/Admin/Users.aspx">
                                <span class="quick-action-icon">&#128100;</span>
                                <span>Invite Users</span>
                            </a>
                            <a class="quick-action-btn" href="#">
                                <span class="quick-action-icon">&#128202;</span>
                                <span>Export Report</span>
                            </a>
                            <a class="quick-action-btn" href="#">
                                <span class="quick-action-icon">&#128276;</span>
                                <span>Send Announcement</span>
                            </a>
                        </div>
                    </div>

                    <div class="card card-body" style="margin-top:var(--space-4);">
                        <h3 style="font-size:1.05rem;margin-bottom:var(--space-4);">Top Languages This Month</h3>
                        <div class="top-langs">
                            <div class="top-lang-item"><span>&#127480;&#127477; Spanish</span><div class="progress" style="flex:1;"><div class="progress-bar" style="width:82%"></div></div><span style="font-size:13px;font-weight:700;">82%</span></div>
                            <div class="top-lang-item"><span>&#127471;&#127477; Japanese</span><div class="progress" style="flex:1;"><div class="progress-bar" style="width:68%"></div></div><span style="font-size:13px;font-weight:700;">68%</span></div>
                            <div class="top-lang-item"><span>&#127467;&#127479; French</span><div class="progress" style="flex:1;"><div class="progress-bar" style="width:57%"></div></div><span style="font-size:13px;font-weight:700;">57%</span></div>
                            <div class="top-lang-item"><span>&#127472;&#127479; Korean</span><div class="progress" style="flex:1;"><div class="progress-bar" style="width:44%"></div></div><span style="font-size:13px;font-weight:700;">44%</span></div>
                            <div class="top-lang-item"><span>&#127465;&#127466; German</span><div class="progress" style="flex:1;"><div class="progress-bar" style="width:38%"></div></div><span style="font-size:13px;font-weight:700;">38%</span></div>
                        </div>
                    </div>
                </div>
            </div>

        </div>
    </section>

    <style>
        .admin-header { background:var(--surface-base);border-bottom:1px solid var(--border-light);padding:var(--space-5) 0; }
        .admin-header-inner { display:flex;align-items:center;justify-content:space-between;gap:var(--space-4);flex-wrap:wrap; }
        .admin-header h1 { font-size:1.6rem;letter-spacing:-0.5px; }
        .admin-kpis { margin-bottom:var(--space-6); }
        .kpi-card { text-align:center; }
        .kpi-icon { font-size:2rem;margin-bottom:var(--space-2); }
        .kpi-value { font-size:2rem;font-weight:900;font-family:'Plus Jakarta Sans',sans-serif;letter-spacing:-1px;margin-bottom:4px; }
        .kpi-label { font-size:13px;font-weight:600;color:var(--text-muted); }
        .kpi-trend { font-size:12px;font-weight:600;margin-top:var(--space-2); }
        .kpi-trend-up { color:var(--brand-secondary); }
        .kpi-trend-down { color:hsl(0,75%,55%); }
        .admin-main-grid { display:grid;grid-template-columns:1fr 320px;gap:var(--space-5); }
        .admin-table { width:100%;border-collapse:collapse;font-size:14px; }
        .admin-table th { text-align:left;padding:var(--space-3) var(--space-4);font-size:12px;font-weight:700;text-transform:uppercase;letter-spacing:0.6px;color:var(--text-muted);border-bottom:1px solid var(--border-light);background:var(--surface-overlay); }
        .admin-table td { padding:var(--space-3) var(--space-4);border-bottom:1px solid var(--border-light);vertical-align:middle; }
        .admin-table tr:last-child td { border-bottom:none; }
        .admin-table tr:hover td { background:var(--surface-overlay); }
        .tbl-user { display:flex;align-items:center;gap:var(--space-3);font-weight:600; }
        .tbl-avatar { width:32px;height:32px;border-radius:50%;display:inline-grid;place-items:center;color:#fff;font-size:11px;font-weight:800;flex-shrink:0; }
        .quick-actions { display:flex;flex-direction:column;gap:var(--space-2); }
        .quick-action-btn { display:flex;align-items:center;gap:var(--space-3);padding:var(--space-3) var(--space-4);border-radius:var(--radius-md);background:var(--surface-overlay);font-size:14px;font-weight:600;color:var(--text-primary);transition:all var(--dur-fast) var(--ease); }
        .quick-action-btn:hover { background:hsla(246,80%,60%,0.08);color:var(--brand-primary); }
        .quick-action-icon { font-size:1.2rem;flex-shrink:0; }
        .top-langs { display:flex;flex-direction:column;gap:var(--space-3); }
        .top-lang-item { display:flex;align-items:center;gap:var(--space-3);font-size:14px;font-weight:600; }
        .top-lang-item > span:first-child { width:100px;flex-shrink:0; }
        @media (max-width:900px) { .admin-main-grid { grid-template-columns:1fr; } }
    </style>

</asp:Content>
