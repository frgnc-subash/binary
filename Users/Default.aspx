<%@ Page Title="Community Learners" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Default.aspx.cs" Inherits="binary.Users.UsersHome" %>

<asp:Content ID="BodyContent" ContentPlaceHolderID="MainContent" runat="server">

    <section class="page-hero" style="background:linear-gradient(160deg,hsl(230,30%,98%),hsl(246,40%,96%));">
        <div class="site-container">
            <div class="page-hero-badge">&#128101; Community</div>
            <h1>Learn Together with <span class="gradient-text">Fellow Polyglots</span></h1>
            <p class="lead">Connect with learners around the world, compare streaks, and practice together.</p>
        </div>
    </section>

    <section class="section">
        <div class="site-container">
            <div class="grid-3">

                <div class="card card-body" style="text-align:center;">
                    <div style="width:64px;height:64px;border-radius:50%;background:hsl(246,80%,60%);color:#fff;font-weight:800;font-size:1.3rem;display:inline-grid;place-items:center;margin-bottom:var(--space-3);">JD</div>
                    <h3 style="font-size:1.1rem;margin-bottom:2px;">Jane Doe</h3>
                    <p style="font-size:13px;color:var(--text-muted);margin-bottom:var(--space-3);">Learning Spanish & Japanese</p>
                    <div style="display:flex;justify-content:center;gap:var(--space-2);margin-bottom:var(--space-4);">
                        <span class="badge badge-primary">3.8k XP</span>
                        <span class="badge badge-success">&#128293; 42 Days</span>
                    </div>
                    <a class="btn btn-outline" style="width:100%;" runat="server" href="~/Users/Profile.aspx">View Profile</a>
                </div>

                <div class="card card-body" style="text-align:center;">
                    <div style="width:64px;height:64px;border-radius:50%;background:hsl(168,78%,42%);color:#fff;font-weight:800;font-size:1.3rem;display:inline-grid;place-items:center;margin-bottom:var(--space-3);">AM</div>
                    <h3 style="font-size:1.1rem;margin-bottom:2px;">Alex Martinez</h3>
                    <p style="font-size:13px;color:var(--text-muted);margin-bottom:var(--space-3);">Learning French</p>
                    <div style="display:flex;justify-content:center;gap:var(--space-2);margin-bottom:var(--space-4);">
                        <span class="badge badge-primary">5.1k XP</span>
                        <span class="badge badge-success">&#128293; 68 Days</span>
                    </div>
                    <a class="btn btn-outline" style="width:100%;" href="#">View Profile</a>
                </div>

                <div class="card card-body" style="text-align:center;">
                    <div style="width:64px;height:64px;border-radius:50%;background:hsl(32,100%,60%);color:#fff;font-weight:800;font-size:1.3rem;display:inline-grid;place-items:center;margin-bottom:var(--space-3);">SK</div>
                    <h3 style="font-size:1.1rem;margin-bottom:2px;">Sara Kim</h3>
                    <p style="font-size:13px;color:var(--text-muted);margin-bottom:var(--space-3);">Learning German & Italian</p>
                    <div style="display:flex;justify-content:center;gap:var(--space-2);margin-bottom:var(--space-4);">
                        <span class="badge badge-primary">2.9k XP</span>
                        <span class="badge badge-success">&#128293; 21 Days</span>
                    </div>
                    <a class="btn btn-outline" style="width:100%;" href="#">View Profile</a>
                </div>

            </div>
        </div>
    </section>

</asp:Content>
