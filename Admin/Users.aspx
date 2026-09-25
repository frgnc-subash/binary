<%@ Page Title="Manage Users" Language="C#" MasterPageFile="~/MasterPages/AdminMaster.master" AutoEventWireup="true" CodeBehind="Users.aspx.cs" Inherits="binary.Admin.AdminUsers" %>

<asp:Content ID="HeaderTitle" ContentPlaceHolderID="AdminHeaderTitle" runat="server">Manage Users</asp:Content>
<asp:Content ID="HeaderSubtitle" ContentPlaceHolderID="AdminHeaderSubtitle" runat="server">Create, edit, and remove learner and admin accounts.</asp:Content>
<asp:Content ID="HeaderActions" ContentPlaceHolderID="AdminHeaderActions" runat="server">
    <a class="btn btn-outline" runat="server" href="~/Admin"><svg class="ui-icon ui-icon-before" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" aria-hidden="true"><line x1="19" y1="12" x2="5" y2="12"></line><polyline points="12 19 5 12 12 5"></polyline></svg>Dashboard</a>
    <a class="btn btn-primary" runat="server" href="~/Admin/Users.aspx?new=1"><svg class="ui-icon ui-icon-before" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" aria-hidden="true"><line x1="12" y1="5" x2="12" y2="19"></line><line x1="5" y1="12" x2="19" y2="12"></line></svg>New User</a>
</asp:Content>

<asp:Content ID="BodyContent" ContentPlaceHolderID="AdminMainContent" runat="server">

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

    <div class="card" data-list="users" data-page-size="8" data-noun="user" data-noun-plural="users">
        <div class="card-header"><h3 style="font-size:1.05rem;">All Users</h3></div>

        <%-- search, filters, sort and paging run in the browser (Scripts/binary-ui.js) --%>
        <div class="filter-bar">
            <div class="filter-bar-search">
                <svg class="filter-bar-icon" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" aria-hidden="true"><circle cx="11" cy="11" r="7"/><line x1="21" y1="21" x2="16.65" y2="16.65"/></svg>
                <input type="search" class="form-control" data-filter-key="q" placeholder="Search name or email" aria-label="Search users" />
            </div>
            <select class="form-control" data-filter-key="role" aria-label="Role">
                <option value="">All roles</option>
                <option value="1">Admin</option>
                <option value="2">Member</option>
            </select>
            <select class="form-control" data-filter-key="status" aria-label="Status">
                <option value="">Any status</option>
                <option value="active">Active</option>
                <option value="inactive">Inactive</option>
            </select>
            <select class="form-control" data-sort-key="sort" aria-label="Sort by">
                <option value="joined:desc">Newest first</option>
                <option value="name:asc">Name A to Z</option>
                <option value="xp:desc">Most XP</option>
            </select>
        </div>
        <div class="filter-summary" data-list-summary hidden>
            <span data-list-summary-text></span>
            <button type="button" class="filter-clear" data-list-clear>Clear filters</button>
        </div>

        <asp:Panel ID="pnlUserList" runat="server" data-list-body="true">
            <div style="overflow-x:auto;">
                <table class="admin-table">
                    <thead><tr><th>User</th><th>Email</th><th>Joined</th><th>XP</th><th>Role</th><th>Status</th><th style="text-align:right;">Action</th></tr></thead>
                    <tbody>
                        <asp:Repeater ID="rptUsers" runat="server" OnItemCommand="rptUsers_ItemCommand">
                            <ItemTemplate>
                                <tr data-row data-search="<%# GetUserSearchText(Container.DataItem) %>" data-f-role="<%# Eval("RoleID") %>" data-f-status="<%# (bool)Eval("IsActive") ? "active" : "inactive" %>" data-s-name="<%# HttpUtility.HtmlAttributeEncode(Eval("FirstName") + " " + Eval("LastName")) %>" data-s-xp="<%# Eval("TotalXP") %>" data-s-joined="<%# ((DateTime)Eval("CreatedDate")).Ticks %>">
                                    <td><div class="tbl-user"><div class="tbl-avatar" style="background:var(--brand-primary);"><%# binary.Core.Helpers.DisplayHelper.GetInitials((string)Eval("FirstName"), (string)Eval("LastName")) %></div><%# HttpUtility.HtmlEncode((string)Eval("FirstName") + " " + (string)Eval("LastName")) %></div></td>
                                    <td><%# HttpUtility.HtmlEncode((string)Eval("Email")) %></td>
                                    <td><%# Eval("CreatedDate", "{0:MMM d, yyyy}") %></td>
                                    <td><%# Eval("TotalXP") %></td>
                                    <td><%# HttpUtility.HtmlEncode((string)Eval("RoleName")) %></td>
                                    <td><%# (bool)Eval("IsActive") ? "<span class=\"badge badge-success\">Active</span>" : "<span class=\"badge badge-muted\">Inactive</span>" %></td>
                                    <td style="text-align:right;">
                                        <a class="btn btn-ghost" style="height:30px;font-size:12px;padding:0 10px;" href='<%# ResolveUrl("~/Admin/Users.aspx?id=" + Eval("UserID")) %>'>Edit</a>
                                        <asp:LinkButton runat="server" CssClass="btn btn-ghost text-danger" style="height:30px;font-size:12px;padding:0 10px;" Visible='<%# (int)Eval("UserID") != binary.Core.BLL.AuthBLL.CurrentUserId %>' CommandName="DeleteUser" CommandArgument='<%# Eval("UserID") %>' OnClientClick="return BinaryUI.confirm(this, { title: 'Delete this user?', text: 'Their account and sign-in are removed permanently. This cannot be undone.', ok: 'Delete user' });">Delete</asp:LinkButton>
                                    </td>
                                </tr>
                            </ItemTemplate>
                        </asp:Repeater>
                    </tbody>
                </table>
            </div>
            <div class="pagination-bar">
                <span data-list-page-info></span>
                <div class="pager-controls">
                    <button type="button" class="btn btn-outline btn-pager" data-list-prev><svg class="admin-icon" style="width:14px;height:14px;" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><polyline points="15 18 9 12 15 6"></polyline></svg> Prev</button>
                    <button type="button" class="btn btn-outline btn-pager" data-list-next>Next <svg class="admin-icon" style="width:14px;height:14px;" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><polyline points="9 18 15 12 9 6"></polyline></svg></button>
                </div>
            </div>
        </asp:Panel>
        <asp:Panel ID="pnlNoUsers" runat="server" data-list-empty="true" hidden="hidden" style="text-align:center;color:var(--text-muted);padding:var(--space-8) var(--space-4);">
            <div style="width:44px;height:44px;margin:0 auto var(--space-3);border-radius:50%;background:rgba(67,56,202,0.1);color:var(--brand-primary);display:grid;place-items:center;"><svg class="admin-icon" style="width:22px;height:22px;" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.75" stroke-linecap="round" stroke-linejoin="round"><path d="M17 21v-2a4 4 0 0 0-4-4H5a4 4 0 0 0-4 4v2"></path><circle cx="9" cy="7" r="4"></circle><path d="M23 21v-2a4 4 0 0 0-3-3.87"></path><path d="M16 3.13a4 4 0 0 1 0 7.75"></path></svg></div>
            <h4 style="font-weight:700;color:var(--text-primary);">No users found</h4>
            <p style="font-size:13.5px;">Try adjusting your search or filters.</p>
        </asp:Panel>
    </div>

</asp:Content>
