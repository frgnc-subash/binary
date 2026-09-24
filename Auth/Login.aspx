<%@ Page Title="Sign In" Language="C#" MasterPageFile="~/MasterPages/Site.Master" AutoEventWireup="true" CodeBehind="Login.aspx.cs" Inherits="binary.Auth.Login" %>

<asp:Content ID="BodyContent" ContentPlaceHolderID="MainContent" runat="server">

    <section class="auth-page">
        <div class="auth-card card">
            <div class="auth-card-header">
                <img class="auth-logo" runat="server" src="~/Content/images/logo.png" alt="Binary" />
                <h1 style="font-size:1.6rem;margin-bottom:4px;">Sign in to Binary</h1>
                <p style="color:var(--text-muted);font-size:14px;">Continue your personalized language lessons.</p>
            </div>
            <div class="auth-card-body">

                <asp:Panel ID="ErrorPanel" runat="server" CssClass="auth-alert auth-alert-error" Visible="false">
                    <asp:Literal ID="litErrorMessage" runat="server">Invalid email or password. Please try again.</asp:Literal>
                </asp:Panel>

                <div class="form-group">
                    <label class="form-label" for="EmailInput">Email Address</label>
                    <asp:TextBox ID="EmailInput" runat="server" CssClass="form-control" TextMode="Email" placeholder="you@example.com" />
                    <asp:RequiredFieldValidator ID="rfvEmail" runat="server" ControlToValidate="EmailInput" CssClass="field-error" ErrorMessage="Email is required." Display="Dynamic" />
                </div>
                <div class="form-group">
                    <label class="form-label" for="PasswordInput">Password</label>
                    <asp:TextBox ID="PasswordInput" runat="server" CssClass="form-control" TextMode="Password" placeholder="••••••••" />
                    <asp:RequiredFieldValidator ID="rfvPassword" runat="server" ControlToValidate="PasswordInput" CssClass="field-error" ErrorMessage="Password is required." Display="Dynamic" />
                </div>
                <div class="form-group" style="flex-direction:row;align-items:center;gap:var(--space-2);margin-bottom:var(--space-4);">
                    <asp:CheckBox ID="RememberMe" runat="server" />
                    <label for="RememberMe" style="font-size:13.5px;color:var(--text-secondary);cursor:pointer;">Remember this device</label>
                </div>

                <asp:Button ID="LoginBtn" runat="server" CssClass="btn btn-primary btn-lg" Text="Sign In" OnClick="LoginBtn_Click" style="width:100%;" />
            </div>
            <div class="auth-card-footer card-footer" style="text-align:center;font-size:13.5px;color:var(--text-secondary);">
                Don't have an account? <a href="<%= BuildAuthCrossLink("~/Auth/Register.aspx") %>" style="color:var(--brand-primary);font-weight:700;">Create one free<svg class="ui-icon ui-icon-after" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" aria-hidden="true"><line x1="5" y1="12" x2="19" y2="12"></line><polyline points="12 5 19 12 12 19"></polyline></svg></a>
            </div>
        </div>
    </section>

    <style>
        .auth-page { display: flex; justify-content: center; align-items: flex-start; padding: var(--space-12) var(--space-4); min-height: calc(100vh - 120px); }
        .auth-card { width: 100%; max-width: 420px; background: #ffffff; }
        .auth-card-header { text-align: center; padding: var(--space-8) var(--space-8) var(--space-2); }
        .auth-card-body { padding: var(--space-4) var(--space-8) var(--space-6); display: flex; flex-direction: column; }
    </style>

</asp:Content>
