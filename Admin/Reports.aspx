<%@ Page Title="Reports" Language="C#" MasterPageFile="~/MasterPages/AdminMaster.master" AutoEventWireup="true" CodeBehind="Reports.aspx.cs" Inherits="binary.Admin.AdminReports" %>

<asp:Content ID="HeaderTitle" ContentPlaceHolderID="AdminHeaderTitle" runat="server">Reports</asp:Content>
<asp:Content ID="HeaderSubtitle" ContentPlaceHolderID="AdminHeaderSubtitle" runat="server">Platform analytics, top courses, and recent activity.</asp:Content>
<asp:Content ID="HeaderActions" ContentPlaceHolderID="AdminHeaderActions" runat="server">
    <a class="btn btn-outline" runat="server" href="~/Admin"><svg class="ui-icon ui-icon-before" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" aria-hidden="true"><line x1="19" y1="12" x2="5" y2="12"></line><polyline points="12 19 5 12 12 5"></polyline></svg>Dashboard</a>
</asp:Content>

<asp:Content ID="BodyContent" ContentPlaceHolderID="AdminMainContent" runat="server">

    <div class="admin-section-label">Platform Analytics</div>

    <div class="grid-4" style="margin-bottom:var(--space-8);">
        <div class="card kpi-card">
            <div class="kpi-icon"><svg class="admin-icon" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.75" stroke-linecap="round" stroke-linejoin="round"><path d="M2 4.5h6a4 4 0 0 1 4 4v11a3 3 0 0 0-3-3H2z"></path><path d="M22 4.5h-6a4 4 0 0 0-4 4v11a3 3 0 0 1 3-3h7z"></path></svg></div>
            <div>
                <div class="kpi-value"><asp:Literal ID="litTotalCourses" runat="server">0</asp:Literal></div>
                <div class="kpi-label">Total Courses</div>
            </div>
        </div>
        <div class="card kpi-card">
            <div class="kpi-icon"><svg class="admin-icon" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.75" stroke-linecap="round" stroke-linejoin="round"><path d="M22 10 12 5 2 10l10 5 10-5Z"></path><path d="M6 12v5c0 1.5 3 3 6 3s6-1.5 6-3v-5"></path></svg></div>
            <div>
                <div class="kpi-value"><asp:Literal ID="litTotalEnrollments" runat="server">0</asp:Literal></div>
                <div class="kpi-label">Total Enrollments</div>
            </div>
        </div>
        <div class="card kpi-card">
            <div class="kpi-icon"><svg class="admin-icon" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.75" stroke-linecap="round" stroke-linejoin="round"><path d="m3 7 2 2 4-4"></path><path d="m3 15 2 2 4-4"></path><line x1="11" y1="8" x2="21" y2="8"></line><line x1="11" y1="16" x2="21" y2="16"></line></svg></div>
            <div>
                <div class="kpi-value"><asp:Literal ID="litQuizAttempts" runat="server">0</asp:Literal></div>
                <div class="kpi-label">Quiz Attempts</div>
            </div>
        </div>
        <div class="card kpi-card">
            <div class="kpi-icon"><svg class="admin-icon" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.75" stroke-linecap="round" stroke-linejoin="round"><circle cx="12" cy="12" r="9"></circle><circle cx="12" cy="12" r="5"></circle><circle cx="12" cy="12" r="1"></circle></svg></div>
            <div>
                <div class="kpi-value"><asp:Literal ID="litAvgScore" runat="server">0%</asp:Literal></div>
                <div class="kpi-label">Avg Quiz Score</div>
            </div>
        </div>
    </div>

    <%-- one column: health, top courses, then the activity feed at full width --%>
    <div style="display:flex;flex-direction:column;gap:var(--space-6);min-width:0;">

        <%-- Published vs Draft --%>
        <div class="card card-body">
            <div style="display:flex;align-items:center;justify-content:space-between;margin-bottom:var(--space-3);">
                <h3 style="font-size:1.05rem;font-weight:700;">Catalogue Health</h3>
                <span style="font-size:12.5px;color:var(--text-muted);"><asp:Literal ID="litPublishedCount" runat="server">0</asp:Literal> published &bull; <asp:Literal ID="litDraftCount" runat="server">0</asp:Literal> draft</span>
            </div>
            <div class="segment-bar">
                <div style="background:#10b981;height:100%;float:left;" runat="server" id="segPublished"></div>
                <div style="background:#e2e8f0;height:100%;float:left;" runat="server" id="segDraft"></div>
            </div>
            <div style="display:flex;gap:16px;font-size:11.5px;font-weight:600;margin-top:10px;">
                <span style="display:flex;align-items:center;gap:4px;"><span style="width:8px;height:8px;border-radius:50%;background:#10b981;"></span> Published</span>
                <span style="display:flex;align-items:center;gap:4px;"><span style="width:8px;height:8px;border-radius:50%;background:#e2e8f0;"></span> Draft</span>
            </div>
        </div>

        <%-- Top Courses --%>
        <div class="card">
            <div class="card-header"><h3 style="font-size:1.05rem;">Top Courses by Enrollment</h3></div>
            <div style="overflow-x:auto;">
                <table class="admin-table">
                    <thead><tr><th>Course</th><th>Language Family</th><th style="text-align:right;">Learners</th></tr></thead>
                    <tbody>
                        <asp:Repeater ID="rptTopCourses" runat="server">
                            <ItemTemplate>
                                <tr>
                                    <td style="font-weight:700;color:var(--text-primary);"><%# HttpUtility.HtmlEncode((string)Eval("CourseTitle")) %></td>
                                    <td><%# HttpUtility.HtmlEncode((string)Eval("CategoryName")) %></td>
                                    <td style="text-align:right;font-weight:700;"><%# Eval("EnrollmentCount") %></td>
                                </tr>
                            </ItemTemplate>
                        </asp:Repeater>
                    </tbody>
                </table>
            </div>
        </div>

    <%-- Activity Feed --%>
        <div class="card card-body">
            <h3 style="font-size:1.05rem;font-weight:700;margin-bottom:var(--space-3);">Recent Activity</h3>
            <div style="display:grid;grid-template-columns:repeat(auto-fill, minmax(300px, 1fr));gap:var(--space-4) var(--space-6);">
                <asp:Repeater ID="rptActivity" runat="server">
                    <ItemTemplate>
                        <div style="display:flex;gap:10px;align-items:flex-start;">
                            <div style="width:28px;height:28px;border-radius:50%;background:rgba(67,56,202,0.1);color:var(--brand-primary);display:grid;place-items:center;flex-shrink:0;"><%# Eval("Icon") %></div>
                            <div style="min-width:0;">
                                <div style="font-size:13px;color:var(--text-primary);font-weight:600;line-height:1.4;"><%# HttpUtility.HtmlEncode((string)Eval("Text")) %></div>
                                <div style="font-size:11px;color:var(--text-muted);"><%# Eval("Date", "{0:MMM d, h:mm tt}") %></div>
                            </div>
                        </div>
                    </ItemTemplate>
                </asp:Repeater>
                <asp:Panel ID="pnlNoActivity" runat="server" Visible="false" style="grid-column:1/-1;text-align:center;color:var(--text-muted);font-size:13px;padding:var(--space-4) 0;">
                    No activity recorded yet.
                </asp:Panel>
            </div>
        </div>
    </div>

</asp:Content>
