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
                    <li><span class="onb-welcome-icon"><%= binary.Core.Helpers.Icons.Svg("book") %></span>Choose the languages you want to learn</li>
                    <li><span class="onb-welcome-icon"><%= binary.Core.Helpers.Icons.Svg("globe") %></span>Tell us the languages you already speak</li>
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
                <p class="onb-lead">Pick one or more courses. We'll enroll you in all of them, and you can add more any time.</p>
                <div class="onb-grid">
                    <asp:Repeater ID="rptCourses" runat="server">
                        <ItemTemplate>
                            <label class="onb-option">
                                <input type="checkbox" name="onbCourse" value="<%# Eval("CourseID") %>" <%# IsChecked("onbCourse", Eval("CourseID")) %> data-label="<%# HttpUtility.HtmlAttributeEncode((string)Eval("Title")) %>" />
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
                    <span class="onb-count" aria-live="polite"></span>
                    <button type="button" class="btn btn-primary onb-continue" onclick="onboarding.next()" disabled>Continue</button>
                </div>
            </section>

            <%-- step 2: what do you speak --%>
            <section class="onb-step" data-step="2" data-field="onbNative" aria-labelledby="onbSpeakTitle">
                <span class="onb-step-label">Step 2 of 3</span>
                <h2 id="onbSpeakTitle">Which languages do you already speak?</h2>
                <p class="onb-lead">Select all that apply. We'll use this to personalise your learning.</p>
                <div class="onb-grid onb-grid-compact">
                    <asp:Repeater ID="rptNative" runat="server">
                        <ItemTemplate>
                            <label class="onb-option">
                                <input type="checkbox" name="onbNative" value="<%# Eval("Key") %>" <%# IsChecked("onbNative", Eval("Key")) %> data-label="<%# HttpUtility.HtmlAttributeEncode((string)Eval("Label")) %>" />
                                <%# RenderOptionBadge(Container.DataItem) %>
                                <span class="onb-option-text"><strong><%# HttpUtility.HtmlEncode((string)Eval("Label")) %></strong></span>
                            </label>
                        </ItemTemplate>
                    </asp:Repeater>
                </div>
                <div class="onb-actions">
                    <button type="button" class="btn btn-outline" onclick="onboarding.back()">Back</button>
                    <span class="onb-count" aria-live="polite"></span>
                    <button type="button" class="btn btn-primary onb-continue" onclick="onboarding.next()" disabled>Continue</button>
                </div>
            </section>

            <%-- step 3: why (optional) --%>
            <section class="onb-step" data-step="3" data-field="onbReason" data-optional="true" aria-labelledby="onbWhyTitle">
                <span class="onb-step-label">Step 3 of 3</span>
                <h2 id="onbWhyTitle">Why are you learning?</h2>
                <p class="onb-lead">Select all that apply. Optional, but it helps us keep you motivated.</p>
                <div class="onb-grid onb-grid-compact">
                    <asp:Repeater ID="rptReasons" runat="server">
                        <ItemTemplate>
                            <label class="onb-option">
                                <input type="checkbox" name="onbReason" value="<%# Eval("Key") %>" <%# IsChecked("onbReason", Eval("Key")) %> data-label="<%# HttpUtility.HtmlAttributeEncode((string)Eval("Label")) %>" />
                                <%# RenderOptionBadge(Container.DataItem) %>
                                <span class="onb-option-text"><strong><%# HttpUtility.HtmlEncode((string)Eval("Label")) %></strong></span>
                            </label>
                        </ItemTemplate>
                    </asp:Repeater>
                </div>
                <div class="onb-actions">
                    <button type="button" class="btn btn-outline" onclick="onboarding.back()">Back</button>
                    <button type="button" class="btn btn-ghost" onclick="onboarding.skip()">Skip</button>
                    <span class="onb-count" aria-live="polite"></span>
                    <button type="button" class="btn btn-primary onb-continue" onclick="onboarding.next()" disabled>Continue</button>
                </div>
            </section>

            <%-- step 4: summary, then on to registration --%>
            <section class="onb-step" data-step="4" aria-labelledby="onbDoneTitle">
                <span class="onb-done-icon"><%= binary.Core.Helpers.Icons.Svg("check") %></span>
                <h2 id="onbDoneTitle">You're all set</h2>
                <p class="onb-lead">Here's your plan. Create a free account and we'll enroll you in your courses straight away.</p>
                <dl class="onb-summary">
                    <div><dt>Learning</dt><dd id="sumCourse">-</dd></div>
                    <div><dt>You speak</dt><dd id="sumNative">-</dd></div>
                    <div><dt>Goals</dt><dd id="sumReason">-</dd></div>
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
                return document.querySelectorAll('input[name="' + name + '"]:checked');
            }

            function labels(name) {
                var picked = selected(name), out = [];
                for (var i = 0; i < picked.length; i++) out.push(picked[i].getAttribute('data-label'));
                return out.join(', ');
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
                document.getElementById('sumCourse').textContent = labels('onbCourse') || 'Choose later';
                document.getElementById('sumNative').textContent = labels('onbNative') || '-';
                document.getElementById('sumReason').textContent = labels('onbReason') || 'Not set';
            }

            // highlight picked options; a step's Continue button is enabled while anything in it is picked
            function refreshStep(step) {
                var inputs = step.querySelectorAll('.onb-option input');
                var any = false;
                for (var i = 0; i < inputs.length; i++) {
                    inputs[i].closest('.onb-option').classList.toggle('is-selected', inputs[i].checked);
                    if (inputs[i].checked) any = true;
                }
                var btn = step.querySelector('.onb-continue');
                if (btn && inputs.length) btn.disabled = !any;
                var count = step.querySelector('.onb-count');
                if (count) count.textContent = any ? selected(inputs[0].name).length + ' selected' : '';
            }

            document.addEventListener('change', function (e) {
                if (!e.target.matches('.onb-option input')) return;
                refreshStep(e.target.closest('.onb-step'));
            });

            function skip() {
                var step = steps[current];
                var picked = step.querySelectorAll('.onb-option input:checked');
                for (var i = 0; i < picked.length; i++) picked[i].checked = false;
                refreshStep(step);
                show(current + 1);
            }

            // answers restored after a server round trip
            for (var s = 0; s < steps.length; s++) refreshStep(steps[s]);

            // with no courses published there's nothing to pick; let people through to the account step
            var courseStep = document.querySelector('.onb-step[data-step="1"]');
            if (courseStep && !courseStep.querySelector('.onb-option')) courseStep.querySelector('.onb-continue').disabled = false;

            show(<%= InitialStep %>);
            return { next: function () { show(current + 1); }, back: function () { show(current - 1); }, skip: skip };
        })();
    </script>

</asp:Content>
