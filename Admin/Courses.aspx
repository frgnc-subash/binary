<%@ Page Title="Manage Courses" Language="C#" MasterPageFile="~/MasterPages/AdminMaster.master" AutoEventWireup="true" CodeBehind="Courses.aspx.cs" Inherits="binary.Admin.AdminCourses" %>

<asp:Content ID="HeaderTitle" ContentPlaceHolderID="AdminHeaderTitle" runat="server">Manage Courses</asp:Content>
<asp:Content ID="HeaderSubtitle" ContentPlaceHolderID="AdminHeaderSubtitle" runat="server">Create categories, courses, and lessons.</asp:Content>
<asp:Content ID="HeaderActions" ContentPlaceHolderID="AdminHeaderActions" runat="server">
    <a class="btn btn-outline" runat="server" href="~/Admin"><svg class="ui-icon ui-icon-before" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" aria-hidden="true"><line x1="19" y1="12" x2="5" y2="12"></line><polyline points="12 19 5 12 12 5"></polyline></svg>Dashboard</a>
    <a class="btn btn-primary" runat="server" href="~/Admin/Courses.aspx?new=1"><svg class="ui-icon ui-icon-before" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" aria-hidden="true"><line x1="12" y1="5" x2="12" y2="19"></line><line x1="5" y1="12" x2="19" y2="12"></line></svg>New Course</a>
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
                                <%-- flag: pick from the library in Content/images/flags or upload a new one --%>
                                <div class="form-group">
                                    <label class="form-label" for="<%= ddlFlag.ClientID %>">Flag</label>
                                    <div class="flag-picker">
                                        <span class="flag-picker-preview" id="flagPreview" data-base="<%= ResolveUrl(binary.Core.Helpers.FlagHelper.FlagFolderVirtualPath) %>"></span>
                                        <asp:DropDownList ID="ddlFlag" runat="server" CssClass="form-control" onchange="previewFlag()" />
                                    </div>
                                    <div class="flag-upload">
                                        <asp:FileUpload ID="fuFlag" runat="server" CssClass="form-control" accept=".png,.jpg,.jpeg,.webp,.gif" onchange="previewFlagFile(this)" />
                                        <p class="form-hint">Or upload a new flag (PNG, JPG, WEBP, or GIF, up to 1 MB). It's added to the flag library so you can reuse it.</p>
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
                                    <thead><tr><th>Order</th><th>Title</th><th>Video</th><th>Action</th></tr></thead>
                                    <tbody>
                                        <asp:Repeater ID="rptLessons" runat="server" OnItemCommand="rptLessons_ItemCommand">
                                            <ItemTemplate>
                                                <tr>
                                                    <td><%# Eval("SortOrder") %></td>
                                                    <td><%# HttpUtility.HtmlEncode((string)Eval("Title")) %></td>
                                                    <td><%# GetVideoBadge(Eval("VideoUrl")) %></td>
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
                                <div class="grid-2">
                                    <div class="form-group">
                                        <label class="form-label" for="txtLessonTitle">Lesson Title</label>
                                        <asp:TextBox ID="txtLessonTitle" runat="server" CssClass="form-control" />
                                    </div>
                                    <div class="form-group">
                                        <label class="form-label" for="txtLessonSortOrder">Sort Order</label>
                                        <asp:TextBox ID="txtLessonSortOrder" runat="server" CssClass="form-control" Text="0" />
                                    </div>
                                </div>
                                <div class="form-group">
                                    <label class="form-label" for="txtLessonContent">Content</label>
                                    <asp:TextBox ID="txtLessonContent" runat="server" CssClass="form-control" TextMode="MultiLine" Rows="3" />
                                </div>

                                <%-- lesson video: paste a link OR upload a file --%>
                                <div class="form-group">
                                    <label class="form-label">Lesson Video (optional)</label>

                                    <asp:Panel ID="pnlCurrentVideo" runat="server" Visible="false" CssClass="current-video">
                                        <span class="current-video-label"><svg class="ui-icon ui-icon-before" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" aria-hidden="true"><polygon points="23 7 16 12 23 17 23 7"/><rect x="1" y="5" width="15" height="14" rx="2"/></svg>Current: <asp:Literal ID="litCurrentVideo" runat="server" /></span>
                                        <label class="current-video-remove"><asp:CheckBox ID="chkRemoveVideo" runat="server" /> Remove video</label>
                                    </asp:Panel>

                                    <div class="video-source-toggle" role="radiogroup" aria-label="Video source">
                                        <label><input type="radio" name="videoSource" value="link" checked onclick="setVideoSource('link')" /> Paste a link</label>
                                        <label><input type="radio" name="videoSource" value="upload" onclick="setVideoSource('upload')" /> Upload a file</label>
                                    </div>

                                    <div id="videoLinkPane">
                                        <asp:TextBox ID="txtLessonVideoUrl" runat="server" CssClass="form-control" placeholder="https://www.youtube.com/watch?v=…  (YouTube, Vimeo, or a direct .mp4 link)" />
                                    </div>
                                    <div id="videoUploadPane" hidden>
                                        <asp:FileUpload ID="fuLessonVideo" runat="server" CssClass="form-control" accept="video/mp4,video/webm,video/ogg,.mp4,.webm,.ogv" />
                                        <p class="form-hint">MP4 (recommended — plays everywhere), WEBM, or OGV. Up to <%= binary.Core.Helpers.VideoHelper.MaxUploadMegabytes %> MB; for longer videos, upload to YouTube and paste the link.</p>
                                    </div>

                                    <div class="upload-progress" id="lessonUploadProgress" hidden>
                                        <div class="upload-progress-track"><div class="upload-progress-bar" id="lessonUploadBar"></div></div>
                                        <span class="upload-progress-text" id="lessonUploadText">Uploading… 0%</span>
                                    </div>
                                </div>

                                <asp:Button ID="btnSaveLesson" runat="server" CssClass="btn btn-primary" Text="Save Lesson" OnClick="btnSaveLesson_Click" OnClientClick="return saveLessonWithProgress(this);" />
                                <a class="btn btn-outline" href="<%= ResolveUrl("~/Admin/Courses.aspx?id=" + hfCourseId.Value) %>"><svg class="ui-icon ui-icon-before" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" aria-hidden="true"><line x1="12" y1="5" x2="12" y2="19"></line><line x1="5" y1="12" x2="19" y2="12"></line></svg>New Lesson</a>
                            </div>
                        </div>
                    </asp:Panel>

                    <%-- course list --%>
                    <asp:HiddenField ID="hfCoursesPage" runat="server" Value="1" />
                    <div class="card">
                        <div class="card-header"><h3 style="font-size:1.05rem;">All Courses</h3></div>

                        <%-- filters: dropdowns apply straight away, the search box on Enter --%>
                        <asp:Panel ID="pnlCourseFilters" runat="server" CssClass="filter-bar" DefaultButton="btnCourseSearch">
                            <div class="filter-bar-search">
                                <svg class="filter-bar-icon" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" aria-hidden="true"><circle cx="11" cy="11" r="7"/><line x1="21" y1="21" x2="16.65" y2="16.65"/></svg>
                                <asp:TextBox ID="txtCourseSearch" runat="server" CssClass="form-control" TextMode="Search" placeholder="Search title or category" aria-label="Search courses" />
                            </div>
                            <asp:DropDownList ID="ddlCategoryFilter" runat="server" CssClass="form-control" AppendDataBoundItems="true" DataTextField="Name" DataValueField="CategoryID" AutoPostBack="true" OnSelectedIndexChanged="CourseFilter_Changed" aria-label="Category">
                                <asp:ListItem Text="All categories" Value="" />
                            </asp:DropDownList>
                            <asp:DropDownList ID="ddlLevelFilter" runat="server" CssClass="form-control" AutoPostBack="true" OnSelectedIndexChanged="CourseFilter_Changed" aria-label="Level">
                                <asp:ListItem Text="All levels" Value="" />
                                <asp:ListItem Text="Beginner" Value="Beginner" />
                                <asp:ListItem Text="Intermediate" Value="Intermediate" />
                                <asp:ListItem Text="All Levels" Value="All Levels" />
                            </asp:DropDownList>
                            <asp:DropDownList ID="ddlStatusFilter" runat="server" CssClass="form-control" AutoPostBack="true" OnSelectedIndexChanged="CourseFilter_Changed" aria-label="Status">
                                <asp:ListItem Text="Any status" Value="" />
                                <asp:ListItem Text="Published" Value="published" />
                                <asp:ListItem Text="Draft" Value="draft" />
                            </asp:DropDownList>
                            <asp:Button ID="btnCourseSearch" runat="server" CssClass="btn btn-outline" Text="Search" OnClick="btnCourseSearch_Click" />
                        </asp:Panel>
                        <asp:Panel ID="pnlCourseFilterSummary" runat="server" CssClass="filter-summary" Visible="false">
                            <span><asp:Literal ID="litCourseFilterSummary" runat="server" /></span>
                            <asp:LinkButton ID="lnkClearCourseFilters" runat="server" CssClass="filter-clear" OnClick="lnkClearCourseFilters_Click">Clear filters</asp:LinkButton>
                        </asp:Panel>

                        <asp:Panel ID="pnlCourseList" runat="server">
                            <div style="overflow-x:auto;">
                                <table class="admin-table">
                                    <thead><tr><th>Title</th><th>Category</th><th>Level</th><th>Status</th><th>Action</th></tr></thead>
                                    <tbody>
                                        <asp:Repeater ID="rptCourses" runat="server" OnItemCommand="rptCourses_ItemCommand">
                                            <ItemTemplate>
                                                <tr>
                                                    <td><span class="course-title-cell"><%# binary.Core.Helpers.FlagHelper.Render((string)Eval("FlagImageUrl"), (string)Eval("Title"), "flag-sm") %><%# HttpUtility.HtmlEncode((string)Eval("Title")) %></span></td>
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
                            <a class="btn btn-primary" runat="server" href="~/Admin/Courses.aspx?new=1"><svg class="ui-icon ui-icon-before" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" aria-hidden="true"><line x1="12" y1="5" x2="12" y2="19"></line><line x1="5" y1="12" x2="19" y2="12"></line></svg>New Course</a>
                        </asp:Panel>
                    </div>
                </div>

                <%-- categories sidebar --%>
                <div class="admin-side">
                    <div class="card category-card">
                        <div class="card-header category-card-head">
                            <h3 style="font-size:1.05rem;">Categories</h3>
                            <span class="category-count"><asp:Literal ID="litCategoryTotal" runat="server" /></span>
                        </div>

                        <asp:Panel ID="pnlCategoryError" runat="server" CssClass="auth-alert auth-alert-error" Visible="false" style="margin:var(--space-3) var(--space-4) 0;">
                            <asp:Literal ID="litCategoryError" runat="server" />
                        </asp:Panel>

                        <ul class="category-list">
                            <asp:Repeater ID="rptCategories" runat="server" OnItemCommand="rptCategories_ItemCommand">
                                <ItemTemplate>
                                    <li class='<%# IsActiveCategory((int)Eval("CategoryID")) ? "category-row is-active" : "category-row" %>'>
                                        <div class="category-view">
                                            <asp:LinkButton runat="server" CssClass="category-name" CommandName="FilterCategory" CommandArgument='<%# Eval("CategoryID") %>' ToolTip="Show only this category's courses">
                                                <span><%# HttpUtility.HtmlEncode((string)Eval("Name")) %></span>
                                                <span class="category-courses"><%# Eval("CourseCount") %></span>
                                            </asp:LinkButton>
                                            <button type="button" class="icon-btn" title="Rename" aria-label="Rename" onclick="toggleCategoryEdit(this, true)"><svg class="ui-icon" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" aria-hidden="true"><path d="M12 20h9"/><path d="M16.5 3.5a2.12 2.12 0 0 1 3 3L7 19l-4 1 1-4Z"/></svg></button>
                                            <asp:LinkButton runat="server" CssClass="icon-btn icon-btn-danger" CommandName="DeleteCategory" CommandArgument='<%# Eval("CategoryID") %>' Visible='<%# (int)Eval("CourseCount") == 0 %>' OnClientClick="return confirm('Delete this category?');" ToolTip="Delete" aria-label="Delete"><svg class="ui-icon" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" aria-hidden="true"><polyline points="3 6 5 6 21 6"/><path d="M19 6l-1 14a2 2 0 0 1-2 2H8a2 2 0 0 1-2-2L5 6"/><path d="M10 11v6"/><path d="M14 11v6"/><path d="M9 6V4a1 1 0 0 1 1-1h4a1 1 0 0 1 1 1v2"/></svg></asp:LinkButton>
                                            <asp:PlaceHolder runat="server" Visible='<%# (int)Eval("CourseCount") > 0 %>'>
                                                <span class="icon-btn is-disabled" title="Move or delete its courses before deleting this category"><svg class="ui-icon" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" aria-hidden="true"><polyline points="3 6 5 6 21 6"/><path d="M19 6l-1 14a2 2 0 0 1-2 2H8a2 2 0 0 1-2-2L5 6"/><path d="M10 11v6"/><path d="M14 11v6"/><path d="M9 6V4a1 1 0 0 1 1-1h4a1 1 0 0 1 1 1v2"/></svg></span>
                                            </asp:PlaceHolder>
                                        </div>
                                        <div class="category-edit" hidden>
                                            <asp:TextBox ID="txtCategoryRename" runat="server" CssClass="form-control" MaxLength="100" Text='<%# Eval("Name") %>' aria-label="Category name" />
                                            <asp:LinkButton runat="server" CssClass="btn btn-primary" CommandName="RenameCategory" CommandArgument='<%# Eval("CategoryID") %>'>Save</asp:LinkButton>
                                            <button type="button" class="btn btn-ghost" onclick="toggleCategoryEdit(this, false)">Cancel</button>
                                        </div>
                                    </li>
                                </ItemTemplate>
                            </asp:Repeater>
                        </ul>
                        <asp:Panel ID="pnlNoCategories" runat="server" Visible="false" CssClass="category-empty">
                            No categories yet. Add one below to start grouping courses.
                        </asp:Panel>

                        <asp:Panel ID="pnlAddCategory" runat="server" CssClass="category-add" DefaultButton="btnAddCategory">
                            <asp:TextBox ID="txtCategoryName" runat="server" CssClass="form-control" MaxLength="100" placeholder="New category" aria-label="New category name" />
                            <asp:Button ID="btnAddCategory" runat="server" CssClass="btn btn-outline" Text="Add" OnClick="btnAddCategory_Click" />
                        </asp:Panel>
                    </div>
                </div>
            </div>

    <script>
        // swap a category row between its name and the inline rename box
        function toggleCategoryEdit(btn, editing) {
            var row = btn.closest('.category-row');
            row.querySelector('.category-view').hidden = editing;
            row.querySelector('.category-edit').hidden = !editing;
            if (editing) {
                var input = row.querySelector('.category-edit input');
                input.focus();
                input.select();
            }
        }

        function previewFlag() {
            var select = document.getElementById('<%= ddlFlag.ClientID %>');
            var box = document.getElementById('flagPreview');
            if (!select || !box) return;
            box.innerHTML = '';
            if (!select.value) { box.classList.add('is-empty'); return; }
            box.classList.remove('is-empty');
            var img = document.createElement('img');
            img.alt = '';
            img.src = box.getAttribute('data-base') + encodeURIComponent(select.value);
            box.appendChild(img);
        }

        function previewFlagFile(input) {
            var box = document.getElementById('flagPreview');
            var file = input.files && input.files[0];
            if (!file || !box) return;
            box.innerHTML = '';
            box.classList.remove('is-empty');
            var img = document.createElement('img');
            img.alt = '';
            img.src = URL.createObjectURL(file);
            box.appendChild(img);
        }

        previewFlag();

        function setVideoSource(source) {
            var upload = source === 'upload';
            document.getElementById('videoLinkPane').hidden = upload;
            document.getElementById('videoUploadPane').hidden = !upload;
            // a file picked earlier would override the link on save, so drop it when switching back
            if (!upload) {
                var file = document.getElementById('<%= fuLessonVideo.ClientID %>');
                if (file) file.value = '';
            }
        }

        // With a video file selected, post the form in the background so the admin sees real upload
        // progress instead of a frozen page. Without a file it's a normal postback (returns true).
        function saveLessonWithProgress(btn) {
            var input = document.getElementById('<%= fuLessonVideo.ClientID %>');
            if (!input || !input.files || input.files.length === 0) return true;
            if (!window.FormData || !window.XMLHttpRequest) return true;
            if (saveLessonWithProgress.busy) return false;

            var maxBytes = <%= binary.Core.Helpers.VideoHelper.MaxUploadBytes %>;
            if (input.files[0].size > maxBytes) {
                alert('That video is larger than <%= binary.Core.Helpers.VideoHelper.MaxUploadMegabytes %> MB. Upload it to YouTube and paste the link instead.');
                return false;
            }

            var form = document.forms[0];
            var data = new FormData(form);
            data.append(btn.name, btn.value);   // tells WebForms which button was clicked

            var progress = document.getElementById('lessonUploadProgress');
            var bar = document.getElementById('lessonUploadBar');
            var text = document.getElementById('lessonUploadText');

            function reset() {
                saveLessonWithProgress.busy = false;
                progress.hidden = true;
                btn.classList.remove('is-busy');
            }

            saveLessonWithProgress.busy = true;
            btn.classList.add('is-busy');
            progress.hidden = false;

            var xhr = new XMLHttpRequest();
            xhr.open('POST', form.action);
            xhr.upload.onprogress = function (e) {
                if (!e.lengthComputable) return;
                var pct = Math.round(e.loaded * 100 / e.total);
                bar.style.width = pct + '%';
                text.textContent = pct < 100 ? 'Uploading… ' + pct + '%' : 'Processing…';
            };
            xhr.onload = function () {
                // success redirects to the course with ?msg=lesson-saved; follow it like a normal save
                if (xhr.status === 200 && xhr.responseURL && xhr.responseURL.indexOf('msg=lesson-saved') !== -1) {
                    window.location.href = xhr.responseURL;
                    return;
                }
                if (xhr.status === 200) {
                    // validation error: the server re-rendered this page with the message, show it as-is
                    document.open();
                    document.write(xhr.responseText);
                    document.close();
                    return;
                }
                reset();
                alert(xhr.status === 404 || xhr.status === 413
                    ? 'The server rejected the upload because the file is too large.'
                    : 'Upload failed (error ' + xhr.status + '). Please try again.');
            };
            xhr.onerror = function () {
                reset();
                alert('Upload failed. Check your connection and try again.');
            };
            xhr.send(data);
            return false;
        }
    </script>

</asp:Content>
