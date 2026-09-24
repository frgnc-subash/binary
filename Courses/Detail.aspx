<%@ Page Title="Course Detail" Language="C#" MasterPageFile="~/MasterPages/Site.Master" AutoEventWireup="true" CodeBehind="Detail.aspx.cs" Inherits="binary.Courses.Detail" %>

<asp:Content ID="BodyContent" ContentPlaceHolderID="MainContent" runat="server">

    <section class="section-sm" style="background:#ffffff;border-bottom:1px solid var(--border-light);">
        <div class="site-container" style="max-width:760px;">
            <span class="badge badge-primary" id="badgeLevel" runat="server"></span>
            <span class="badge badge-muted" id="badgeCategory" runat="server" style="margin-left:6px;"></span>
            <h1 style="font-size:2rem;margin:var(--space-3) 0 var(--space-2);"><asp:Literal ID="litTitle" runat="server" /></h1>
            <p style="color:var(--text-secondary);font-size:15px;"><asp:Literal ID="litDescription" runat="server" /></p>
            <p style="color:var(--text-muted);font-size:13.5px;margin-top:var(--space-2);"><asp:Literal ID="litLessonCount" runat="server" /> lessons</p>
        </div>
    </section>

    <section class="section-sm">
        <div class="site-container" style="max-width:760px;">

            <asp:Panel ID="pnlEnrollError" runat="server" CssClass="auth-alert auth-alert-error" Visible="false" style="margin-bottom:var(--space-4);">
                <asp:Literal ID="litEnrollError" runat="server" />
            </asp:Panel>
            <asp:Panel ID="pnlEnrollSuccess" runat="server" CssClass="auth-alert auth-alert-success" Visible="false" style="margin-bottom:var(--space-4);">
                <asp:Literal ID="litEnrollSuccess" runat="server" />
            </asp:Panel>

            <asp:HiddenField ID="hfCourseId" runat="server" />

            <%-- guest cta --%>
            <asp:Panel ID="pnlGuestCta" runat="server" CssClass="card card-body" Visible="false" style="text-align:center;margin-bottom:var(--space-6);">
                <p style="font-weight:600;margin-bottom:var(--space-3);">Sign in to enroll and start earning XP.</p>
                <a class="btn btn-primary" runat="server" id="lnkSignInEnroll" href="~/Auth/Login.aspx">Sign In</a>
                <a class="btn btn-outline" runat="server" id="lnkRegisterEnroll" href="~/Auth/Register.aspx" style="margin-left:var(--space-2);">Create Account</a>
            </asp:Panel>

            <%-- logged in, not enrolled --%>
            <asp:Panel ID="pnlEnrollCta" runat="server" CssClass="card card-body" Visible="false" style="text-align:center;margin-bottom:var(--space-6);">
                <p style="font-weight:600;margin-bottom:var(--space-3);">Enroll to unlock lessons and start earning XP.</p>
                <asp:Button ID="btnEnroll" runat="server" CssClass="btn btn-primary" Text="Enroll in this Course" OnClick="btnEnroll_Click" />
            </asp:Panel>

            <%-- enrolled: progress + interactive lessons --%>
            <asp:Panel ID="pnlEnrolled" runat="server" Visible="false">
                <div class="card card-body" style="margin-bottom:var(--space-6);box-shadow:var(--shadow-card);background:linear-gradient(135deg, #ffffff, #f8fafc);">
                    <div style="display:flex;justify-content:space-between;align-items:center;margin-bottom:10px;">
                        <div>
                            <span style="font-size:14px;font-weight:800;color:var(--text-primary);">Track Mastery</span>
                            <span style="font-size:12px;color:var(--text-muted);margin-left:8px;">Earn +<%= binary.Core.BLL.EnrollmentBLL.LessonXpReward %> XP per lesson</span>
                        </div>
                        <span class="badge badge-success" style="font-size:13px;padding:4px 12px;"><asp:Literal ID="litProgressPercent" runat="server" />% Completed</span>
                    </div>
                    <div class="progress" style="height:10px;"><div id="progressBarFill" runat="server" class="progress-bar" style="background:linear-gradient(90deg, #10b981, #059669);"></div></div>
                </div>

                <div style="margin-bottom:var(--space-4);display:flex;justify-content:space-between;align-items:center;">
                    <h3 style="font-size:1.2rem;font-weight:800;">Lesson Syllabus</h3>
                    <span style="font-size:13px;color:var(--text-muted);">Click any lesson to expand & study</span>
                </div>

                <asp:Repeater ID="rptLessons" runat="server" OnItemCommand="rptLessons_ItemCommand" OnItemDataBound="rptLessons_ItemDataBound">
                    <ItemTemplate>
                        <div class="lesson-card-item">
                            <div class="lesson-card-header" onclick="toggleLessonBody('lesson-body-<%# Eval("LessonID") %>', this)">
                                <div class="lesson-title-wrap">
                                    <div class="lesson-num-badge"><%# Eval("SortOrder") %></div>
                                    <div>
                                        <div style="font-weight:700;font-size:15px;color:var(--text-primary);"><%# HttpUtility.HtmlEncode((string)Eval("Title")) %></div>
                                        <div style="font-size:12px;color:var(--text-muted);"><%# GetLessonKindLabel(Eval("VideoUrl")) %> &bull; +<%# binary.Core.BLL.EnrollmentBLL.LessonXpReward %> XP</div>
                                    </div>
                                </div>
                                <div style="display:flex;align-items:center;gap:12px;">
                                    <asp:Literal ID="litCompleted" runat="server" Visible="false">
                                        <span class="badge badge-success" style="font-size:12px;padding:3px 10px;">&#10003; Completed</span>
                                    </asp:Literal>
                                    <span class="accordion-arrow" style="font-size:14px;color:var(--text-muted);transition:transform 0.2s ease;">&#9660;</span>
                                </div>
                            </div>

                            <div id="lesson-body-<%# Eval("LessonID") %>" class="lesson-card-body" style="display:none;">
                                <%# RenderVideoPlaceholder(Eval("VideoUrl"), Eval("Title")) %>
                                <div style="background:#ffffff;padding:var(--space-4);border-radius:var(--radius-md);border:1px solid var(--border-light);margin-bottom:var(--space-4);">
                                    <h4 style="font-size:13px;font-weight:700;text-transform:uppercase;color:var(--brand-primary);letter-spacing:0.04em;margin-bottom:6px;">Lesson Content & Key Phrases</h4>
                                    <p style="font-size:14.5px;color:var(--text-primary);white-space:pre-line;line-height:1.7;"><%# HttpUtility.HtmlEncode((string)Eval("Content")) %></p>
                                </div>

                                <div class="lesson-card-actions">
                                    <asp:LinkButton ID="btnMarkComplete" runat="server" CssClass="btn btn-primary" style="height:38px;padding:0 18px;font-size:13.5px;box-shadow:0 2px 8px var(--brand-primary-glow);" CommandName="MarkComplete" CommandArgument='<%# Eval("LessonID") %>'>
                                        <span>Complete Lesson & Earn +<%# binary.Core.BLL.EnrollmentBLL.LessonXpReward %> XP ⚡</span>
                                    </asp:LinkButton>
                                </div>
                            </div>
                        </div>
                    </ItemTemplate>
                </asp:Repeater>
            </asp:Panel>

        </div>
    </section>

    <script>
        function toggleLessonBody(bodyId, headerElem) {
            var body = document.getElementById(bodyId);
            if (body) {
                var isHidden = body.style.display === 'none';
                body.style.display = isHidden ? 'block' : 'none';
                var arrow = headerElem.querySelector('.accordion-arrow');
                if (arrow) {
                    arrow.style.transform = isHidden ? 'rotate(180deg)' : 'rotate(0deg)';
                }
                var video = body.querySelector('.lesson-video');
                if (video) {
                    if (isHidden) mountVideo(video); else unmountVideo(video);
                }
            }
        }

        // Players are only built when their lesson is opened, so the page loads fast however many
        // videos a course has. Elements are created with setAttribute (no innerHTML) from server-encoded data.
        function mountVideo(box) {
            if (box.getAttribute('data-mounted')) return;
            box.setAttribute('data-mounted', '1');
            var kind = box.getAttribute('data-kind');
            var src = box.getAttribute('data-src');
            var title = box.getAttribute('data-title') || 'Lesson video';

            if (kind === 'file') {
                var video = document.createElement('video');
                video.controls = true;
                video.preload = 'metadata';        // just enough for duration + first frame; streams on play
                video.setAttribute('playsinline', '');
                video.setAttribute('aria-label', title);
                video.src = src;
                video.addEventListener('play', pauseOtherVideos);
                box.appendChild(video);
                return;
            }

            if (kind === 'youtube') {
                // lightweight facade: a thumbnail until the learner presses play (the full
                // YouTube player is ~1 MB of script, so it's only loaded on demand)
                var facade = document.createElement('button');
                facade.type = 'button';
                facade.className = 'video-facade';
                facade.setAttribute('aria-label', 'Play video: ' + title);
                var img = document.createElement('img');
                img.src = box.getAttribute('data-thumb');
                img.alt = '';
                img.loading = 'lazy';
                facade.appendChild(img);
                var play = document.createElement('span');
                play.className = 'video-play';
                facade.appendChild(play);
                facade.addEventListener('pointerover', warmYouTube, { once: true });
                facade.addEventListener('click', function () {
                    box.innerHTML = '';
                    box.appendChild(buildIframe(src, title));
                });
                box.appendChild(facade);
                return;
            }

            box.appendChild(buildIframe(src, title));   // vimeo
        }

        function buildIframe(src, title) {
            var frame = document.createElement('iframe');
            frame.src = src;
            frame.title = title;
            frame.setAttribute('allow', 'accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; fullscreen');
            frame.setAttribute('allowfullscreen', '');
            return frame;
        }

        // collapsing a lesson stops its video; embedded players are rebuilt on the next open
        function unmountVideo(box) {
            var video = box.querySelector('video');
            if (video) { video.pause(); return; }
            box.innerHTML = '';
            box.removeAttribute('data-mounted');
        }

        function pauseOtherVideos(e) {
            var videos = document.querySelectorAll('.lesson-video video');
            for (var i = 0; i < videos.length; i++) {
                if (videos[i] !== e.target) videos[i].pause();
            }
        }

        // hovering the play button opens connections early, so the player appears faster on click
        function warmYouTube() {
            if (warmYouTube.done) return;
            warmYouTube.done = true;
            ['https://www.youtube-nocookie.com', 'https://www.google.com', 'https://i.ytimg.com'].forEach(function (origin) {
                var link = document.createElement('link');
                link.rel = 'preconnect';
                link.href = origin;
                document.head.appendChild(link);
            });
        }

        // resume where the learner left off: open the first unfinished lesson
        (function () {
            var body = document.getElementById('lesson-body-<%= OpenLessonId %>');
            if (!body) return;
            toggleLessonBody(body.id, body.previousElementSibling);
            if (<%= ScrollToOpenLesson ? "true" : "false" %>) {
                body.parentNode.scrollIntoView({ behavior: 'smooth', block: 'center' });
            }
        })();
    </script>

    <style>
        .lesson-card-item { background:#ffffff;border:1px solid var(--border-light);border-radius:var(--radius-md);margin-bottom:var(--space-3);overflow:hidden; }
        .lesson-card-header { padding:var(--space-4);display:flex;align-items:center;justify-content:space-between;cursor:pointer;background:#ffffff;transition:background 0.2s; }
        .lesson-card-header:hover { background:#f8fafc; }
        .lesson-title-wrap { display:flex;align-items:center;gap:16px; }
        .lesson-num-badge { width:32px;height:32px;display:flex;align-items:center;justify-content:center;background:var(--bg-subtle);border-radius:50%;font-weight:800;font-size:13px;color:var(--text-muted); }
        .lesson-card-body { padding:0 var(--space-4) var(--space-4);border-top:1px solid var(--border-light);background:#fcfcfc; }
        .lesson-card-actions { text-align:right; }
    </style>

</asp:Content>
