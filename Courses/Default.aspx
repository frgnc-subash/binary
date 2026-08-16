<%@ Page Title="Courses" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Default.aspx.cs" Inherits="binary.Courses.CoursesHome" %>

<asp:Content ID="BodyContent" ContentPlaceHolderID="MainContent" runat="server">

    <%-- course catalogue header --%>
    <section class="section-sm" style="background:#ffffff;border-bottom:1px solid var(--border-light);">
        <div class="site-container" style="text-align:center;max-width:640px;margin:0 auto;">
            <span class="badge badge-primary" style="margin-bottom:var(--space-2);">Course Catalogue</span>
            <h1 style="font-size:2.2rem;margin-bottom:var(--space-2);">Available Language Tracks</h1>
            <p style="color:var(--text-secondary);font-size:15px;margin-bottom:var(--space-6);">Choose a course to begin learning vocabulary, grammar rules, and listening exercises.</p>
            
            <div>
                <input id="CourseSearch" type="search" class="form-control" placeholder="Search languages (Spanish, French, Japanese, German...)" onkeyup="filterCourses()" />
            </div>
        </div>
    </section>

    <%-- clean course cards grid --%>
    <section class="section">
        <div class="site-container">
            <div class="grid-3" id="CoursesGrid">

                <%-- spanish --%>
                <div class="clean-course-card" data-lang="spanish">
                    <div class="course-card-top">
                        <div class="course-lang-badge">
                            <span class="course-lang-icon">ES</span>
                            <span>Spanish</span>
                        </div>
                        <span class="badge badge-primary">Beginner</span>
                    </div>
                    <div class="course-card-content">
                        <h3 class="course-card-title">Spanish for Beginners</h3>
                        <p class="course-card-desc">Essential pronunciation, foundational vocabulary, numbers, and basic conversation.</p>
                        <div class="course-meta-tags">
                            <span class="meta-pill">5 Lessons</span>
                            <span class="meta-pill">A1 Level</span>
                            <span class="meta-pill">1 Quiz</span>
                        </div>
                    </div>
                    <div class="course-card-bottom">
                        <span class="badge badge-success">Free Access</span>
                        <a class="btn btn-primary" runat="server" href="~/Auth/Register.aspx" style="height:36px;padding:0 14px;font-size:13px;">Enroll Course</a>
                    </div>
                </div>

                <%-- french --%>
                <div class="clean-course-card" data-lang="french">
                    <div class="course-card-top">
                        <div class="course-lang-badge">
                            <span class="course-lang-icon">FR</span>
                            <span>French</span>
                        </div>
                        <span class="badge badge-warning">Intermediate</span>
                    </div>
                    <div class="course-card-content">
                        <h3 class="course-card-title">French Immersion</h3>
                        <p class="course-card-desc">Master past tenses, restaurant dialogue, and everyday French cultural nuances.</p>
                        <div class="course-meta-tags">
                            <span class="meta-pill">3 Lessons</span>
                            <span class="meta-pill">B1 Level</span>
                            <span class="meta-pill">1 Quiz</span>
                        </div>
                    </div>
                    <div class="course-card-bottom">
                        <span class="badge badge-success">Free Access</span>
                        <a class="btn btn-primary" runat="server" href="~/Auth/Register.aspx" style="height:36px;padding:0 14px;font-size:13px;">Enroll Course</a>
                    </div>
                </div>

                <%-- japanese --%>
                <div class="clean-course-card" data-lang="japanese">
                    <div class="course-card-top">
                        <div class="course-lang-badge">
                            <span class="course-lang-icon">JP</span>
                            <span>Japanese</span>
                        </div>
                        <span class="badge badge-primary">All Levels</span>
                    </div>
                    <div class="course-card-content">
                        <h3 class="course-card-title">Japanese: Zero to N3</h3>
                        <p class="course-card-desc">Hiragana, Katakana, foundational Kanji radicals, and core JLPT grammar.</p>
                        <div class="course-meta-tags">
                            <span class="meta-pill">3 Lessons</span>
                            <span class="meta-pill">N5 Level</span>
                            <span class="meta-pill">1 Quiz</span>
                        </div>
                    </div>
                    <div class="course-card-bottom">
                        <span class="badge badge-success">Free Access</span>
                        <a class="btn btn-primary" runat="server" href="~/Auth/Register.aspx" style="height:36px;padding:0 14px;font-size:13px;">Enroll Course</a>
                    </div>
                </div>

                <%-- german --%>
                <div class="clean-course-card" data-lang="german">
                    <div class="course-card-top">
                        <div class="course-lang-badge">
                            <span class="course-lang-icon">DE</span>
                            <span>German</span>
                        </div>
                        <span class="badge badge-primary">Beginner</span>
                    </div>
                    <div class="course-card-content">
                        <h3 class="course-card-title">German: Start to Fluent</h3>
                        <p class="course-card-desc">Articles (der, die, das), sentence structure, and practical daily dialogues.</p>
                        <div class="course-meta-tags">
                            <span class="meta-pill">4 Lessons</span>
                            <span class="meta-pill">A1 Level</span>
                            <span class="meta-pill">1 Quiz</span>
                        </div>
                    </div>
                    <div class="course-card-bottom">
                        <span class="badge badge-success">Free Access</span>
                        <a class="btn btn-primary" runat="server" href="~/Auth/Register.aspx" style="height:36px;padding:0 14px;font-size:13px;">Enroll Course</a>
                    </div>
                </div>

                <%-- korean --%>
                <div class="clean-course-card" data-lang="korean">
                    <div class="course-card-top">
                        <div class="course-lang-badge">
                            <span class="course-lang-icon">KR</span>
                            <span>Korean</span>
                        </div>
                        <span class="badge badge-primary">Beginner</span>
                    </div>
                    <div class="course-card-content">
                        <h3 class="course-card-title">Korean Essentials</h3>
                        <p class="course-card-desc">Learn Hangeul reading in under an hour, core pronunciation rules, and greeting phrases.</p>
                        <div class="course-meta-tags">
                            <span class="meta-pill">3 Lessons</span>
                            <span class="meta-pill">Topik 1</span>
                            <span class="meta-pill">1 Quiz</span>
                        </div>
                    </div>
                    <div class="course-card-bottom">
                        <span class="badge badge-success">Free Access</span>
                        <a class="btn btn-primary" runat="server" href="~/Auth/Register.aspx" style="height:36px;padding:0 14px;font-size:13px;">Enroll Course</a>
                    </div>
                </div>

                <%-- italian --%>
                <div class="clean-course-card" data-lang="italian">
                    <div class="course-card-top">
                        <div class="course-lang-badge">
                            <span class="course-lang-icon">IT</span>
                            <span>Italian</span>
                        </div>
                        <span class="badge badge-primary">Beginner</span>
                    </div>
                    <div class="course-card-content">
                        <h3 class="course-card-title">Italian for Travelers</h3>
                        <p class="course-card-desc">Practical conversation for dining, directions, train tickets, and hotel bookings.</p>
                        <div class="course-meta-tags">
                            <span class="meta-pill">3 Lessons</span>
                            <span class="meta-pill">A1 Level</span>
                            <span class="meta-pill">1 Quiz</span>
                        </div>
                    </div>
                    <div class="course-card-bottom">
                        <span class="badge badge-success">Free Access</span>
                        <a class="btn btn-primary" runat="server" href="~/Auth/Register.aspx" style="height:36px;padding:0 14px;font-size:13px;">Enroll Course</a>
                    </div>
                </div>

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
    </script>

</asp:Content>
