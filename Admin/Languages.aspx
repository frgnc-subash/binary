<%@ Page Title="Languages" Language="C#" MasterPageFile="~/MasterPages/AdminMaster.master" AutoEventWireup="true" CodeBehind="Languages.aspx.cs" Inherits="binary.Admin.AdminLanguages" %>

<asp:Content ID="HeaderTitle" ContentPlaceHolderID="AdminHeaderTitle" runat="server">Languages</asp:Content>
<asp:Content ID="HeaderSubtitle" ContentPlaceHolderID="AdminHeaderSubtitle" runat="server">Manage language families used to group courses.</asp:Content>
<asp:Content ID="HeaderActions" ContentPlaceHolderID="AdminHeaderActions" runat="server">
    <a class="btn btn-outline" runat="server" href="~/Admin"><svg class="ui-icon ui-icon-before" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" aria-hidden="true"><line x1="19" y1="12" x2="5" y2="12"></line><polyline points="12 19 5 12 12 5"></polyline></svg>Dashboard</a>
    <a class="btn btn-primary" runat="server" href="~/Admin/Languages.aspx?new=1"><svg class="ui-icon ui-icon-before" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" aria-hidden="true"><line x1="12" y1="5" x2="12" y2="19"></line><line x1="5" y1="12" x2="19" y2="12"></line></svg>New Language Family</a>
</asp:Content>

<asp:Content ID="BodyContent" ContentPlaceHolderID="AdminMainContent" runat="server">

    <asp:HiddenField ID="hfLanguagesPage" runat="server" Value="1" />

    <asp:Panel ID="pnlActionSuccess" runat="server" CssClass="auth-alert auth-alert-success" Visible="false" style="margin-bottom:var(--space-4);">
        <asp:Literal ID="litActionSuccess" runat="server" />
    </asp:Panel>

    <asp:Panel ID="pnlLanguageError" runat="server" CssClass="auth-alert auth-alert-error" Visible="false" style="margin-bottom:var(--space-4);">
        <asp:Literal ID="litLanguageError" runat="server" />
    </asp:Panel>

    <%-- add / edit language family form --%>
    <asp:Panel ID="pnlLanguageForm" runat="server" Visible="false">
        <div class="card" style="margin-bottom:var(--space-6);max-width:520px;">
            <div class="card-header"><h3 style="font-size:1.05rem;"><asp:Literal ID="litFormTitle" runat="server">Add Language Family</asp:Literal></h3></div>
            <div class="card-body">
                <asp:HiddenField ID="hfCategoryId" runat="server" />
                <div class="form-group">
                    <label class="form-label" for="txtLanguageName">Name</label>
                    <asp:TextBox ID="txtLanguageName" runat="server" CssClass="form-control" placeholder="European Languages" />
                </div>
                <asp:Button ID="btnSaveLanguage" runat="server" CssClass="btn btn-primary" Text="Save" OnClick="btnSaveLanguage_Click" />
                <a class="btn btn-outline" runat="server" href="~/Admin/Languages.aspx">Cancel</a>
            </div>
        </div>
    </asp:Panel>

    <div class="admin-section-label">Overview</div>
    <div class="grid-3" style="margin-bottom:var(--space-8);">
        <div class="card kpi-card">
            <div class="kpi-icon"><svg class="admin-icon" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.75" stroke-linecap="round" stroke-linejoin="round"><circle cx="12" cy="12" r="9"></circle><path d="M3 12h18"></path><path d="M12 3c2.5 2.7 2.5 15.3 0 18"></path><path d="M12 3c-2.5 2.7-2.5 15.3 0 18"></path></svg></div>
            <div>
                <div class="kpi-value"><asp:Literal ID="litTotalLanguages" runat="server">0</asp:Literal></div>
                <div class="kpi-label">Language Families</div>
            </div>
        </div>
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
                <div class="kpi-value"><asp:Literal ID="litTotalLearners" runat="server">0</asp:Literal></div>
                <div class="kpi-label">Enrolled Learners</div>
            </div>
        </div>
    </div>

    <div class="card">
        <div class="card-header"><h3 style="font-size:1.05rem;">All Language Families</h3></div>

        <asp:Panel ID="pnlLanguageFilters" runat="server" CssClass="filter-bar" DefaultButton="btnLanguageSearch">
            <div class="filter-bar-search">
                <svg class="filter-bar-icon" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" aria-hidden="true"><circle cx="11" cy="11" r="7"/><line x1="21" y1="21" x2="16.65" y2="16.65"/></svg>
                <asp:TextBox ID="txtLanguageSearch" runat="server" CssClass="form-control" TextMode="Search" placeholder="Search by name" aria-label="Search language families" />
            </div>
            <asp:Button ID="btnLanguageSearch" runat="server" CssClass="btn btn-outline" Text="Search" OnClick="btnLanguageSearch_Click" />
        </asp:Panel>
        <asp:Panel ID="pnlLanguageFilterSummary" runat="server" CssClass="filter-summary" Visible="false">
            <span><asp:Literal ID="litLanguageFilterSummary" runat="server" /></span>
            <asp:LinkButton ID="lnkClearLanguageFilters" runat="server" CssClass="filter-clear" OnClick="lnkClearLanguageFilters_Click">Clear search</asp:LinkButton>
        </asp:Panel>

        <asp:Panel ID="pnlLanguageList" runat="server">
            <div style="overflow-x:auto;">
                <table class="admin-table">
                    <thead><tr><th>Name</th><th>Courses</th><th>Learners</th><th style="text-align:right;">Action</th></tr></thead>
                    <tbody>
                        <asp:Repeater ID="rptLanguages" runat="server" OnItemCommand="rptLanguages_ItemCommand">
                            <ItemTemplate>
                                <tr>
                                    <td style="font-weight:700;color:var(--text-primary);"><%# HttpUtility.HtmlEncode((string)Eval("CategoryName")) %></td>
                                    <td><%# Eval("CourseCount") %></td>
                                    <td><%# Eval("LearnerCount") %></td>
                                    <td style="text-align:right;">
                                        <a class="btn btn-ghost" style="height:30px;font-size:12px;padding:0 10px;" href='<%# ResolveUrl("~/Admin/Languages.aspx?id=" + Eval("CategoryId")) %>'>Edit</a>
                                        <asp:LinkButton runat="server" CssClass="btn btn-ghost text-danger" style="height:30px;font-size:12px;padding:0 10px;" CommandName="DeleteLanguage" CommandArgument='<%# Eval("CategoryId") %>' OnClientClick="return BinaryUI.confirm(this, { title: 'Delete this language family?', text: 'This only works when no courses use it.', ok: 'Delete' });">Delete</asp:LinkButton>
                                    </td>
                                </tr>
                            </ItemTemplate>
                        </asp:Repeater>
                    </tbody>
                </table>
            </div>
            <div class="pagination-bar">
                <asp:Literal ID="litLanguagePageInfo" runat="server" />
                <div class="pager-controls">
                    <asp:LinkButton ID="lnkLanguagePrevPage" runat="server" CssClass="btn btn-outline" style="height:32px;font-size:12px;padding:0 14px;" OnClick="lnkLanguagePrevPage_Click"><svg class="admin-icon" style="width:14px;height:14px;" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><polyline points="15 18 9 12 15 6"></polyline></svg> Prev</asp:LinkButton>
                    <asp:LinkButton ID="lnkLanguageNextPage" runat="server" CssClass="btn btn-outline" style="height:32px;font-size:12px;padding:0 14px;" OnClick="lnkLanguageNextPage_Click">Next <svg class="admin-icon" style="width:14px;height:14px;" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><polyline points="9 18 15 12 9 6"></polyline></svg></asp:LinkButton>
                </div>
            </div>
        </asp:Panel>
        <asp:Panel ID="pnlNoLanguages" runat="server" Visible="false" style="text-align:center;color:var(--text-muted);padding:var(--space-8) var(--space-4);">
            <div style="width:44px;height:44px;margin:0 auto var(--space-3);border-radius:50%;background:rgba(67,56,202,0.1);color:var(--brand-primary);display:grid;place-items:center;"><svg class="admin-icon" style="width:22px;height:22px;" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.75" stroke-linecap="round" stroke-linejoin="round"><circle cx="12" cy="12" r="9"></circle><path d="M3 12h18"></path><path d="M12 3c2.5 2.7 2.5 15.3 0 18"></path><path d="M12 3c-2.5 2.7-2.5 15.3 0 18"></path></svg></div>
            <h4 style="font-weight:700;color:var(--text-primary);">No language families found</h4>
            <p style="font-size:13.5px;">Try adjusting your search, or add a new one above.</p>
        </asp:Panel>
    </div>

</asp:Content>
