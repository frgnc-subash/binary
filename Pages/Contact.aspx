<%@ Page Title="Contact Us" Language="C#" MasterPageFile="~/MasterPages/Site.Master" AutoEventWireup="true" CodeBehind="Contact.aspx.cs" Inherits="binary.Pages.Contact" %>

<asp:Content ID="BodyContent" ContentPlaceHolderID="MainContent" runat="server">

    <section class="page-hero">
        <div class="site-container">
            <h1>We'd love to hear from you</h1>
            <p class="lead">Questions about a course, trouble with your account, or an idea to make Binary better — send us a message and we'll get back to you.</p>
        </div>
    </section>

    <section class="section-sm">
        <div class="site-container contact-layout">

            <%-- form --%>
            <div class="card contact-card">
                <div class="card-header">
                    <h2>Send a message</h2>
                    <p>Fields marked <span class="req">*</span> are required.</p>
                </div>
                <div class="card-body">

                    <asp:Panel ID="SuccessPanel" runat="server" CssClass="contact-result contact-result-success" Visible="false">
                        <span class="contact-result-icon" aria-hidden="true">
                            <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round"><polyline points="20 6 9 17 4 12"></polyline></svg>
                        </span>
                        <div>
                            <strong>Message sent — thank you!</strong>
                            <p>We've received it and usually reply within 24 hours.</p>
                        </div>
                    </asp:Panel>
                    <asp:Panel ID="ErrorPanel" runat="server" CssClass="contact-result contact-result-error" Visible="false">
                        <span class="contact-result-icon" aria-hidden="true">
                            <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round"><line x1="12" y1="8" x2="12" y2="12"></line><line x1="12" y1="16" x2="12.01" y2="16"></line><circle cx="12" cy="12" r="10"></circle></svg>
                        </span>
                        <div>
                            <strong>Your message wasn't sent</strong>
                            <p><asp:Literal ID="litContactError" runat="server" /></p>
                        </div>
                    </asp:Panel>

                    <div class="grid-2">
                        <div class="form-group">
                            <label class="form-label" for="<%= FirstName.ClientID %>">First name <span class="req">*</span></label>
                            <asp:TextBox ID="FirstName" runat="server" CssClass="form-control" placeholder="Jane" MaxLength="100" autocomplete="given-name" />
                            <asp:RequiredFieldValidator ID="rfvFirstName" runat="server" ControlToValidate="FirstName" CssClass="field-error" ErrorMessage="First name is required." Display="Dynamic" />
                        </div>
                        <div class="form-group">
                            <label class="form-label" for="<%= LastName.ClientID %>">Last name</label>
                            <asp:TextBox ID="LastName" runat="server" CssClass="form-control" placeholder="Doe" MaxLength="100" autocomplete="family-name" />
                        </div>
                    </div>
                    <div class="grid-2">
                        <div class="form-group">
                            <label class="form-label" for="<%= Email.ClientID %>">Email address <span class="req">*</span></label>
                            <asp:TextBox ID="Email" runat="server" CssClass="form-control" TextMode="Email" placeholder="jane@example.com" MaxLength="256" autocomplete="email" />
                            <asp:RequiredFieldValidator ID="rfvEmail" runat="server" ControlToValidate="Email" CssClass="field-error" ErrorMessage="Email is required." Display="Dynamic" />
                            <asp:RegularExpressionValidator ID="revEmail" runat="server" ControlToValidate="Email" CssClass="field-error" ErrorMessage="Enter a valid email address." Display="Dynamic" ValidationExpression="^[^@\s]+@[^@\s]+\.[^@\s]+$" />
                        </div>
                        <div class="form-group">
                            <label class="form-label" for="<%= Subject.ClientID %>">Topic</label>
                            <asp:DropDownList ID="Subject" runat="server" CssClass="form-control">
                                <asp:ListItem Value="">Select a topic…</asp:ListItem>
                                <asp:ListItem Value="general">General inquiry</asp:ListItem>
                                <asp:ListItem Value="course">Course question</asp:ListItem>
                                <asp:ListItem Value="account">Account support</asp:ListItem>
                                <asp:ListItem Value="bug">Report a bug</asp:ListItem>
                                <asp:ListItem Value="feedback">Feedback</asp:ListItem>
                                <asp:ListItem Value="partnership">Partnership</asp:ListItem>
                            </asp:DropDownList>
                        </div>
                    </div>
                    <div class="form-group">
                        <label class="form-label" for="<%= Message.ClientID %>">Message <span class="req">*</span></label>
                        <asp:TextBox ID="Message" runat="server" CssClass="form-control" TextMode="MultiLine" Rows="6" placeholder="Tell us how we can help…" MaxLength="2000" oninput="updateMessageCount(this)" />
                        <div class="contact-message-meta">
                            <asp:RequiredFieldValidator ID="rfvMessage" runat="server" ControlToValidate="Message" CssClass="field-error" ErrorMessage="Message is required." Display="Dynamic" />
                            <span class="contact-count" id="messageCount">0 / 2000</span>
                        </div>
                    </div>
                    <asp:Button ID="SubmitBtn" runat="server" CssClass="btn btn-primary btn-lg" Text="Send message" OnClick="SubmitBtn_Click" style="width:100%;" />
                </div>
            </div>

            <%-- ways to get help --%>
            <aside class="contact-side" aria-label="Other ways to get help">
                <div class="contact-info">
                    <div class="icon-tile"><svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.75" stroke-linecap="round" stroke-linejoin="round" aria-hidden="true"><rect x="2" y="4" width="20" height="16" rx="2"></rect><path d="m22 6-10 7L2 6"></path></svg></div>
                    <div>
                        <h3>Email us</h3>
                        <a href="mailto:hello@binary-learn.com">hello@binary-learn.com</a>
                        <p>We usually reply within 24 hours.</p>
                    </div>
                </div>
                <div class="contact-info">
                    <div class="icon-tile icon-tile-green"><svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.75" stroke-linecap="round" stroke-linejoin="round" aria-hidden="true"><circle cx="12" cy="12" r="10"></circle><path d="M9.09 9a3 3 0 0 1 5.83 1c0 2-3 3-3 3"></path><line x1="12" y1="17" x2="12.01" y2="17"></line></svg></div>
                    <div>
                        <h3>Quick answers</h3>
                        <p>Most questions about XP, titles, and your account are answered in the FAQ.</p>
                        <a href="#faq">Read the FAQ</a>
                    </div>
                </div>
                <div class="contact-info">
                    <div class="icon-tile icon-tile-amber"><svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.75" stroke-linecap="round" stroke-linejoin="round" aria-hidden="true"><path d="M2 4.5h6a4 4 0 0 1 4 4v11a3 3 0 0 0-3-3H2z"></path><path d="M22 4.5h-6a4 4 0 0 0-4 4v11a3 3 0 0 1 3-3h7z"></path></svg></div>
                    <div>
                        <h3>Just want to learn?</h3>
                        <p>Every course is free. Pick a language and start in minutes.</p>
                        <a runat="server" href="~/Courses">Browse courses</a>
                    </div>
                </div>
            </aside>
        </div>
    </section>

    <%-- FAQ (native <details>, works without JavaScript) --%>
    <section class="section" id="faq" style="background:var(--bg-surface);border-top:1px solid var(--border-light);">
        <div class="site-container" style="max-width:780px;">
            <header class="section-header">
                <span class="eyebrow">FAQ</span>
                <h2>Frequently asked questions</h2>
            </header>
            <div class="faq-list">
                <details class="faq-item" open>
                    <summary>Is Binary really free?</summary>
                    <p>Yes. Every course, lesson, video, and quiz is free. You only need an account so we can save your progress and XP.</p>
                </details>
                <details class="faq-item">
                    <summary>How do I earn XP?</summary>
                    <p>You earn +<%= binary.Core.BLL.EnrollmentBLL.LessonXpReward %> XP for each lesson you complete, a +<%= binary.Core.BLL.EnrollmentBLL.CourseCompletionBonusXp %> XP bonus when you finish a whole course, and +<%= binary.Core.BLL.QuizBLL.XpPerCorrectAnswer %> XP for every correct quiz answer.</p>
                </details>
                <details class="faq-item">
                    <summary>What are titles?</summary>
                    <p>Titles show how far you've come: Beginner, Active Learner (50 XP), Avid Explorer (200 XP), Language Scholar (500 XP), and Master Polyglot (1,000 XP). You're notified whenever you unlock a new one, and it appears on your profile and the leaderboard.</p>
                </details>
                <details class="faq-item">
                    <summary>Why can't I see a course's lessons or videos?</summary>
                    <p>Anyone can browse a course's syllabus, but lessons and videos unlock when you enroll. Sign in, open the course, and press <em>Enroll in this Course</em> — it's free.</p>
                </details>
                <details class="faq-item">
                    <summary>How do I change my name, picture, or password?</summary>
                    <p>Open your dashboard and choose <em>Profile</em> in the sidebar (or click your picture in the top-right). You can update your details, upload a new picture, and change your password there.</p>
                </details>
            </div>
        </div>
    </section>

    <script>
        function updateMessageCount(box) {
            var el = document.getElementById('messageCount');
            el.textContent = box.value.length + ' / 2000';
            el.classList.toggle('is-near-limit', box.value.length > 1800);
        }
        (function () {
            var box = document.getElementById('<%= Message.ClientID %>');
            if (box) updateMessageCount(box);
        })();
    </script>

    <style>
        .contact-layout { display: grid; grid-template-columns: minmax(0, 1fr) 340px; gap: var(--space-8); align-items: start; margin-top: calc(-1 * var(--space-10)); position: relative; }
        .contact-card { background: var(--bg-surface); box-shadow: var(--shadow-card); }
        .contact-card .card-header h2 { font-size: 1.25rem; font-weight: 800; }
        .contact-card .card-header p { font-size: 13px; color: var(--text-muted); margin-top: 2px; }
        .req { color: var(--brand-rose); }
        .contact-message-meta { display: flex; justify-content: space-between; align-items: center; gap: var(--space-3); min-height: 18px; }
        .contact-count { margin-left: auto; font-size: 12px; font-weight: 600; color: var(--text-subtle); }
        .contact-count.is-near-limit { color: var(--brand-warm); }
        .contact-result { display: flex; gap: var(--space-3); align-items: flex-start; padding: var(--space-4); border-radius: var(--radius-md); margin-bottom: var(--space-5); font-size: 14px; }
        .contact-result strong { display: block; color: var(--text-primary); }
        .contact-result p { color: var(--text-secondary); font-size: 13.5px; }
        .contact-result-success { background: var(--brand-accent-soft); border: 1px solid rgba(5, 150, 105, 0.25); }
        .contact-result-error { background: var(--brand-rose-soft); border: 1px solid rgba(225, 29, 72, 0.25); }
        .contact-result-icon { width: 28px; height: 28px; border-radius: 50%; display: grid; place-items: center; flex-shrink: 0; color: #ffffff; }
        .contact-result-success .contact-result-icon { background: var(--brand-accent); }
        .contact-result-error .contact-result-icon { background: var(--brand-rose); }
        .contact-result-icon svg { width: 16px; height: 16px; }
        .contact-side { display: flex; flex-direction: column; gap: var(--space-4); }
        .contact-info { display: flex; gap: var(--space-4); align-items: flex-start; padding: var(--space-5); background: var(--bg-surface); border: 1px solid var(--border-light); border-radius: var(--radius-lg); box-shadow: var(--shadow-subtle); }
        .contact-info h3 { font-size: 15px; font-weight: 800; margin-bottom: 2px; }
        .contact-info p { font-size: 13.5px; color: var(--text-secondary); line-height: 1.55; }
        .contact-info a { display: inline-block; font-size: 13.5px; font-weight: 700; color: var(--brand-primary); margin-top: 4px; }
        .contact-info a:hover { text-decoration: underline; }
        .faq-list { display: flex; flex-direction: column; gap: var(--space-3); }
        .faq-item { border: 1px solid var(--border-light); border-radius: var(--radius-md); background: var(--bg-page); transition: border-color 0.15s ease, background 0.15s ease; }
        .faq-item[open] { background: var(--bg-surface); border-color: rgba(67, 56, 202, 0.25); box-shadow: var(--shadow-subtle); }
        .faq-item summary { list-style: none; cursor: pointer; padding: var(--space-4) var(--space-5); font-weight: 700; color: var(--text-primary); display: flex; justify-content: space-between; align-items: center; gap: var(--space-3); }
        .faq-item summary::-webkit-details-marker { display: none; }
        .faq-item summary::after { content: ''; width: 18px; height: 18px; flex-shrink: 0; transition: transform 0.2s ease; background: url("data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 24 24' fill='none' stroke='%2364748b' stroke-width='2' stroke-linecap='round' stroke-linejoin='round'%3E%3Cpolyline points='6 9 12 15 18 9'/%3E%3C/svg%3E") center / 18px no-repeat; }
        .faq-item[open] summary::after { transform: rotate(180deg); }
        .faq-item p { padding: 0 var(--space-5) var(--space-5); color: var(--text-secondary); font-size: 14.5px; line-height: 1.7; }
        html { scroll-behavior: smooth; }
        @media (max-width: 900px) {
            .contact-layout { grid-template-columns: 1fr; margin-top: 0; }
        }
    </style>

</asp:Content>
