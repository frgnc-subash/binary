<%@ Page Title="Feedback" Language="C#" MasterPageFile="~/MasterPages/AdminMaster.master" AutoEventWireup="true" CodeBehind="Feedback.aspx.cs" Inherits="binary.Admin.AdminFeedback" %>

<asp:Content ID="HeaderTitle" ContentPlaceHolderID="AdminHeaderTitle" runat="server">Feedback</asp:Content>
<asp:Content ID="HeaderSubtitle" ContentPlaceHolderID="AdminHeaderSubtitle" runat="server">Messages submitted through the public Contact form.</asp:Content>
<asp:Content ID="HeaderActions" ContentPlaceHolderID="AdminHeaderActions" runat="server">
    <a class="btn btn-outline" runat="server" href="~/Admin"><svg class="ui-icon ui-icon-before" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" aria-hidden="true"><line x1="19" y1="12" x2="5" y2="12"></line><polyline points="12 19 5 12 12 5"></polyline></svg>Dashboard</a>
</asp:Content>

<asp:Content ID="BodyContent" ContentPlaceHolderID="AdminMainContent" runat="server">

    <asp:Panel ID="pnlFeedbackError" runat="server" CssClass="auth-alert auth-alert-error" Visible="false" style="margin-bottom:var(--space-4);">
        <asp:Literal ID="litFeedbackError" runat="server" />
    </asp:Panel>

    <div class="card">
        <div class="card-header"><h3 style="font-size:1.05rem;">All Messages</h3></div>
        <asp:Panel ID="pnlFeedbackList" runat="server">
            <div style="overflow-x:auto;">
                <table class="admin-table">
                    <thead><tr><th>From</th><th>Subject</th><th>Message</th><th>Received</th><th style="text-align:right;">Action</th></tr></thead>
                    <tbody>
                        <asp:Repeater ID="rptFeedback" runat="server" OnItemCommand="rptFeedback_ItemCommand">
                            <ItemTemplate>
                                <tr>
                                    <td>
                                        <div style="font-weight:700;color:var(--text-primary);"><%# HttpUtility.HtmlEncode((string)Eval("Name")) %></div>
                                        <div style="font-size:12px;color:var(--text-muted);"><%# HttpUtility.HtmlEncode((string)Eval("Email")) %></div>
                                    </td>
                                    <td><%# HttpUtility.HtmlEncode((string)Eval("Subject")) %></td>
                                    <td style="max-width:360px;color:var(--text-secondary);"><%# HttpUtility.HtmlEncode(Truncate((string)Eval("Message"), 140)) %></td>
                                    <td style="color:var(--text-muted);white-space:nowrap;"><%# Eval("SubmittedDate", "{0:MMM d, yyyy}") %></td>
                                    <td style="text-align:right;">
                                        <asp:LinkButton runat="server" CssClass="btn btn-ghost text-danger" style="height:30px;font-size:12px;padding:0 10px;" CommandName="DeleteFeedback" CommandArgument='<%# Eval("FeedbackID") %>' OnClientClick="return confirm('Delete this message? This cannot be undone.');">Delete</asp:LinkButton>
                                    </td>
                                </tr>
                            </ItemTemplate>
                        </asp:Repeater>
                    </tbody>
                </table>
            </div>
        </asp:Panel>
        <asp:Panel ID="pnlNoFeedback" runat="server" Visible="false" style="text-align:center;color:var(--text-muted);padding:var(--space-8) var(--space-4);">
            <div style="width:44px;height:44px;margin:0 auto var(--space-3);border-radius:50%;background:rgba(67,56,202,0.1);color:var(--brand-primary);display:grid;place-items:center;"><svg class="admin-icon" style="width:22px;height:22px;" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.75" stroke-linecap="round" stroke-linejoin="round"><polyline points="22 12 16 12 14 15 10 15 8 12 2 12"></polyline><path d="M5.45 5.11 2 12v6a2 2 0 0 0 2 2h16a2 2 0 0 0 2-2v-6l-3.45-6.89A2 2 0 0 0 16.76 4H7.24a2 2 0 0 0-1.79 1.11Z"></path></svg></div>
            <h4 style="font-weight:700;color:var(--text-primary);">No messages yet</h4>
            <p style="font-size:13.5px;">Submissions from the Contact page will show up here.</p>
        </asp:Panel>
    </div>

</asp:Content>
