<%@ Page Title="Create Account" Language="C#" MasterPageFile="~/MasterPages/Site.Master" AutoEventWireup="true" CodeBehind="Register.aspx.cs" Inherits="binary.Auth.Register" %>

<asp:Content ID="BodyContent" ContentPlaceHolderID="MainContent" runat="server">

    <section class="auth-page">
        <div class="auth-card card">
            <div class="auth-card-header">
                <img class="auth-logo" runat="server" src="~/Content/images/logo.png" alt="Binary" />
                <h1 style="font-size:1.6rem;margin-bottom:4px;">Create your account</h1>
                <p style="color:var(--text-muted);font-size:14px;">Start learning any language with free structured lessons.</p>
            </div>
            <div class="auth-card-body">

                <%-- choices from the Get Started onboarding, if the visitor came through it --%>
                <asp:Panel ID="pnlOnboarding" runat="server" Visible="false" CssClass="onb-plan">
                    <asp:Literal ID="litOnboardingFlag" runat="server" />
                    <div class="onb-plan-text">
                        <span class="onb-plan-label">Your plan</span>
                        <strong><asp:Literal ID="litOnboardingCourse" runat="server" /></strong>
                        <small><asp:Literal ID="litOnboardingMeta" runat="server" /></small>
                    </div>
                    <a class="onb-plan-change" runat="server" href="~/Auth/GetStarted.aspx">Change</a>
                </asp:Panel>

                <asp:Panel ID="ErrorPanel" runat="server" CssClass="auth-alert auth-alert-error" Visible="false">
                    <asp:Literal ID="litRegisterError" runat="server" />
                </asp:Panel>
                <asp:Panel ID="SuccessPanel" runat="server" CssClass="auth-alert auth-alert-success" Visible="false">
                    <asp:Literal ID="litRegisterSuccess" runat="server">Account created successfully! Redirecting...</asp:Literal>
                </asp:Panel>

                <div class="grid-2">
                    <div class="form-group">
                        <label class="form-label" for="FirstName">First Name</label>
                        <asp:TextBox ID="FirstName" runat="server" CssClass="form-control" placeholder="Jane" />
                        <asp:RequiredFieldValidator ID="rfvFirstName" runat="server" ControlToValidate="FirstName" CssClass="field-error" ErrorMessage="Required." Display="Dynamic" />
                    </div>
                    <div class="form-group">
                        <label class="form-label" for="LastName">Last Name</label>
                        <asp:TextBox ID="LastName" runat="server" CssClass="form-control" placeholder="Doe" />
                    </div>
                </div>
                <div class="form-group">
                    <label class="form-label" for="EmailInput">Email Address</label>
                    <asp:TextBox ID="EmailInput" runat="server" CssClass="form-control" TextMode="Email" placeholder="you@example.com" />
                    <asp:RequiredFieldValidator ID="rfvEmail" runat="server" ControlToValidate="EmailInput" CssClass="field-error" ErrorMessage="Email is required." Display="Dynamic" />
                </div>
                <div class="form-group">
                    <label class="form-label" for="PasswordInput">Password</label>
                    <asp:TextBox ID="PasswordInput" runat="server" CssClass="form-control" TextMode="Password" placeholder="Min. 8 characters" />
                    <asp:RequiredFieldValidator ID="rfvPassword" runat="server" ControlToValidate="PasswordInput" CssClass="field-error" ErrorMessage="Password is required." Display="Dynamic" />
                </div>
                <div class="form-group">
                    <label class="form-label" for="ConfirmPassword">Confirm Password</label>
                    <asp:TextBox ID="ConfirmPassword" runat="server" CssClass="form-control" TextMode="Password" placeholder="Repeat password" />
                    <asp:CompareValidator ID="cvPassword" runat="server" ControlToValidate="ConfirmPassword" ControlToCompare="PasswordInput" CssClass="field-error" ErrorMessage="Passwords do not match." Display="Dynamic" />
                </div>
                <div class="form-group" style="flex-direction:row;align-items:flex-start;gap:var(--space-2);margin-bottom:var(--space-4);">
                    <asp:CheckBox ID="AgreeTerms" runat="server" Checked="true" style="margin-top:2px;" />
                    <label for="AgreeTerms" style="font-size:13px;color:var(--text-secondary);">I agree to the Terms of Service and Privacy Policy</label>
                </div>

                <asp:Button ID="RegisterBtn" runat="server" CssClass="btn btn-primary btn-lg" Text="Create Free Account" OnClick="RegisterBtn_Click" style="width:100%;" />
            </div>
            <div class="auth-card-footer card-footer" style="text-align:center;font-size:13.5px;color:var(--text-secondary);">
                Already have an account? <a href="<%= BuildAuthCrossLink("~/Auth/Login.aspx") %>" style="color:var(--brand-primary);font-weight:700;">Sign in<svg class="ui-icon ui-icon-after" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" aria-hidden="true"><line x1="5" y1="12" x2="19" y2="12"></line><polyline points="12 5 19 12 12 19"></polyline></svg></a>
            </div>
        </div>
    </section>

    <style>
        .auth-page { display: flex; justify-content: center; align-items: flex-start; padding: var(--space-10) var(--space-4); min-height: calc(100vh - 120px); }
        .auth-card { width: 100%; max-width: 460px; background: var(--bg-surface); }
        .auth-card-header { text-align: center; padding: var(--space-6) var(--space-8) var(--space-2); }
        .auth-card-body { padding: var(--space-4) var(--space-8) var(--space-6); display: flex; flex-direction: column; }
    </style>

</asp:Content>
