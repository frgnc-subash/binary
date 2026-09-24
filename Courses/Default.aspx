<%@ Page Title="Courses" Language="C#" MasterPageFile="~/MasterPages/Site.Master" AutoEventWireup="true" CodeBehind="Default.aspx.cs" Inherits="binary.Courses.CoursesHome" %>

<asp:Content ID="BodyContent" ContentPlaceHolderID="MainContent" runat="server">

    <%-- course catalogue header --%>
    <section class="section-sm" style="background:#ffffff;border-bottom:1px solid var(--border-light);">
        <div class="site-container" style="text-align:center;max-width:640px;margin:0 auto;">
            <span class="badge badge-primary" style="margin-bottom:var(--space-2);">Course Catalogue</span>
            <h1 style="font-size:2.2rem;margin-bottom:var(--space-2);">Available Language Tracks</h1>
            <p style="color:var(--text-secondary);font-size:15px;margin-bottom:var(--space-6);">Choose a course to begin learning vocabulary, grammar rules, and listening exercises.</p>

            <div>
                <input id="CourseSearch" type="search" class="form-control" placeholder="Search languages (Spanish, French, Japanese, German...)" value="<%: Request.QueryString["lang"] %>" onkeyup="filterCourses()" />
            </div>
        </div>
    </section>

    <%-- clean course cards grid --%>
    <section class="section">
        <div class="site-container">
            <div class="grid-3" id="CoursesGrid">
                <asp:Repeater ID="rptCourses" runat="server">
                    <ItemTemplate>
                        <div class="clean-course-card" data-lang="<%# HttpUtility.HtmlAttributeEncode(((string)Eval("Title")).ToLowerInvariant()) %>">
                            <div class="course-card-top">
                                <div class="course-lang-badge">
                                    <span class="course-lang-icon"><%# binary.Core.Helpers.DisplayHelper.GetTitleMonogram((string)Eval("Title")) %></span>
                                    <span><%# HttpUtility.HtmlEncode((string)Eval("CategoryName")) %></span>
                                </div>
                                <span class="badge badge-primary"><%# HttpUtility.HtmlEncode((string)Eval("Level")) %></span>
                            </div>
                            <div class="course-card-content">
                                <h3 class="course-card-title"><%# HttpUtility.HtmlEncode((string)Eval("Title")) %></h3>
                                <p class="course-card-desc"><%# HttpUtility.HtmlEncode((string)Eval("Description")) %></p>
                                <div class="course-meta-tags">
                                    <span class="meta-pill"><%# GetLessonCount((int)Eval("CourseID")) %> Lessons</span>
                                    <span class="meta-pill"><%# HttpUtility.HtmlEncode((string)Eval("Level")) %></span>
                                </div>
                            </div>
                            <div class="course-card-bottom">
                                <span class="badge badge-success">Free Access</span>
                                <a class="btn btn-primary" href='<%# ResolveUrl("~/Courses/Detail.aspx?id=" + Eval("CourseID")) %>' style="height:36px;padding:0 14px;font-size:13px;">View Course</a>
                            </div>
                        </div>
                    </ItemTemplate>
                </asp:Repeater>
                <asp:Panel ID="pnlNoCourses" runat="server" Visible="false" style="grid-column:1/-1;text-align:center;color:var(--text-muted);padding:var(--space-10) 0;">
                    No published courses yet — check back soon.
                </asp:Panel>
            </div>
        </div>
    </section>

    <script>
        // client-side course filtering
        function filterCourses() {
            var input = document.getElementById('CourseSearch').value.toLowerCase();
            var cards = document.querySelectorAll('.clean-course-card');
            cards.forEach(function (card) {
                var text = card.textContent.toLowerCase();
                card.style.display = text.indexOf(input) > -1 ? 'flex' : 'none';
            });
        }

        // apply the filter immediately if we arrived pre-filled (e.g. from a landing-page language chip)
        if (document.getElementById('CourseSearch').value) {
            filterCourses();
        }
    </script>

</asp:Content>
