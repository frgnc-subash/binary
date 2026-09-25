<%@ Page Title="Leaderboard" Language="C#" MasterPageFile="~/MasterPages/Site.Master" AutoEventWireup="true" CodeBehind="Default.aspx.cs" Inherits="binary.Leaderboard.LeaderboardHome" %>

<asp:Content ID="BodyContent" ContentPlaceHolderID="MainContent" runat="server">

    <section class="section-sm" style="background:var(--bg-surface);border-bottom:1px solid var(--border-light);">
        <div class="site-container" style="text-align:center;max-width:640px;margin:0 auto;">
            <span class="badge badge-primary" style="margin-bottom:var(--space-2);">Leaderboard</span>
            <h1 style="font-size:2.2rem;margin-bottom:var(--space-2);">Top Learners</h1>
            <p style="color:var(--text-secondary);font-size:15px;">Earn XP by completing lessons and finishing courses to climb the ranks.</p>
        </div>
    </section>

    <section class="section">
        <div class="site-container" style="max-width:760px;">
            <div class="card">
                <table class="leaderboard-table">
                    <thead>
                        <tr><th>Rank</th><th>Learner</th><th>XP</th></tr>
                    </thead>
                    <tbody>
                        <asp:Repeater ID="rptLeaderboard" runat="server" OnItemDataBound="rptLeaderboard_ItemDataBound">
                            <ItemTemplate>
                                <tr class="leaderboard-row" runat="server" id="trRow">
                                    <td><span class="rank-badge">#<%# Container.ItemIndex + 1 %></span></td>
                                    <td>
                                        <div class="tbl-user">
                                            <div class="tbl-avatar" style="background:var(--brand-primary);"><%# binary.Core.Helpers.DisplayHelper.GetInitials((string)Eval("FirstName"), (string)Eval("LastName")) %></div>
                                            <div class="lb-name">
                                                <span>
                                                    <%# HttpUtility.HtmlEncode((string)Eval("FirstName") + " " + (string)Eval("LastName")) %>
                                                    <asp:Literal ID="litYou" runat="server" Visible="false"> <span class="badge badge-primary">You</span></asp:Literal>
                                                </span>
                                                <span class="lb-title"><%# binary.Core.BLL.LearnerTitles.For((int)Eval("TotalXP")).Html %></span>
                                            </div>
                                        </div>
                                    </td>
                                    <td style="font-weight:800;"><%# Eval("TotalXP") %> XP</td>
                                </tr>
                            </ItemTemplate>
                        </asp:Repeater>
                    </tbody>
                </table>
                <asp:Panel ID="pnlEmpty" runat="server" Visible="false" style="padding:var(--space-8);text-align:center;color:var(--text-muted);">
                    No learners have earned XP yet — be the first!
                </asp:Panel>
            </div>
        </div>
    </section>

    <style>
        .leaderboard-table { width:100%;border-collapse:collapse;font-size:14.5px; }
        .leaderboard-table th { text-align:left;padding:var(--space-3) var(--space-4);font-size:12px;font-weight:700;text-transform:uppercase;letter-spacing:0.6px;color:var(--text-muted);border-bottom:1px solid var(--border-light);background:var(--bg-overlay); }
        .leaderboard-table td { padding:var(--space-3) var(--space-4);border-bottom:1px solid var(--border-light);vertical-align:middle; }
        .leaderboard-table tr:last-child td { border-bottom:none; }
        .leaderboard-row.is-you { background:var(--brand-primary-soft); }
        .rank-badge { font-weight:800;color:var(--text-muted); }
        .tbl-user { display:flex;align-items:center;gap:var(--space-3);font-weight:600; }
        .lb-name { display:flex;flex-direction:column;line-height:1.3; }
        .lb-title { font-size:12px;font-weight:600;color:var(--text-muted); }
        .tbl-avatar { width:32px;height:32px;border-radius:50%;display:inline-grid;place-items:center;color:#fff;font-size:11px;font-weight:800;flex-shrink:0; }
    </style>

</asp:Content>
