<%@ Page Title="Create Account" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Register.aspx.cs" Inherits="binary.Auth.Register" %>

<asp:Content ID="BodyContent" ContentPlaceHolderID="MainContent" runat="server">

    <section class="auth-page">
        <div class="auth-card card">
            <div class="auth-card-header">
                <div class="brand-mark" style="margin:0 auto var(--space-4);">Bn</div>
                <h1>Create your account</h1>
                <p>Start learning for free — no credit card needed.</p>
            </div>
            <div class="auth-card-body">

                <asp:Panel ID="SuccessPanel" runat="server" CssClass="auth-alert auth-alert-success" Visible="false">
                    &#10003; Account created! Check your email to confirm your address.
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
                <div class="form-group" style="flex-direction:row;align-items:flex-start;gap:var(--space-2);">
                    <asp:CheckBox ID="AgreeTerms" runat="server" style="margin-top:3px;" />
                    <label for="AgreeTerms" style="font-size:13px;color:var(--text-secondary);">I agree to the <a href="#" style="color:var(--brand-primary);font-weight:600;">Terms of Service</a> and <a href="#" style="color:var(--brand-primary);font-weight:600;">Privacy Policy</a></label>
                </div>

                <asp:Button ID="RegisterBtn" runat="server" CssClass="btn btn-primary btn-lg" Text="Create Free Account" OnClick="RegisterBtn_Click" style="width:100%;margin-top:var(--space-2);" />

                <div class="auth-divider"><span>or continue with</span></div>
                <div class="auth-socials">
                    <button class="btn auth-social-btn" type="button">&#128100; Google</button>
                    <button class="btn auth-social-btn" type="button">&#128100; GitHub</button>
                </div>
            </div>
            <div class="auth-card-footer">
                Already have an account? <a runat="server" href="~/Auth/Login.aspx">Sign in &rarr;</a>
            </div>
        </div>
    </section>

    <style>
        .auth-page { display: flex; justify-content: center; align-items: flex-start; padding: var(--space-12) var(--space-4); min-height: calc(100vh - 72px); }
        .auth-card { width: 100%; max-width: 480px; }
        .auth-card-header { text-align: center; padding: var(--space-8) var(--space-8) var(--space-4); }
        .auth-card-header h1 { font-size: 1.75rem; margin-bottom: var(--space-2); }
        .auth-card-header p { color: var(--text-secondary); font-size: 15px; }
        .auth-card-body { padding: var(--space-4) var(--space-8); display: flex; flex-direction: column; }
        .auth-card-body .form-group { margin-bottom: var(--space-4); }
        .auth-card-footer { text-align: center; padding: var(--space-5) var(--space-8); border-top: 1px solid var(--border-light); font-size: 14px; color: var(--text-secondary); }
        .auth-card-footer a { color: var(--brand-primary); font-weight: 600; }
        .auth-alert { padding: var(--space-3) var(--space-4); border-radius: var(--radius-md); font-size: 14px; font-weight: 500; margin-bottom: var(--space-4); }
        .auth-alert-success { background: hsla(168, 78%, 42%, 0.1); border: 1px solid var(--brand-secondary); color: var(--brand-secondary); }
        .auth-divider { position: relative; text-align: center; margin: var(--space-5) 0; }
        .auth-divider::before { content: ''; position: absolute; top: 50%; left: 0; right: 0; height: 1px; background: var(--border-light); }
        .auth-divider span { position: relative; background: var(--surface-base); padding: 0 var(--space-3); font-size: 13px; color: var(--text-muted); font-weight: 500; }
        .auth-socials { display: grid; grid-template-columns: 1fr 1fr; gap: var(--space-3); }
        .auth-social-btn { border: 1.5px solid var(--border-mid); background: var(--surface-base); color: var(--text-secondary); font-size: 14px; font-weight: 600; gap: var(--space-2); }
        .auth-social-btn:hover { border-color: var(--brand-primary); color: var(--brand-primary); background: hsla(246,80%,60%,0.05); }
        .field-error { color: hsl(0, 75%, 55%); font-size: 13px; margin-top: var(--space-1); display: block; }
    </style>

</asp:Content>
