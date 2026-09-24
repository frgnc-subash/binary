<%@ Page Title="Manage Users" Language="C#" MasterPageFile="~/MasterPages/AdminMaster.master" AutoEventWireup="true" CodeBehind="Users.aspx.cs" Inherits="binary.Admin.AdminUsers" %>

<asp:Content ID="HeaderTitle" ContentPlaceHolderID="AdminHeaderTitle" runat="server">Manage Users</asp:Content>
<asp:Content ID="HeaderSubtitle" ContentPlaceHolderID="AdminHeaderSubtitle" runat="server">Create, edit, and remove learner and admin accounts.</asp:Content>
<asp:Content ID="HeaderActions" ContentPlaceHolderID="AdminHeaderActions" runat="server">
    <a class="btn btn-outline" runat="server" href="~/Admin">&larr; Dashboard</a>
    <a class="btn btn-primary" runat="server" href="~/Admin/Users.aspx?new=1">+ New User</a>
</asp:Content>

<asp:Content ID="BodyContent" ContentPlaceHolderID="AdminMainContent" runat="server">

    <asp:HiddenField ID="hfUsersPage" runat="server" Value="1" />

    <asp:Panel ID="pnlActionSuccess" runat="server" CssClass="auth-alert auth-alert-success" Visible="false" style="margin-bottom:var(--space-4);">
        <asp:Literal ID="litActionSuccess" runat="server" />
    </asp:Panel>

    <asp:Panel ID="pnlUserError" runat="server" CssClass="auth-alert auth-alert-error" Visible="false" style="margin-bottom:var(--space-4);">
        <asp:Literal ID="litUserError" runat="server" />
    </asp:Panel>

    <%-- add / edit user form --%>
    <asp:Panel ID="pnlUserForm" runat="server" Visible="false">
        <div class="card" style="margin-bottom:var(--space-6);max-width:640px;">
            <div class="card-header"><h3 style="font-size:1.05rem;"><asp:Literal ID="litFormTitle" runat="server">Add User</asp:Literal></h3></div>
            <div class="card-body">
                <asp:HiddenField ID="hfUserId" runat="server" />
                <div class="grid-2">
                    <div class="form-group">
                        <label class="form-label" for="txtFirstName">First Name</label>
                        <asp:TextBox ID="txtFirstName" runat="server" CssClass="form-control" placeholder="Jane" />
                    </div>
                    <div class="form-group">
                        <label class="form-label" for="txtLastName">Last Name</label>
                        <asp:TextBox ID="txtLastName" runat="server" CssClass="form-control" placeholder="Doe" />
                    </div>
                </div>
                <div class="form-group">
                    <label class="form-label" for="txtEmail">Email Address</label>
                    <asp:TextBox ID="txtEmail" runat="server" CssClass="form-control" placeholder="jane@example.com" />
                </div>
                <asp:Panel ID="pnlPasswordField" runat="server">
                    <div class="form-group">
                        <label class="form-label" for="txtPassword">Password</label>
                        <asp:TextBox ID="txtPassword" runat="server" CssClass="form-control" TextMode="Password" placeholder="Min. 8 characters" />
                    </div>
                </asp:Panel>
                <div class="grid-2">
                    <div class="form-group">
                        <label class="form-label" for="ddlRole">Role</label>
                        <asp:DropDownList ID="ddlRole" runat="server" CssClass="form-control">
                            <asp:ListItem Text="Member" Value="2" />
                            <asp:ListItem Text="Admin" Value="1" />
                        </asp:DropDownList>
                    </div>
                    <div class="form-group" style="flex-direction:row;align-items:center;gap:var(--space-2);margin-top:26px;">
                        <asp:CheckBox ID="chkActive" runat="server" Checked="true" />
                        <label for="chkActive" style="font-size:13.5px;color:var(--text-secondary);">Active account</label>
                    </div>
                </div>
                <asp:Literal ID="litSelfEditNote" runat="server" Visible="false"><p style="font-size:12.5px;color:var(--text-muted);margin-bottom:var(--space-3);">You can't change your own role or active status.</p></asp:Literal>
                <asp:Button ID="btnSaveUser" runat="server" CssClass="btn btn-primary" Text="Save User" OnClick="btnSaveUser_Click" />
                <a class="btn btn-outline" runat="server" href="~/Admin/Users.aspx">Cancel</a>
            </div>
        </div>
    </asp:Panel>

    <div class="card">
        <div class="card-header"><h3 style="font-size:1.05rem;">All Users</h3></div>

        <div class="filter-bar">
            <div class="filter-bar-search">
                <asp:TextBox ID="txtUserSearch" runat="server" CssClass="form-control" placeholder="Search by name or email…" />
            </div>
            <asp:DropDownList ID="ddlRoleFilter" runat="server" CssClass="form-control">
                <asp:ListItem Text="All Roles" Value="" />
                <asp:ListItem Text="Admin" Value="1" />
                <asp:ListItem Text="Member" Value="2" />
            </asp:DropDownList>
            <asp:DropDownList ID="ddlStatusFilter" runat="server" CssClass="form-control">
                <asp:ListItem Text="All Statuses" Value="" />
                <asp:ListItem Text="Active" Value="active" />
                <asp:ListItem Text="Inactive" Value="inactive" />
            </asp:DropDownList>
            <asp:Button ID="btnUserSearch" runat="server" CssClass="btn btn-outline" Text="Search" OnClick="btnUserSearch_Click" />
        </div>

        <asp:Panel ID="pnlUserList" runat="server">
            <div style="overflow-x:auto;">
                <table class="admin-table">
                    <thead><tr><th>User</th><th>Email</th><th>Joined</th><th>XP</th><th>Role</th><th>Status</th><th style="text-align:right;">Action</th></tr></thead>
                    <tbody>
                        <asp:Repeater ID="rptUsers" runat="server" OnItemCommand="rptUsers_ItemCommand">
                            <ItemTemplate>
                                <tr>
                                    <td><div class="tbl-user"><div class="tbl-avatar" style="background:var(--brand-primary);"><%# binary.Core.Helpers.DisplayHelper.GetInitials((string)Eval("FirstName"), (string)Eval("LastName")) %></div><%# HttpUtility.HtmlEncode((string)Eval("FirstName") + " " + (string)Eval("LastName")) %></div></td>
                                    <td><%# HttpUtility.HtmlEncode((string)Eval("Email")) %></td>
                                    <td><%# Eval("CreatedDate", "{0:MMM d, yyyy}") %></td>
                                    <td><%# Eval("TotalXP") %></td>
                                    <td><%# HttpUtility.HtmlEncode((string)Eval("RoleName")) %></td>
                                    <td><%# (bool)Eval("IsActive") ? "<span class=\"badge badge-success\">Active</span>" : "<span class=\"badge badge-muted\">Inactive</span>" %></td>
                                    <td style="text-align:right;">
                                        <a class="btn btn-ghost" style="height:30px;font-size:12px;padding:0 10px;" href='<%# ResolveUrl("~/Admin/Users.aspx?id=" + Eval("UserID")) %>'>Edit</a>
                                        <asp:LinkButton runat="server" CssClass="btn btn-ghost text-danger" style="height:30px;font-size:12px;padding:0 10px;" Visible='<%# (int)Eval("UserID") != binary.Core.BLL.AuthBLL.CurrentUserId %>' CommandName="DeleteUser" CommandArgument='<%# Eval("UserID") %>' OnClientClick="return confirm('Delete this user account? This cannot be undone.');">Delete</asp:LinkButton>
                                    </td>
                                </tr>
                            </ItemTemplate>
                        </asp:Repeater>
                    </tbody>
                </table>
            </div>
            <div class="pagination-bar">
                <asp:Literal ID="litPageInfo" runat="server" />
                <div class="pager-controls">
                    <asp:LinkButton ID="lnkPrevPage" runat="server" CssClass="btn btn-outline" style="height:32px;font-size:12px;padding:0 14px;" OnClick="lnkPrevPage_Click"><svg class="admin-icon" style="width:14px;height:14px;" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><polyline points="15 18 9 12 15 6"></polyline></svg> Prev</asp:LinkButton>
                    <asp:LinkButton ID="lnkNextPage" runat="server" CssClass="btn btn-outline" style="height:32px;font-size:12px;padding:0 14px;" OnClick="lnkNextPage_Click">Next <svg class="admin-icon" style="width:14px;height:14px;" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><polyline points="9 18 15 12 9 6"></polyline></svg></asp:LinkButton>
                </div>
            </div>
        </asp:Panel>
        <asp:Panel ID="pnlNoUsers" runat="server" Visible="false" style="text-align:center;color:var(--text-muted);padding:var(--space-8) var(--space-4);">
            <div style="width:44px;height:44px;margin:0 auto var(--space-3);border-radius:50%;background:rgba(67,56,202,0.1);color:var(--brand-primary);display:grid;place-items:center;"><svg class="admin-icon" style="width:22px;height:22px;" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.75" stroke-linecap="round" stroke-linejoin="round"><path d="M17 21v-2a4 4 0 0 0-4-4H5a4 4 0 0 0-4 4v2"></path><circle cx="9" cy="7" r="4"></circle><path d="M23 21v-2a4 4 0 0 0-3-3.87"></path><path d="M16 3.13a4 4 0 0 1 0 7.75"></path></svg></div>
            <h4 style="font-weight:700;color:var(--text-primary);">No users found</h4>
            <p style="font-size:13.5px;">Try adjusting your search or filters.</p>
        </asp:Panel>
    </div>

</asp:Content>
