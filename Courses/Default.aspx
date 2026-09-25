<%@ Page Title="Courses" Language="C#" MasterPageFile="~/MasterPages/Site.Master" AutoEventWireup="true" CodeBehind="Default.aspx.cs" Inherits="binary.Courses.CoursesHome" %>

<asp:Content ID="BodyContent" ContentPlaceHolderID="MainContent" runat="server">

    <%-- course catalogue header --%>
    <section class="section-sm" style="background:var(--bg-surface);border-bottom:1px solid var(--border-light);">
        <div class="site-container" style="text-align:center;max-width:640px;margin:0 auto;">
            <span class="badge badge-primary" style="margin-bottom:var(--space-2);">Course Catalogue</span>
            <h1 style="font-size:2.2rem;margin-bottom:var(--space-2);">Available Language Tracks</h1>
            <p style="color:var(--text-secondary);font-size:15px;margin-bottom:var(--space-6);">Choose a course to begin learning vocabulary, grammar rules, and listening exercises.</p>

            <div>
                <input id="CourseSearch" type="search" class="form-control" placeholder="Search languages (Spanish, French, Japanese, German...)" value="<%: Request.QueryString["q"] ?? Request.QueryString["lang"] %>" autocomplete="off" aria-label="Search courses" />
            </div>
        </div>
    </section>

    <%-- clean course cards grid --%>
    <section class="section">
        <div class="site-container">
            <div class="grid-3" id="CoursesGrid">
                <asp:Repeater ID="rptCourses" runat="server">
                    <ItemTemplate>
                        <a class="course-card" href='<%# ResolveUrl("~/Courses/Detail.aspx?id=" + Eval("CourseID")) %>'>
                            <div class="course-card-head">
                                <%# binary.Core.Helpers.FlagHelper.Render((string)Eval("FlagImageUrl"), (string)Eval("Title"), "flag-lg") %>
                                <span class="course-card-category"><%# HttpUtility.HtmlEncode((string)Eval("CategoryName")) %></span>
                            </div>
                            <h3 class="course-card-title"><%# HttpUtility.HtmlEncode((string)Eval("Title")) %></h3>
                            <p class="course-card-desc"><%# HttpUtility.HtmlEncode((string)Eval("Description")) %></p>
                            <%# GetProgressHtml((int)Eval("CourseID")) %>
                            <div class="course-card-foot">
                                <span class="course-card-meta"><%# GetLessonCount((int)Eval("CourseID")) %> lessons &middot; <%# HttpUtility.HtmlEncode((string)Eval("Level")) %></span>
                                <span class="course-card-cta"><%# IsEnrolled((int)Eval("CourseID")) ? "Continue" : "View course" %><svg class="ui-icon" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" aria-hidden="true"><line x1="5" y1="12" x2="19" y2="12"></line><polyline points="12 5 19 12 12 19"></polyline></svg></span>
                            </div>
                        </a>
                    </ItemTemplate>
                </asp:Repeater>
                <p id="CourseNoMatch" hidden style="grid-column:1/-1;text-align:center;color:var(--text-muted);padding:var(--space-10) 0;">No courses match your search.</p>
                <asp:Panel ID="pnlNoCourses" runat="server" Visible="false" style="grid-column:1/-1;text-align:center;color:var(--text-muted);padding:var(--space-10) 0;">
                    No published courses yet — check back soon.
                </asp:Panel>
            </div>
        </div>
    </section>

    <script>
        // Client-side course search. The search text is kept in the address bar (?q=...), so a reload
        // or the back button shows the current search, not the one the page was first opened with.
        (function () {
            var input = document.getElementById('CourseSearch');
            var noMatch = document.getElementById('CourseNoMatch');
            var cards = document.querySelectorAll('.course-card');
            var params = new URLSearchParams(location.search);

            // the address bar wins over whatever the browser restored into the box
            input.value = params.get('q') || params.get('lang') || '';

            function filterCourses() {
                var q = input.value.trim().toLowerCase();
                var shown = 0;
                for (var i = 0; i < cards.length; i++) {
                    var match = cards[i].textContent.toLowerCase().indexOf(q) > -1;
                    cards[i].hidden = !match;
                    if (match) shown++;
                }
                noMatch.hidden = shown > 0 || cards.length === 0;

                var next = new URLSearchParams(location.search);
                next.delete('lang');
                if (q) next.set('q', input.value.trim()); else next.delete('q');
                var query = next.toString();
                history.replaceState(null, '', location.pathname + (query ? '?' + query : '') + location.hash);
            }

            input.addEventListener('input', filterCourses);
            input.addEventListener('keydown', function (e) {
                if (e.key === 'Enter') e.preventDefault();   // would submit the WebForms page
            });
            filterCourses();
        })();
    </script>

</asp:Content>
