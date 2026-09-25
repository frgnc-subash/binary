<%@ Page Title="Lesson Quiz" Language="C#" MasterPageFile="~/MasterPages/AdminMaster.master" AutoEventWireup="true" CodeBehind="LessonQuiz.aspx.cs" Inherits="binary.Admin.AdminLessonQuiz" %>

<asp:Content ID="HeaderTitle" ContentPlaceHolderID="AdminHeaderTitle" runat="server">Lesson Quiz</asp:Content>
<asp:Content ID="HeaderSubtitle" ContentPlaceHolderID="AdminHeaderSubtitle" runat="server"><asp:Literal ID="litSubtitle" runat="server" /></asp:Content>
<asp:Content ID="HeaderActions" ContentPlaceHolderID="AdminHeaderActions" runat="server">
    <a class="btn btn-outline" id="lnkBack" runat="server"><svg class="ui-icon ui-icon-before" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" aria-hidden="true"><line x1="19" y1="12" x2="5" y2="12"></line><polyline points="12 19 5 12 12 5"></polyline></svg>Back to lessons</a>
</asp:Content>

<asp:Content ID="BodyContent" ContentPlaceHolderID="AdminMainContent" runat="server">

    <asp:Panel ID="pnlActionSuccess" runat="server" CssClass="auth-alert auth-alert-success" Visible="false">
        <asp:Literal ID="litActionSuccess" runat="server" />
    </asp:Panel>
    <asp:Panel ID="pnlError" runat="server" CssClass="auth-alert auth-alert-error" Visible="false" style="margin-bottom:var(--space-4);">
        <asp:Literal ID="litError" runat="server" />
    </asp:Panel>

    <%-- no quiz yet: create one --%>
    <asp:Panel ID="pnlNoQuiz" runat="server" Visible="false" CssClass="card lq-start">
        <div class="card-body">
            <h3>This lesson has no quiz yet</h3>
            <p>Learners take it after studying the lesson, and earn XP for every correct answer. Give it a title, then add questions.</p>
            <asp:Panel ID="pnlCreate" runat="server" CssClass="lq-inline-form" DefaultButton="btnCreateQuiz">
                <asp:TextBox ID="txtNewTitle" runat="server" CssClass="form-control" MaxLength="200" aria-label="Quiz title" />
                <asp:Button ID="btnCreateQuiz" runat="server" CssClass="btn btn-primary" Text="Create quiz" OnClick="btnCreateQuiz_Click" />
            </asp:Panel>
        </div>
    </asp:Panel>

    <asp:Panel ID="pnlQuiz" runat="server" Visible="false">
        <div class="lq-grid">

            <%-- questions --%>
            <div class="card">
                <div class="card-header lq-card-head">
                    <h3 style="font-size:1.05rem;">Questions</h3>
                    <span class="category-count"><asp:Literal ID="litQuestionCount" runat="server" /></span>
                </div>
                <ol class="lq-list">
                    <asp:Repeater ID="rptQuestions" runat="server" OnItemCommand="rptQuestions_ItemCommand">
                        <ItemTemplate>
                            <li class='<%# (int)Eval("QuestionID") == EditingQuestionId ? "lq-item is-editing" : "lq-item" %>'>
                                <div class="lq-item-head">
                                    <span class="lq-num"><%# Container.ItemIndex + 1 %></span>
                                    <p class="lq-question"><%# HttpUtility.HtmlEncode((string)Eval("QuestionText")) %></p>
                                    <div class="lq-actions">
                                        <asp:LinkButton runat="server" CssClass="icon-btn" CommandName="EditQuestion" CommandArgument='<%# Eval("QuestionID") %>' ToolTip="Edit question" aria-label="Edit question"><svg class="ui-icon" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" aria-hidden="true"><path d="M12 20h9"/><path d="M16.5 3.5a2.12 2.12 0 0 1 3 3L7 19l-4 1 1-4Z"/></svg></asp:LinkButton>
                                        <asp:LinkButton runat="server" CssClass="icon-btn icon-btn-danger" CommandName="DeleteQuestion" CommandArgument='<%# Eval("QuestionID") %>' ToolTip="Delete question" aria-label="Delete question" OnClientClick="return BinaryUI.confirm(this, { title: 'Delete this question?', text: 'It is removed from the quiz straight away. This cannot be undone.', ok: 'Delete question' });"><svg class="ui-icon" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" aria-hidden="true"><polyline points="3 6 5 6 21 6"/><path d="M19 6l-1 14a2 2 0 0 1-2 2H8a2 2 0 0 1-2-2L5 6"/><path d="M10 11v6"/><path d="M14 11v6"/><path d="M9 6V4a1 1 0 0 1 1-1h4a1 1 0 0 1 1 1v2"/></svg></asp:LinkButton>
                                    </div>
                                </div>
                                <ul class="lq-options">
                                    <asp:Repeater runat="server" DataSource='<%# Eval("Options") %>'>
                                        <ItemTemplate>
                                            <li class='<%# (bool)Eval("IsCorrect") ? "is-correct" : "" %>'>
                                                <%# (bool)Eval("IsCorrect") ? binary.Core.Helpers.Icons.Svg("check") : "<span class=\"lq-dot\"></span>" %>
                                                <%# HttpUtility.HtmlEncode((string)Eval("OptionText")) %>
                                            </li>
                                        </ItemTemplate>
                                    </asp:Repeater>
                                </ul>
                            </li>
                        </ItemTemplate>
                    </asp:Repeater>
                </ol>
                <asp:Panel ID="pnlNoQuestions" runat="server" Visible="false" CssClass="category-empty">
                    No questions yet. Add the first one with the form on the right.
                </asp:Panel>
            </div>

            <div class="lq-side">
                <%-- add / edit a question --%>
                <asp:Panel ID="pnlEditor" runat="server" CssClass="card" DefaultButton="btnSaveQuestion">
                    <div class="card-header"><h3 style="font-size:1.05rem;"><asp:Literal ID="litEditorTitle" runat="server">Add a question</asp:Literal></h3></div>
                    <div class="card-body">
                        <asp:HiddenField ID="hfQuestionId" runat="server" Value="0" />
                        <div class="form-group">
                            <label class="form-label" for="<%= txtQuestion.ClientID %>">Question</label>
                            <asp:TextBox ID="txtQuestion" runat="server" CssClass="form-control" TextMode="MultiLine" Rows="3" MaxLength="500" placeholder="How do you say &quot;thank you&quot; in Spanish?" />
                        </div>

                        <div class="form-group">
                            <span class="form-label">Answers <small class="lq-label-hint">select the correct one</small></span>
                            <div class="lq-answer">
                                <input type="radio" name="correctOption" value="0" id="correct0" <%= CorrectChecked(0) %> aria-label="Answer A is correct" />
                                <asp:TextBox ID="txtOptionA" runat="server" CssClass="form-control" MaxLength="200" placeholder="Answer A" />
                            </div>
                            <div class="lq-answer">
                                <input type="radio" name="correctOption" value="1" id="correct1" <%= CorrectChecked(1) %> aria-label="Answer B is correct" />
                                <asp:TextBox ID="txtOptionB" runat="server" CssClass="form-control" MaxLength="200" placeholder="Answer B" />
                            </div>
                            <div class="lq-answer">
                                <input type="radio" name="correctOption" value="2" id="correct2" <%= CorrectChecked(2) %> aria-label="Answer C is correct" />
                                <asp:TextBox ID="txtOptionC" runat="server" CssClass="form-control" MaxLength="200" placeholder="Answer C (optional)" />
                            </div>
                            <div class="lq-answer">
                                <input type="radio" name="correctOption" value="3" id="correct3" <%= CorrectChecked(3) %> aria-label="Answer D is correct" />
                                <asp:TextBox ID="txtOptionD" runat="server" CssClass="form-control" MaxLength="200" placeholder="Answer D (optional)" />
                            </div>
                            <p class="form-hint">At least two answers. Learners see them in this order.</p>
                        </div>

                        <div class="lq-editor-actions">
                            <asp:Button ID="btnSaveQuestion" runat="server" CssClass="btn btn-primary" Text="Add question" OnClick="btnSaveQuestion_Click" />
                            <asp:HyperLink ID="lnkCancelEdit" runat="server" CssClass="btn btn-ghost" Visible="false">Cancel</asp:HyperLink>
                        </div>
                    </div>
                </asp:Panel>

                <%-- quiz settings --%>
                <div class="card">
                    <div class="card-header"><h3 style="font-size:1.05rem;">Quiz settings</h3></div>
                    <div class="card-body">
                        <asp:Panel ID="pnlRename" runat="server" CssClass="form-group" DefaultButton="btnRenameQuiz">
                            <label class="form-label" for="<%= txtQuizTitle.ClientID %>">Title</label>
                            <div class="lq-inline-form">
                                <asp:TextBox ID="txtQuizTitle" runat="server" CssClass="form-control" MaxLength="200" />
                                <asp:Button ID="btnRenameQuiz" runat="server" CssClass="btn btn-outline" Text="Save" OnClick="btnRenameQuiz_Click" />
                            </div>
                        </asp:Panel>
                        <div class="lq-danger">
                            <div>
                                <strong>Delete quiz</strong>
                                <span>Removes every question and learners' attempts for it.</span>
                            </div>
                            <asp:Button ID="btnDeleteQuiz" runat="server" CssClass="btn btn-outline text-danger" Text="Delete" OnClick="btnDeleteQuiz_Click" OnClientClick="return BinaryUI.confirm(this, { title: 'Delete this quiz?', text: 'All of its questions and every learner attempt are removed. This cannot be undone.', ok: 'Delete quiz' });" />
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </asp:Panel>

    <script>
        // scroll the editor into view when a question was picked for editing
        (function () {
            var editing = document.querySelector('.lq-item.is-editing');
            var editor = document.getElementById('<%= pnlEditor.ClientID %>');
            if (editing && editor) editor.scrollIntoView({ block: 'start' });
        })();
    </script>

</asp:Content>
