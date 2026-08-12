<%@ Page Title="Contact Us" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Contact.aspx.cs" Inherits="binary.Pages.Contact" %>

<asp:Content ID="BodyContent" ContentPlaceHolderID="MainContent" runat="server">

    <section class="page-hero">
        <div class="site-container">
            <div class="page-hero-badge">&#128140; Get in Touch</div>
            <h1>We'd Love to<br /><span class="gradient-text">Hear from You</span></h1>
            <p class="lead">Have a question, suggestion, or just want to say hello? Our team typically responds within 24 hours.</p>
        </div>
    </section>

    <section class="section-sm">
        <div class="site-container">
            <div class="contact-layout">

                <%-- Contact Form --%>
                <div class="card">
                    <div class="card-header">
                        <h2 style="font-size:1.3rem;">Send a Message</h2>
                    </div>
                    <div class="card-body contact-form-body">
                        <div class="grid-2">
                            <div class="form-group">
                                <label class="form-label" for="FirstName">First Name</label>
                                <asp:TextBox ID="FirstName" runat="server" CssClass="form-control" placeholder="Jane" />
                                <asp:RequiredFieldValidator ID="rfvFirstName" runat="server" ControlToValidate="FirstName" CssClass="field-error" ErrorMessage="First name is required." Display="Dynamic" />
                            </div>
                            <div class="form-group">
                                <label class="form-label" for="LastName">Last Name</label>
                                <asp:TextBox ID="LastName" runat="server" CssClass="form-control" placeholder="Doe" />
                            </div>
                        </div>
                        <div class="form-group">
                            <label class="form-label" for="Email">Email Address</label>
                            <asp:TextBox ID="Email" runat="server" CssClass="form-control" TextMode="Email" placeholder="jane@example.com" />
                            <asp:RequiredFieldValidator ID="rfvEmail" runat="server" ControlToValidate="Email" CssClass="field-error" ErrorMessage="Email is required." Display="Dynamic" />
                        </div>
                        <div class="form-group">
                            <label class="form-label" for="Subject">Subject</label>
                            <asp:DropDownList ID="Subject" runat="server" CssClass="form-control">
                                <asp:ListItem Value="">Select a topic...</asp:ListItem>
                                <asp:ListItem Value="general">General Inquiry</asp:ListItem>
                                <asp:ListItem Value="course">Course Question</asp:ListItem>
                                <asp:ListItem Value="account">Account Support</asp:ListItem>
                                <asp:ListItem Value="bug">Report a Bug</asp:ListItem>
                                <asp:ListItem Value="feedback">Feedback</asp:ListItem>
                                <asp:ListItem Value="partnership">Partnership</asp:ListItem>
                            </asp:DropDownList>
                        </div>
                        <div class="form-group">
                            <label class="form-label" for="Message">Message</label>
                            <asp:TextBox ID="Message" runat="server" CssClass="form-control" TextMode="MultiLine" Rows="5" placeholder="Tell us how we can help..." />
                            <asp:RequiredFieldValidator ID="rfvMessage" runat="server" ControlToValidate="Message" CssClass="field-error" ErrorMessage="Message is required." Display="Dynamic" />
                        </div>
                        <asp:Panel ID="SuccessPanel" runat="server" CssClass="contact-success" Visible="false">
                            &#10003; Thank you! We've received your message and will get back to you within 24 hours.
                        </asp:Panel>
                        <asp:Button ID="SubmitBtn" runat="server" CssClass="btn btn-primary btn-lg" Text="Send Message &#x2192;" OnClick="SubmitBtn_Click" style="width:100%;" />
                    </div>
                </div>

                <%-- Info Cards --%>
                <div class="contact-info">
                    <div class="card card-body contact-info-card">
                        <div class="contact-info-icon">&#128231;</div>
                        <h3>Email</h3>
                        <p>hello@binary-learn.com</p>
                        <p style="color:var(--text-muted);font-size:13px;">Responses within 24 hours</p>
                    </div>
                    <div class="card card-body contact-info-card">
                        <div class="contact-info-icon">&#128172;</div>
                        <h3>Community Forum</h3>
                        <p>Ask questions and share tips with fellow learners in our Discord server.</p>
                        <a class="btn btn-outline" style="margin-top:var(--space-3);" href="#">Join Discord</a>
                    </div>
                    <div class="card card-body contact-info-card">
                        <div class="contact-info-icon">&#128218;</div>
                        <h3>Help Center</h3>
                        <p>Browse our knowledge base for instant answers to common questions.</p>
                        <a class="btn btn-outline" style="margin-top:var(--space-3);" href="#">Browse Articles</a>
                    </div>
                </div>
            </div>
        </div>
    </section>

    <style>
        .contact-layout { display: grid; grid-template-columns: 1fr 340px; gap: var(--space-8); align-items: start; }
        .contact-form-body { display: flex; flex-direction: column; gap: 0; }
        .contact-form-body .form-group { margin-bottom: var(--space-5); }
        .field-error { color: hsl(0, 75%, 55%); font-size: 13px; margin-top: var(--space-1); }
        .contact-success { background: hsla(168, 78%, 42%, 0.1); border: 1px solid var(--brand-secondary); color: var(--brand-secondary); border-radius: var(--radius-md); padding: var(--space-4); margin-bottom: var(--space-5); font-weight: 600; font-size: 14px; }
        .contact-info { display: flex; flex-direction: column; gap: var(--space-4); }
        .contact-info-card { text-align: center; }
        .contact-info-icon { font-size: 2rem; margin-bottom: var(--space-3); }
        .contact-info-card h3 { font-size: 1rem; margin-bottom: var(--space-2); }
        .contact-info-card p { color: var(--text-secondary); font-size: 14px; line-height: 1.6; }
        @media (max-width: 820px) { .contact-layout { grid-template-columns: 1fr; } }
    </style>

</asp:Content>
