<%@ Page Title="Manage Courses" Language="C#" MasterPageFile="~/MasterPages/AdminMaster.master" AutoEventWireup="true" CodeBehind="Courses.aspx.cs" Inherits="binary.Admin.AdminCourses" %>

<asp:Content ID="HeaderTitle" ContentPlaceHolderID="AdminHeaderTitle" runat="server">Manage Courses</asp:Content>
<asp:Content ID="HeaderSubtitle" ContentPlaceHolderID="AdminHeaderSubtitle" runat="server">Create categories, courses, and lessons.</asp:Content>
<asp:Content ID="HeaderActions" ContentPlaceHolderID="AdminHeaderActions" runat="server">
    <a class="btn btn-outline" runat="server" href="~/Admin">&larr; Dashboard</a>
    <a class="btn btn-primary" runat="server" href="~/Admin/Courses.aspx?new=1">+ New Course</a>
</asp:Content>

<asp:Content ID="BodyContent" ContentPlaceHolderID="AdminMainContent" runat="server">

            <asp:Panel ID="pnlActionSuccess" runat="server" CssClass="auth-alert auth-alert-success" Visible="false" style="margin-bottom:var(--space-4);">
                <asp:Literal ID="litActionSuccess" runat="server" />
            </asp:Panel>

            <div class="admin-main-grid">

                <div>
                    <asp:Panel ID="pnlCourseError" runat="server" CssClass="auth-alert auth-alert-error" Visible="false" style="margin-bottom:var(--space-4);">
                        <asp:Literal ID="litCourseError" runat="server" />
                    </asp:Panel>

                    <%-- add / edit course form --%>
                    <asp:Panel ID="pnlCourseForm" runat="server" Visible="false">
                        <div class="card" style="margin-bottom:var(--space-6);">
                            <div class="card-header"><h3 style="font-size:1.05rem;">Course Details</h3></div>
                            <div class="card-body">
                                <asp:HiddenField ID="hfCourseId" runat="server" />
                                <div class="form-group">
                                    <label class="form-label" for="txtTitle">Title</label>
                                    <asp:TextBox ID="txtTitle" runat="server" CssClass="form-control" placeholder="Spanish for Beginners" />
                                </div>
                                <div class="form-group">
                                    <label class="form-label" for="txtDescription">Description</label>
                                    <asp:TextBox ID="txtDescription" runat="server" CssClass="form-control" TextMode="MultiLine" Rows="3" />
                                </div>
                                <div class="grid-2">
                                    <div class="form-group">
                                        <label class="form-label" for="ddlCategory">Category</label>
                                        <asp:DropDownList ID="ddlCategory" runat="server" CssClass="form-control" DataTextField="Name" DataValueField="CategoryID" />
                                    </div>
                                    <div class="form-group">
                                        <label class="form-label" for="ddlLevel">Level</label>
                                        <asp:DropDownList ID="ddlLevel" runat="server" CssClass="form-control">
                                            <asp:ListItem Text="Beginner" Value="Beginner" />
                                            <asp:ListItem Text="Intermediate" Value="Intermediate" />
                                            <asp:ListItem Text="All Levels" Value="All Levels" />
                                        </asp:DropDownList>
                                    </div>
                                </div>
                                <div class="form-group">
                                    <label class="form-label" for="txtThumbnailUrl">Thumbnail URL (optional)</label>
                                    <asp:TextBox ID="txtThumbnailUrl" runat="server" CssClass="form-control" placeholder="https://..." />
                                </div>
                                <div class="form-group" style="flex-direction:row;align-items:center;gap:var(--space-2);">
                                    <asp:CheckBox ID="chkPublished" runat="server" />
                                    <label for="chkPublished" style="font-size:13.5px;color:var(--text-secondary);">Published (visible in course catalogue)</label>
                                </div>
                                <asp:Button ID="btnSaveCourse" runat="server" CssClass="btn btn-primary" Text="Save Course" OnClick="btnSaveCourse_Click" />
                                <a class="btn btn-outline" runat="server" href="~/Admin/Courses.aspx">Cancel</a>
                            </div>
                        </div>
                    </asp:Panel>

                    <%-- lessons for the course being edited --%>
                    <asp:Panel ID="pnlLessons" runat="server" Visible="false">
                        <asp:Panel ID="pnlLessonError" runat="server" CssClass="auth-alert auth-alert-error" Visible="false" style="margin-bottom:var(--space-4);">
                            <asp:Literal ID="litLessonError" runat="server" />
                        </asp:Panel>
                        <div class="card" style="margin-bottom:var(--space-6);">
                            <div class="card-header"><h3 style="font-size:1.05rem;">Lessons</h3></div>
                            <div style="overflow-x:auto;">
                                <table class="admin-table">
                                    <thead><tr><th>Order</th><th>Title</th><th>Action</th></tr></thead>
                                    <tbody>
                                        <asp:Repeater ID="rptLessons" runat="server" OnItemCommand="rptLessons_ItemCommand">
                                            <ItemTemplate>
                                                <tr>
                                                    <td><%# Eval("SortOrder") %></td>
                                                    <td><%# HttpUtility.HtmlEncode((string)Eval("Title")) %></td>
                                                    <td>
                                                        <asp:LinkButton runat="server" CssClass="btn btn-ghost" style="height:30px;font-size:12px;padding:0 10px;" CommandName="EditLesson" CommandArgument='<%# Eval("LessonID") %>'>Edit</asp:LinkButton>
                                                        <asp:LinkButton runat="server" CssClass="btn btn-ghost text-danger" style="height:30px;font-size:12px;padding:0 10px;" CommandName="DeleteLesson" CommandArgument='<%# Eval("LessonID") %>' OnClientClick="return confirm('Delete this lesson?');">Delete</asp:LinkButton>
                                                    </td>
                                                </tr>
                                            </ItemTemplate>
                                        </asp:Repeater>
                                    </tbody>
                                </table>
                            </div>
                            <div class="card-body" style="border-top:1px solid var(--border-light);">
                                <asp:HiddenField ID="hfLessonId" runat="server" />
                                <div class="form-group">
                                    <label class="form-label" for="txtLessonTitle">Lesson Title</label>
                                    <asp:TextBox ID="txtLessonTitle" runat="server" CssClass="form-control" />
                                </div>
                                <div class="form-group">
                                    <label class="form-label" for="txtLessonContent">Content</label>
                                    <asp:TextBox ID="txtLessonContent" runat="server" CssClass="form-control" TextMode="MultiLine" Rows="3" />
                                </div>
                                <div class="grid-2">
                                    <div class="form-group">
                                        <label class="form-label" for="txtLessonVideoUrl">Video URL (optional)</label>
                                        <asp:TextBox ID="txtLessonVideoUrl" runat="server" CssClass="form-control" />
                                    </div>
                                    <div class="form-group">
                                        <label class="form-label" for="txtLessonSortOrder">Sort Order</label>
                                        <asp:TextBox ID="txtLessonSortOrder" runat="server" CssClass="form-control" Text="0" />
                                    </div>
                                </div>
                                <asp:Button ID="btnSaveLesson" runat="server" CssClass="btn btn-primary" Text="Save Lesson" OnClick="btnSaveLesson_Click" />
                                <a class="btn btn-outline" href="<%= ResolveUrl("~/Admin/Courses.aspx?id=" + hfCourseId.Value) %>">+ New Lesson</a>
                            </div>
                        </div>
                    </asp:Panel>

                    <%-- course list --%>
                    <asp:HiddenField ID="hfCoursesPage" runat="server" Value="1" />
                    <div class="card">
                        <div class="card-header"><h3 style="font-size:1.05rem;">All Courses</h3></div>

                        <div class="filter-bar">
                            <div class="filter-bar-search">
                                <asp:TextBox ID="txtCourseSearch" runat="server" CssClass="form-control" placeholder="Search by title…" />
                            </div>
                            <asp:DropDownList ID="ddlCategoryFilter" runat="server" CssClass="form-control" AppendDataBoundItems="true" DataTextField="Name" DataValueField="CategoryID">
                                <asp:ListItem Text="All Categories" Value="" />
                            </asp:DropDownList>
                            <asp:DropDownList ID="ddlStatusFilter" runat="server" CssClass="form-control">
                                <asp:ListItem Text="All Statuses" Value="" />
                                <asp:ListItem Text="Published" Value="published" />
                                <asp:ListItem Text="Draft" Value="draft" />
                            </asp:DropDownList>
                            <asp:Button ID="btnCourseSearch" runat="server" CssClass="btn btn-outline" Text="Search" OnClick="btnCourseSearch_Click" />
                        </div>

                        <asp:Panel ID="pnlCourseList" runat="server">
                            <div style="overflow-x:auto;">
                                <table class="admin-table">
                                    <thead><tr><th>Title</th><th>Category</th><th>Level</th><th>Status</th><th>Action</th></tr></thead>
                                    <tbody>
                                        <asp:Repeater ID="rptCourses" runat="server" OnItemCommand="rptCourses_ItemCommand">
                                            <ItemTemplate>
                                                <tr>
                                                    <td><%# HttpUtility.HtmlEncode((string)Eval("Title")) %></td>
                                                    <td><%# HttpUtility.HtmlEncode((string)Eval("CategoryName")) %></td>
                                                    <td><%# HttpUtility.HtmlEncode((string)Eval("Level")) %></td>
                                                    <td><%# GetPublishBadge(Eval("IsPublished")) %></td>
                                                    <td>
                                                        <a class="btn btn-ghost" style="height:30px;font-size:12px;padding:0 10px;" href='<%# ResolveUrl("~/Admin/Courses.aspx?id=" + Eval("CourseID")) %>'>Edit</a>
                                                        <asp:LinkButton runat="server" CssClass="btn btn-ghost" style="height:30px;font-size:12px;padding:0 10px;" CommandName="TogglePublish" CommandArgument='<%# Eval("CourseID") %>'><%# GetToggleLabel(Eval("IsPublished")) %></asp:LinkButton>
                                                        <asp:LinkButton runat="server" CssClass="btn btn-ghost text-danger" style="height:30px;font-size:12px;padding:0 10px;" CommandName="DeleteCourse" CommandArgument='<%# Eval("CourseID") %>' OnClientClick="return confirm('Delete this course? This cannot be undone.');">Delete</asp:LinkButton>
                                                    </td>
                                                </tr>
                                            </ItemTemplate>
                                        </asp:Repeater>
                                    </tbody>
                                </table>
                            </div>
                            <div class="pagination-bar">
                                <asp:Literal ID="litCoursePageInfo" runat="server" />
                                <div class="pager-controls">
                                    <asp:LinkButton ID="lnkCoursePrevPage" runat="server" CssClass="btn btn-outline" style="height:32px;font-size:12px;padding:0 14px;" OnClick="lnkCoursePrevPage_Click"><svg class="admin-icon" style="width:14px;height:14px;" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><polyline points="15 18 9 12 15 6"></polyline></svg> Prev</asp:LinkButton>
                                    <asp:LinkButton ID="lnkCourseNextPage" runat="server" CssClass="btn btn-outline" style="height:32px;font-size:12px;padding:0 14px;" OnClick="lnkCourseNextPage_Click">Next <svg class="admin-icon" style="width:14px;height:14px;" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><polyline points="9 18 15 12 9 6"></polyline></svg></asp:LinkButton>
                                </div>
                            </div>
                        </asp:Panel>
                        <asp:Panel ID="pnlNoCourses" runat="server" Visible="false" style="text-align:center;color:var(--text-muted);padding:var(--space-8) var(--space-4);">
                            <div style="width:44px;height:44px;margin:0 auto var(--space-3);border-radius:50%;background:rgba(67,56,202,0.1);color:var(--brand-primary);display:grid;place-items:center;"><svg class="admin-icon" style="width:22px;height:22px;" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.75" stroke-linecap="round" stroke-linejoin="round"><path d="M2 4.5h6a4 4 0 0 1 4 4v11a3 3 0 0 0-3-3H2z"></path><path d="M22 4.5h-6a4 4 0 0 0-4 4v11a3 3 0 0 1 3-3h7z"></path></svg></div>
                            <h4 style="font-weight:700;color:var(--text-primary);">No courses found</h4>
                            <p style="font-size:13.5px;margin-bottom:var(--space-3);">Try adjusting your search or filters, or create a new course.</p>
                            <a class="btn btn-primary" runat="server" href="~/Admin/Courses.aspx?new=1">+ New Course</a>
                        </asp:Panel>
                    </div>
                </div>

                <%-- categories sidebar --%>
                <div class="admin-side">
                    <div class="card card-body">
                        <h3 style="font-size:1.05rem;margin-bottom:var(--space-4);">Categories</h3>

                        <asp:Panel ID="pnlCategoryError" runat="server" CssClass="auth-alert auth-alert-error" Visible="false" style="margin-bottom:var(--space-3);">
                            <asp:Literal ID="litCategoryError" runat="server" />
                        </asp:Panel>

                        <ul style="list-style:none;display:flex;flex-direction:column;gap:var(--space-2);margin-bottom:var(--space-4);">
                            <asp:Repeater ID="rptCategories" runat="server" OnItemCommand="rptCategories_ItemCommand">
                                <ItemTemplate>
                                    <li style="display:flex;align-items:center;gap:6px;">
                                        <asp:TextBox ID="txtCategoryRename" runat="server" CssClass="form-control" style="height:32px;font-size:13px;padding:0 10px;flex:1;min-width:0;" Text='<%# Eval("Name") %>' />
                                        <asp:LinkButton runat="server" CssClass="btn btn-ghost" style="height:32px;font-size:11.5px;padding:0 8px;" CommandName="RenameCategory" CommandArgument='<%# Eval("CategoryID") %>' ToolTip="Save name">Save</asp:LinkButton>
                                        <asp:LinkButton runat="server" CssClass="btn btn-ghost text-danger" style="height:32px;font-size:11.5px;padding:0 8px;" CommandName="DeleteCategory" CommandArgument='<%# Eval("CategoryID") %>' OnClientClick="return confirm('Delete this category?');" ToolTip="Delete">Remove</asp:LinkButton>
                                    </li>
                                </ItemTemplate>
                            </asp:Repeater>
                        </ul>

                        <div class="form-group" style="margin-bottom:var(--space-2);">
                            <asp:TextBox ID="txtCategoryName" runat="server" CssClass="form-control" placeholder="New category name" />
                        </div>
                        <asp:Button ID="btnAddCategory" runat="server" CssClass="btn btn-outline" Text="Add Category" OnClick="btnAddCategory_Click" style="width:100%;" />
                    </div>
                </div>
            </div>

</asp:Content>
