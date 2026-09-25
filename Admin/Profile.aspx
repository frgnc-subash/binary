<%@ Page Title="My Profile" Language="C#" MasterPageFile="~/MasterPages/AdminMaster.master" AutoEventWireup="true" CodeBehind="Profile.aspx.cs" Inherits="binary.Admin.AdminProfile" %>

<asp:Content ID="HeaderTitle" ContentPlaceHolderID="AdminHeaderTitle" runat="server">My Profile</asp:Content>
<asp:Content ID="HeaderSubtitle" ContentPlaceHolderID="AdminHeaderSubtitle" runat="server">Your details, picture, and password.</asp:Content>

<asp:Content ID="BodyContent" ContentPlaceHolderID="AdminMainContent" runat="server">

    <asp:Panel ID="pnlSuccess" runat="server" CssClass="auth-alert auth-alert-success" Visible="false" style="margin-bottom:var(--space-4);">
        <asp:Literal ID="litSuccess" runat="server" />
    </asp:Panel>
    <asp:Panel ID="pnlError" runat="server" CssClass="auth-alert auth-alert-error" Visible="false" style="margin-bottom:var(--space-4);">
        <asp:Literal ID="litError" runat="server" />
    </asp:Panel>

    <div class="card profile-hero">
        <div class="profile-hero-avatar" id="profileHeroAvatar">
            <asp:Image ID="imgAvatar" runat="server" CssClass="avatar-img" Visible="false" AlternateText="" />
            <asp:Literal ID="litInitials" runat="server">A</asp:Literal>
        </div>
        <div class="profile-hero-info">
            <h2 class="profile-hero-name"><asp:Literal ID="litName" runat="server" /></h2>
            <div class="profile-hero-meta">
                <span class="profile-title-pill profile-role-pill">
                    <svg class="ui-icon" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" aria-hidden="true"><path d="M12 2 4 5v6c0 5 3.5 9 8 11 4.5-2 8-6 8-11V5z"></path></svg>
                    Administrator
                </span>
                <span><asp:Literal ID="litEmail" runat="server" /></span>
                <span>Member since <asp:Literal ID="litMemberSince" runat="server" /></span>
            </div>
        </div>
    </div>

    <div class="profile-grid">
        <div class="card profile-card">
            <div class="card-header">
                <h3>Personal details</h3>
                <p>Your name and picture appear in the admin panel and on notifications you trigger.</p>
            </div>
            <div class="card-body">
                <div class="form-group">
                    <label class="form-label" for="<%= fuAvatar.ClientID %>">Profile picture</label>
                    <asp:FileUpload ID="fuAvatar" runat="server" CssClass="form-control" accept="image/jpeg,image/png,image/gif,image/webp" onchange="previewAvatar(this)" />
                    <p class="form-hint" id="avatarHint">JPG, PNG, GIF, or WEBP · max 2 MB. The preview updates right away; press Save to keep it.</p>
                </div>
                <div class="grid-2">
                    <div class="form-group">
                        <label class="form-label" for="<%= txtFirstName.ClientID %>">First name</label>
                        <asp:TextBox ID="txtFirstName" runat="server" CssClass="form-control" MaxLength="100" />
                        <asp:RequiredFieldValidator ID="rfvFirst" runat="server" ControlToValidate="txtFirstName" ValidationGroup="ProfileGroup" CssClass="field-error" ErrorMessage="First name is required." Display="Dynamic" />
                    </div>
                    <div class="form-group">
                        <label class="form-label" for="<%= txtLastName.ClientID %>">Last name</label>
                        <asp:TextBox ID="txtLastName" runat="server" CssClass="form-control" MaxLength="100" />
                        <asp:RequiredFieldValidator ID="rfvLast" runat="server" ControlToValidate="txtLastName" ValidationGroup="ProfileGroup" CssClass="field-error" ErrorMessage="Last name is required." Display="Dynamic" />
                    </div>
                </div>
                <div class="form-group">
                    <label class="form-label" for="<%= txtEmail.ClientID %>">Email address</label>
                    <asp:TextBox ID="txtEmail" runat="server" CssClass="form-control" ReadOnly="true" style="background:#f8fafc;color:var(--text-muted);cursor:not-allowed;" />
                    <p class="form-hint">Your sign-in email. Another admin can change it from Users if needed.</p>
                </div>
                <asp:Button ID="btnSaveProfile" runat="server" CssClass="btn btn-primary" Text="Save changes" ValidationGroup="ProfileGroup" OnClick="btnSaveProfile_Click" />
            </div>
        </div>

        <div class="card profile-card" id="password-section">
            <div class="card-header">
                <h3>Password</h3>
                <p>Use at least 8 characters. You'll get a notification whenever it changes.</p>
            </div>
            <div class="card-body">
                <div class="form-group">
                    <label class="form-label" for="<%= txtCurrentPassword.ClientID %>">Current password</label>
                    <asp:TextBox ID="txtCurrentPassword" runat="server" CssClass="form-control" TextMode="Password" autocomplete="current-password" />
                    <asp:RequiredFieldValidator ID="rfvCurrent" runat="server" ControlToValidate="txtCurrentPassword" ValidationGroup="PasswordGroup" CssClass="field-error" ErrorMessage="Current password is required." Display="Dynamic" />
                </div>
                <div class="form-group">
                    <label class="form-label" for="<%= txtNewPassword.ClientID %>">New password</label>
                    <asp:TextBox ID="txtNewPassword" runat="server" CssClass="form-control" TextMode="Password" placeholder="Min. 8 characters" autocomplete="new-password" />
                    <asp:RequiredFieldValidator ID="rfvNew" runat="server" ControlToValidate="txtNewPassword" ValidationGroup="PasswordGroup" CssClass="field-error" ErrorMessage="New password is required." Display="Dynamic" />
                </div>
                <div class="form-group">
                    <label class="form-label" for="<%= txtConfirmPassword.ClientID %>">Confirm new password</label>
                    <asp:TextBox ID="txtConfirmPassword" runat="server" CssClass="form-control" TextMode="Password" autocomplete="new-password" />
                    <asp:CompareValidator ID="cvPassword" runat="server" ControlToValidate="txtConfirmPassword" ControlToCompare="txtNewPassword" ValidationGroup="PasswordGroup" CssClass="field-error" ErrorMessage="Passwords do not match." Display="Dynamic" />
                </div>
                <asp:Button ID="btnChangePassword" runat="server" CssClass="btn btn-outline" Text="Update password" ValidationGroup="PasswordGroup" OnClick="btnChangePassword_Click" />
            </div>
        </div>
    </div>

    <script>
        // instant preview of a newly chosen picture (saved only when Save is pressed)
        function previewAvatar(input) {
            var hint = document.getElementById('avatarHint');
            var file = input.files && input.files[0];
            if (!file) return;
            if (!/^image\/(jpeg|png|gif|webp)$/.test(file.type) || file.size > 2 * 1024 * 1024) {
                hint.textContent = 'Please choose a JPG, PNG, GIF, or WEBP image up to 2 MB.';
                hint.classList.add('text-danger');
                input.value = '';
                return;
            }
            hint.classList.remove('text-danger');
            hint.textContent = 'New picture ready — press Save changes to keep it.';
            var img = document.createElement('img');
            img.className = 'avatar-img';
            img.alt = '';
            img.src = URL.createObjectURL(file);
            var box = document.getElementById('profileHeroAvatar');
            box.innerHTML = '';
            box.appendChild(img);
        }
    </script>

</asp:Content>
