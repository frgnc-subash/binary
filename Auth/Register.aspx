<%@ Page Title="Create Account" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Register.aspx.cs" Inherits="binary.Auth.Register" %>

<asp:Content ID="BodyContent" ContentPlaceHolderID="MainContent" runat="server">

    <section class="auth-page">
        <div class="auth-card card">
            <div class="auth-card-header">
                <div class="brand-mark" style="margin:0 auto var(--space-3);">Bn</div>
                <h1 style="font-size:1.6rem;margin-bottom:4px;">Create your account</h1>
                <p style="color:var(--text-muted);font-size:14px;">Start learning any language with free structured lessons.</p>
            </div>
            <div class="auth-card-body">

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
            <div class="auth-card-footer" style="text-align:center;font-size:13.5px;color:var(--text-secondary);">
                Already have an account? <a runat="server" href="~/Auth/Login.aspx" style="color:var(--brand-primary);font-weight:700;">Sign in &rarr;</a>
            </div>
        </div>
    </section>

    <style>
        .auth-page { display: flex; justify-content: center; align-items: flex-start; padding: var(--space-10) var(--space-4); min-height: calc(100vh - 120px); }
        .auth-card { width: 100%; max-width: 460px; background: #ffffff; }
        .auth-card-header { text-align: center; padding: var(--space-6) var(--space-8) var(--space-2); }
        .auth-card-body { padding: var(--space-4) var(--space-8) var(--space-6); display: flex; flex-direction: column; }
    </style>

</asp:Content>
