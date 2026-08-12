<%@ Page Title="Courses" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Default.aspx.cs" Inherits="binary.Courses.CoursesHome" %>

<asp:Content ID="BodyContent" ContentPlaceHolderID="MainContent" runat="server">

    <%-- Hero --%>
    <section class="page-hero" style="background:linear-gradient(160deg,hsl(230,30%,98%),hsl(246,40%,96%));">
        <div class="site-container">
            <div class="page-hero-badge">&#128218; All Courses</div>
            <h1>Find Your <span class="gradient-text">Perfect Course</span></h1>
            <p class="lead">50+ languages. Every level. Expert-designed curriculum with real speaking practice.</p>
            <div class="courses-search">
                <input id="CourseSearch" type="search" class="form-control courses-search-input" placeholder="Search languages or topics..." />
            </div>
        </div>
    </section>

    <%-- Filters --%>
    <section class="section-sm" style="border-bottom:1px solid var(--border-light);background:var(--surface-base);">
        <div class="site-container courses-filters">
            <div class="filter-group">
                <span class="filter-label">Level:</span>
                <div class="filter-chips">
                    <button class="filter-chip active" onclick="filterLevel(this,'all')">All</button>
                    <button class="filter-chip" onclick="filterLevel(this,'beginner')">Beginner</button>
                    <button class="filter-chip" onclick="filterLevel(this,'intermediate')">Intermediate</button>
                    <button class="filter-chip" onclick="filterLevel(this,'advanced')">Advanced</button>
                </div>
            </div>
            <div class="filter-group">
                <span class="filter-label">Sort:</span>
                <select class="form-control" style="max-width:180px;height:38px;padding:6px 12px;">
                    <option>Most Popular</option>
                    <option>Highest Rated</option>
                    <option>Newest</option>
                    <option>A–Z</option>
                </select>
            </div>
        </div>
    </section>

    <%-- Course Grid --%>
    <section class="section">
        <div class="site-container">
            <div class="grid-3" id="CoursesGrid">

                <div class="course-card card" data-level="beginner" data-lang="spanish">
                    <div class="course-banner" style="background:linear-gradient(135deg,hsl(14,90%,60%),hsl(46,90%,55%));"></div>
                    <div class="card-body">
                        <div class="course-card-top"><span class="badge badge-primary">Beginner</span><span class="course-flag">&#127480;&#127477;</span></div>
                        <h3 class="course-title">Spanish for Beginners</h3>
                        <p class="course-desc">Pronunciation, core vocab, and everyday Spanish conversation.</p>
                        <div class="course-meta"><span>&#9733; 4.9</span><span>84k learners</span><span>40 lessons</span></div>
                        <div class="progress" style="margin-top:14px;"><div class="progress-bar" style="width:0%"></div></div>
                    </div>
                    <div class="card-footer course-card-footer"><span class="badge badge-success">Free</span><a class="btn btn-primary" href="#">Enroll Now</a></div>
                </div>

                <div class="course-card card" data-level="intermediate" data-lang="french">
                    <div class="course-banner" style="background:linear-gradient(135deg,hsl(220,80%,55%),hsl(280,70%,60%));"></div>
                    <div class="card-body">
                        <div class="course-card-top"><span class="badge badge-warning">Intermediate</span><span class="course-flag">&#127467;&#127479;</span></div>
                        <h3 class="course-title">French Immersion</h3>
                        <p class="course-desc">Grammar, culture, and conversational French with native audio.</p>
                        <div class="course-meta"><span>&#9733; 4.8</span><span>62k learners</span><span>55 lessons</span></div>
                        <div class="progress" style="margin-top:14px;"><div class="progress-bar" style="width:0%"></div></div>
                    </div>
                    <div class="card-footer course-card-footer"><span class="badge badge-success">Free</span><a class="btn btn-primary" href="#">Enroll Now</a></div>
                </div>

                <div class="course-card card" data-level="beginner" data-lang="japanese">
                    <div class="course-banner" style="background:linear-gradient(135deg,hsl(0,80%,60%),hsl(320,70%,55%));"></div>
                    <div class="card-body">
                        <div class="course-card-top"><span class="badge badge-success">All Levels</span><span class="course-flag">&#127471;&#127477;</span></div>
                        <h3 class="course-title">Japanese: Zero to N3</h3>
                        <p class="course-desc">Hiragana, katakana, kanji, and JLPT N3 grammar.</p>
                        <div class="course-meta"><span>&#9733; 4.9</span><span>48k learners</span><span>80 lessons</span></div>
                        <div class="progress" style="margin-top:14px;"><div class="progress-bar" style="width:0%"></div></div>
                    </div>
                    <div class="card-footer course-card-footer"><span class="badge badge-success">Free</span><a class="btn btn-primary" href="#">Enroll Now</a></div>
                </div>

                <div class="course-card card" data-level="beginner" data-lang="german">
                    <div class="course-banner" style="background:linear-gradient(135deg,hsl(45,90%,55%),hsl(200,80%,55%));"></div>
                    <div class="card-body">
                        <div class="course-card-top"><span class="badge badge-primary">Beginner</span><span class="course-flag">&#127465;&#127466;</span></div>
                        <h3 class="course-title">German Foundations</h3>
                        <p class="course-desc">Cases, articles, and essential German grammar from scratch.</p>
                        <div class="course-meta"><span>&#9733; 4.7</span><span>35k learners</span><span>45 lessons</span></div>
                        <div class="progress" style="margin-top:14px;"><div class="progress-bar" style="width:0%"></div></div>
                    </div>
                    <div class="card-footer course-card-footer"><span class="badge badge-success">Free</span><a class="btn btn-primary" href="#">Enroll Now</a></div>
                </div>

                <div class="course-card card" data-level="intermediate" data-lang="chinese">
                    <div class="course-banner" style="background:linear-gradient(135deg,hsl(0,85%,55%),hsl(25,90%,55%));"></div>
                    <div class="card-body">
                        <div class="course-card-top"><span class="badge badge-warning">Intermediate</span><span class="course-flag">&#127464;&#127475;</span></div>
                        <h3 class="course-title">Mandarin Chinese</h3>
                        <p class="course-desc">Tones, characters, and conversational Mandarin for real life.</p>
                        <div class="course-meta"><span>&#9733; 4.8</span><span>29k learners</span><span>60 lessons</span></div>
                        <div class="progress" style="margin-top:14px;"><div class="progress-bar" style="width:0%"></div></div>
                    </div>
                    <div class="card-footer course-card-footer"><span class="badge badge-success">Free</span><a class="btn btn-primary" href="#">Enroll Now</a></div>
                </div>

                <div class="course-card card" data-level="advanced" data-lang="korean">
                    <div class="course-banner" style="background:linear-gradient(135deg,hsl(280,80%,60%),hsl(200,80%,55%));"></div>
                    <div class="card-body">
                        <div class="course-card-top"><span class="badge badge-muted">Advanced</span><span class="course-flag">&#127472;&#127479;</span></div>
                        <h3 class="course-title">Korean: TOPIK II</h3>
                        <p class="course-desc">Advanced grammar, writing, and TOPIK II exam preparation.</p>
                        <div class="course-meta"><span>&#9733; 4.9</span><span>22k learners</span><span>70 lessons</span></div>
                        <div class="progress" style="margin-top:14px;"><div class="progress-bar" style="width:0%"></div></div>
                    </div>
                    <div class="card-footer course-card-footer"><span class="badge badge-primary">Pro</span><a class="btn btn-primary" href="#">Enroll Now</a></div>
                </div>

            </div>
            <div style="text-align:center;margin-top:var(--space-12);">
                <p style="color:var(--text-muted);margin-bottom:var(--space-4);">Showing 6 of 50+ courses</p>
                <button class="btn btn-outline btn-lg" type="button">Load More Courses</button>
            </div>
        </div>
    </section>

    <script>
        function filterLevel(btn, level) {
            document.querySelectorAll('.filter-chip').forEach(function(c) { c.classList.remove('active'); });
            btn.classList.add('active');
            document.querySelectorAll('.course-card').forEach(function(card) {
                card.style.display = (level === 'all' || card.dataset.level === level) ? '' : 'none';
            });
        }
        document.getElementById('CourseSearch').addEventListener('input', function() {
            var q = this.value.toLowerCase();
            document.querySelectorAll('.course-card').forEach(function(card) {
                var lang = (card.dataset.lang || '');
                var title = card.querySelector('.course-title') ? card.querySelector('.course-title').textContent.toLowerCase() : '';
                card.style.display = (!q || lang.includes(q) || title.includes(q)) ? '' : 'none';
            });
        });
    </script>

    <style>
        .courses-search { margin-top:var(--space-6);display:flex;justify-content:center; }
        .courses-search-input { max-width:520px;width:100%;height:50px;font-size:16px;border-radius:var(--radius-pill);padding:0 var(--space-5); }
        .courses-filters { display:flex;align-items:center;justify-content:space-between;gap:var(--space-4);flex-wrap:wrap; }
        .filter-group { display:flex;align-items:center;gap:var(--space-3); }
        .filter-label { font-size:13px;font-weight:600;color:var(--text-muted);text-transform:uppercase;letter-spacing:0.5px; }
        .filter-chips { display:flex;gap:var(--space-2); }
        .filter-chip { height:34px;padding:0 var(--space-4);border-radius:var(--radius-pill);border:1.5px solid var(--border-mid);background:transparent;font-size:13px;font-weight:600;color:var(--text-secondary);cursor:pointer;transition:all var(--dur-fast) var(--ease); }
        .filter-chip:hover { border-color:var(--brand-primary);color:var(--brand-primary);background:hsla(246,80%,60%,0.06); }
        .filter-chip.active { border-color:var(--brand-primary);background:var(--brand-primary);color:#fff; }
        .course-banner { height:130px; }
        .course-card-top { display:flex;align-items:center;justify-content:space-between;margin-bottom:var(--space-3); }
        .course-flag { font-size:1.7rem; }
        .course-title { font-size:1.05rem;margin-bottom:var(--space-2); }
        .course-desc { font-size:14px;color:var(--text-secondary);line-height:1.6;margin-bottom:var(--space-4); }
        .course-meta { display:flex;gap:var(--space-4);font-size:12px;color:var(--text-muted);font-weight:500; }
        .course-card-footer { display:flex;align-items:center;justify-content:space-between; }
    </style>

</asp:Content>
