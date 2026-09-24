<%@ Page Title="Community Learners" Language="C#" MasterPageFile="~/MasterPages/Site.Master" AutoEventWireup="true" CodeBehind="Default.aspx.cs" Inherits="binary.Users.UsersHome" %>

<asp:Content ID="BodyContent" ContentPlaceHolderID="MainContent" runat="server">

    <section class="page-hero" style="background:linear-gradient(160deg,hsl(230,30%,98%),hsl(246,40%,96%));">
        <div class="site-container">
            <div class="page-hero-badge">&#128101; Community</div>
            <h1>Learn Together with <span class="gradient-text">Fellow Polyglots</span></h1>
            <p class="lead">Connect with learners around the world, compare XP, and practice together.</p>
        </div>
    </section>

    <section class="section">
        <div class="site-container">
            <div class="grid-3">
                <asp:Repeater ID="rptTopLearners" runat="server">
                    <ItemTemplate>
                        <div class="card card-body" style="text-align:center;">
                            <div style="width:64px;height:64px;border-radius:50%;background:var(--brand-primary);color:#fff;font-weight:800;font-size:1.3rem;display:inline-grid;place-items:center;margin-bottom:var(--space-3);"><%# binary.Core.Helpers.DisplayHelper.GetInitials((string)Eval("FirstName"), (string)Eval("LastName")) %></div>
                            <h3 style="font-size:1.1rem;margin-bottom:2px;"><%# HttpUtility.HtmlEncode((string)Eval("FirstName") + " " + (string)Eval("LastName")) %></h3>
                            <p style="font-size:13px;color:var(--text-muted);margin-bottom:var(--space-3);">Rank #<%# Container.ItemIndex + 1 %> on the leaderboard</p>
                            <div style="display:flex;justify-content:center;gap:var(--space-2);margin-bottom:var(--space-4);">
                                <span class="badge badge-primary"><%# Eval("TotalXP") %> XP</span>
                            </div>
                            <a class="btn btn-outline" style="width:100%;" runat="server" href="~/Leaderboard">View Leaderboard</a>
                        </div>
                    </ItemTemplate>
                </asp:Repeater>
                <asp:Panel ID="pnlNoLearners" runat="server" Visible="false" style="grid-column:1/-1;text-align:center;color:var(--text-muted);padding:var(--space-10) 0;">
                    No learners have earned XP yet — <a runat="server" href="~/Courses">start a course</a> to be the first!
                </asp:Panel>
            </div>
        </div>
    </section>

</asp:Content>
