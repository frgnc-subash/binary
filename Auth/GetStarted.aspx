<%@ Page Title="Get Started" Language="C#" MasterPageFile="~/MasterPages/Site.Master" AutoEventWireup="true" CodeBehind="GetStarted.aspx.cs" Inherits="binary.Auth.GetStarted" %>

<asp:Content ID="BodyContent" ContentPlaceHolderID="MainContent" runat="server">

    <div class="onb-shell">
        <header class="onb-top">
            <a class="brand-link" runat="server" href="~/" title="Binary home">
                <img class="brand-logo" runat="server" src="~/Content/images/logo-mark.png" alt="" />
                <span class="brand-text"><span class="brand-name">Binary</span></span>
            </a>
            <div class="onb-progress" aria-hidden="true"><div class="onb-progress-bar" id="onbProgress"></div></div>
            <a class="onb-signin" runat="server" href="~/Auth/Login.aspx">I already have an account</a>
        </header>

        <main class="onb-main">
            <asp:Panel ID="pnlError" runat="server" CssClass="auth-alert auth-alert-error onb-error" Visible="false">
                <asp:Literal ID="litError" runat="server" />
            </asp:Panel>

            <%-- step 0: welcome --%>
            <section class="onb-step is-active" data-step="0" aria-labelledby="onbWelcomeTitle">
                <img class="onb-hero-logo" runat="server" src="~/Content/images/logo.png" alt="Binary" />
                <h1 id="onbWelcomeTitle">Welcome to Binary</h1>
                <p class="onb-lead">Let's set up your learning in three quick questions. It takes less than a minute.</p>
                <ul class="onb-welcome-list">
                    <li><span class="onb-welcome-icon"><%= binary.Core.Helpers.Icons.Svg("book") %></span>Choose the language you want to learn</li>
                    <li><span class="onb-welcome-icon"><%= binary.Core.Helpers.Icons.Svg("globe") %></span>Tell us the language you already speak</li>
                    <li><span class="onb-welcome-icon"><%= binary.Core.Helpers.Icons.Svg("target") %></span>Share why you're learning, then create your account</li>
                </ul>
                <div class="onb-actions onb-actions-center">
                    <button type="button" class="btn btn-primary btn-lg" onclick="onboarding.next()">Let's begin</button>
                </div>
            </section>

            <%-- step 1: what do you want to learn --%>
            <section class="onb-step" data-step="1" data-field="onbCourse" aria-labelledby="onbLearnTitle">
                <span class="onb-step-label">Step 1 of 3</span>
                <h2 id="onbLearnTitle">What do you want to learn?</h2>
                <p class="onb-lead">Pick a course to start with. You can enroll in more any time.</p>
                <div class="onb-grid">
                    <asp:Repeater ID="rptCourses" runat="server">
                        <ItemTemplate>
                            <label class="onb-option">
                                <input type="radio" name="onbCourse" value="<%# Eval("CourseID") %>" <%# IsChecked("onbCourse", Eval("CourseID")) %> data-label="<%# HttpUtility.HtmlAttributeEncode((string)Eval("Title")) %>" />
                                <%# binary.Core.Helpers.FlagHelper.Render((string)Eval("FlagImageUrl"), (string)Eval("Title"), "flag-md") %>
                                <span class="onb-option-text">
                                    <strong><%# HttpUtility.HtmlEncode((string)Eval("Title")) %></strong>
                                    <small><%# HttpUtility.HtmlEncode((string)Eval("Level")) %> &middot; <%# GetLessonCount((int)Eval("CourseID")) %> lessons</small>
                                </span>
                            </label>
                        </ItemTemplate>
                    </asp:Repeater>
                </div>
                <asp:Panel ID="pnlNoCourses" runat="server" Visible="false" CssClass="onb-empty">
                    No courses are available yet. You can still create your account and enroll later.
                </asp:Panel>
                <div class="onb-actions">
                    <button type="button" class="btn btn-outline" onclick="onboarding.back()">Back</button>
                    <button type="button" class="btn btn-primary onb-continue" onclick="onboarding.next()" disabled>Continue</button>
                </div>
            </section>

            <%-- step 2: what do you speak --%>
            <section class="onb-step" data-step="2" data-field="onbNative" aria-labelledby="onbSpeakTitle">
                <span class="onb-step-label">Step 2 of 3</span>
                <h2 id="onbSpeakTitle">Which language do you already speak?</h2>
                <p class="onb-lead">We'll use this to personalise your learning.</p>
                <div class="onb-grid onb-grid-compact">
                    <asp:Repeater ID="rptNative" runat="server">
                        <ItemTemplate>
                            <label class="onb-option">
                                <input type="radio" name="onbNative" value="<%# Eval("Key") %>" <%# IsChecked("onbNative", Eval("Key")) %> data-label="<%# HttpUtility.HtmlAttributeEncode((string)Eval("Label")) %>" />
                                <%# RenderOptionBadge(Container.DataItem) %>
                                <span class="onb-option-text"><strong><%# HttpUtility.HtmlEncode((string)Eval("Label")) %></strong></span>
                            </label>
                        </ItemTemplate>
                    </asp:Repeater>
                </div>
                <div class="onb-actions">
                    <button type="button" class="btn btn-outline" onclick="onboarding.back()">Back</button>
                    <button type="button" class="btn btn-primary onb-continue" onclick="onboarding.next()" disabled>Continue</button>
                </div>
            </section>

            <%-- step 3: why (optional) --%>
            <section class="onb-step" data-step="3" data-field="onbReason" data-optional="true" aria-labelledby="onbWhyTitle">
                <span class="onb-step-label">Step 3 of 3</span>
                <h2 id="onbWhyTitle">Why are you learning?</h2>
                <p class="onb-lead">Optional, but it helps us keep you motivated.</p>
                <div class="onb-grid onb-grid-compact">
                    <asp:Repeater ID="rptReasons" runat="server">
                        <ItemTemplate>
                            <label class="onb-option">
                                <input type="radio" name="onbReason" value="<%# Eval("Key") %>" <%# IsChecked("onbReason", Eval("Key")) %> data-label="<%# HttpUtility.HtmlAttributeEncode((string)Eval("Label")) %>" />
                                <%# RenderOptionBadge(Container.DataItem) %>
                                <span class="onb-option-text"><strong><%# HttpUtility.HtmlEncode((string)Eval("Label")) %></strong></span>
                            </label>
                        </ItemTemplate>
                    </asp:Repeater>
                </div>
                <div class="onb-actions">
                    <button type="button" class="btn btn-outline" onclick="onboarding.back()">Back</button>
                    <button type="button" class="btn btn-ghost" onclick="onboarding.skip()">Skip</button>
                    <button type="button" class="btn btn-primary onb-continue" onclick="onboarding.next()" disabled>Continue</button>
                </div>
            </section>

            <%-- step 4: summary, then on to registration --%>
            <section class="onb-step" data-step="4" aria-labelledby="onbDoneTitle">
                <span class="onb-done-icon"><%= binary.Core.Helpers.Icons.Svg("check") %></span>
                <h2 id="onbDoneTitle">You're all set</h2>
                <p class="onb-lead">Here's your plan. Create a free account and we'll enroll you straight away.</p>
                <dl class="onb-summary">
                    <div><dt>Learning</dt><dd id="sumCourse">-</dd></div>
                    <div><dt>You speak</dt><dd id="sumNative">-</dd></div>
                    <div><dt>Goal</dt><dd id="sumReason">-</dd></div>
                </dl>
                <div class="onb-actions onb-actions-center">
                    <button type="button" class="btn btn-outline" onclick="onboarding.back()">Back</button>
                    <asp:Button ID="btnFinish" runat="server" CssClass="btn btn-primary btn-lg" Text="Create my free account" OnClick="btnFinish_Click" />
                </div>
            </section>
        </main>
    </div>

    <script>
        var onboarding = (function () {
            var steps = document.querySelectorAll('.onb-step');
            var total = steps.length - 1;
            var current = 0;

            function selected(name) {
                return document.querySelector('input[name="' + name + '"]:checked');
            }

            function show(index) {
                current = Math.max(0, Math.min(total, index));
                for (var i = 0; i < steps.length; i++) steps[i].classList.toggle('is-active', i === current);
                document.getElementById('onbProgress').style.width = (current / total * 100) + '%';
                if (current === total) fillSummary();
                var heading = steps[current].querySelector('h1, h2');
                if (heading) { heading.setAttribute('tabindex', '-1'); heading.focus({ preventScroll: true }); }
                window.scrollTo({ top: 0, behavior: 'smooth' });
            }

            function fillSummary() {
                var course = selected('onbCourse'), native = selected('onbNative'), reason = selected('onbReason');
                document.getElementById('sumCourse').textContent = course ? course.getAttribute('data-label') : 'Choose later';
                document.getElementById('sumNative').textContent = native ? native.getAttribute('data-label') : '-';
                document.getElementById('sumReason').textContent = reason ? reason.getAttribute('data-label') : 'Not set';
            }

            // a step's Continue button unlocks once one of its options is picked
            function markSelected(input) {
                var group = document.querySelectorAll('input[name="' + input.name + '"]');
                for (var i = 0; i < group.length; i++) group[i].closest('.onb-option').classList.toggle('is-selected', group[i].checked);
            }

            document.addEventListener('change', function (e) {
                if (!e.target.matches('.onb-option input')) return;
                markSelected(e.target);
                var step = e.target.closest('.onb-step');
                var btn = step.querySelector('.onb-continue');
                if (btn) btn.disabled = false;
            });

            function skip() {
                var reason = selected('onbReason');
                if (reason) { reason.checked = false; markSelected(reason); }
                show(current + 1);
            }

            // answers restored after a server round trip: unlock those steps' Continue buttons
            var answered = document.querySelectorAll('.onb-option input:checked');
            for (var i = 0; i < answered.length; i++) {
                markSelected(answered[i]);
                var btn = answered[i].closest('.onb-step').querySelector('.onb-continue');
                if (btn) btn.disabled = false;
            }

            // with no courses published there's nothing to pick; let people through to the account step
            var courseStep = document.querySelector('.onb-step[data-step="1"]');
            if (courseStep && !courseStep.querySelector('.onb-option')) courseStep.querySelector('.onb-continue').disabled = false;

            show(<%= InitialStep %>);
            return { next: function () { show(current + 1); }, back: function () { show(current - 1); }, skip: skip };
        })();
    </script>

</asp:Content>
