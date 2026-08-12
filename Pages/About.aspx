<%@ Page Title="About Us" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="About.aspx.cs" Inherits="binary.Pages.About" %>

<asp:Content ID="BodyContent" ContentPlaceHolderID="MainContent" runat="server">

    <section class="page-hero">
        <div class="site-container">
            <div class="page-hero-badge">&#128218; Our Story</div>
            <h1>Built for Language<br /><span class="gradient-text">Learners Everywhere</span></h1>
            <p class="lead">Binary was founded on a simple belief: anyone can learn a new language with the right tools, structure, and motivation.</p>
        </div>
    </section>

    <%-- Mission --%>
    <section class="section-sm">
        <div class="site-container">
            <div class="grid-2 about-mission">
                <div class="about-mission-text">
                    <div class="eyebrow" style="margin-bottom:var(--space-3);">&#127919; Our Mission</div>
                    <h2>Make Language Learning Accessible to Everyone</h2>
                    <p style="color:var(--text-secondary);font-size:17px;line-height:1.8;margin-top:var(--space-4);">
                        We believe language is the key to connection. Our mission is to tear down barriers — cost, complexity, and time — so that anyone, anywhere can learn to speak a new language with confidence.
                    </p>
                    <p style="color:var(--text-secondary);font-size:17px;line-height:1.8;margin-top:var(--space-4);">
                        Every course, exercise, and feature on Binary is designed with one question in mind: <em>does this actually help someone become a better speaker?</em>
                    </p>
                    <div style="margin-top:var(--space-6);">
                        <a class="btn btn-primary btn-lg" runat="server" href="~/Auth/Register.aspx">Join Us Today</a>
                    </div>
                </div>
                <div class="about-stats-grid">
                    <div class="about-stat-card card card-body">
                        <div class="about-stat-num">50+</div>
                        <div class="about-stat-label">Languages Available</div>
                    </div>
                    <div class="about-stat-card card card-body">
                        <div class="about-stat-num">2M+</div>
                        <div class="about-stat-label">Active Learners</div>
                    </div>
                    <div class="about-stat-card card card-body">
                        <div class="about-stat-num">95%</div>
                        <div class="about-stat-label">Course Completion</div>
                    </div>
                    <div class="about-stat-card card card-body">
                        <div class="about-stat-num">4.9★</div>
                        <div class="about-stat-label">Average Rating</div>
                    </div>
                </div>
            </div>
        </div>
    </section>

    <%-- Values --%>
    <section class="section" style="background:var(--surface-overlay);">
        <div class="site-container">
            <div class="section-header">
                <div class="eyebrow">&#10024; Our Values</div>
                <h2>What We Stand For</h2>
                <div class="gradient-divider"></div>
            </div>
            <div class="grid-3">
                <div class="card card-body value-card">
                    <div class="value-icon">&#127760;</div>
                    <h3>Accessibility</h3>
                    <p>Great language education should never be gatekept by price or geography. Binary is free to start, forever.</p>
                </div>
                <div class="card card-body value-card">
                    <div class="value-icon">&#128300;</div>
                    <h3>Science-Backed</h3>
                    <p>Every method we use — spaced repetition, comprehensible input, active recall — is grounded in linguistics research.</p>
                </div>
                <div class="card card-body value-card">
                    <div class="value-icon">&#129309;</div>
                    <h3>Community First</h3>
                    <p>Learning is better together. Our global community connects learners with native speakers and fellow students.</p>
                </div>
            </div>
        </div>
    </section>

    <%-- Timeline --%>
    <section class="section">
        <div class="site-container">
            <div class="section-header">
                <div class="eyebrow">&#128336; Our Journey</div>
                <h2>From Idea to Impact</h2>
                <div class="gradient-divider"></div>
            </div>
            <div class="timeline">
                <div class="timeline-item">
                    <div class="timeline-year">2020</div>
                    <div class="card card-body timeline-card">
                        <h4>Founded</h4>
                        <p>Binary was started by a small team of language enthusiasts frustrated by expensive and ineffective apps.</p>
                    </div>
                </div>
                <div class="timeline-item">
                    <div class="timeline-year">2021</div>
                    <div class="card card-body timeline-card">
                        <h4>First 10 Languages Launched</h4>
                        <p>We expanded from Spanish & French to 10 languages, and reached our first 100,000 learners.</p>
                    </div>
                </div>
                <div class="timeline-item">
                    <div class="timeline-year">2023</div>
                    <div class="card card-body timeline-card">
                        <h4>AI Speaking Coach</h4>
                        <p>Launched our AI-powered pronunciation feedback system — a first for free language platforms.</p>
                    </div>
                </div>
                <div class="timeline-item">
                    <div class="timeline-year">2026</div>
                    <div class="card card-body timeline-card timeline-card-active">
                        <h4>2M Learners & Counting</h4>
                        <p>Today Binary supports 50+ languages and over 2 million learners across 140+ countries.</p>
                    </div>
                </div>
            </div>
        </div>
    </section>

    <style>
        .about-mission { align-items: start; gap: var(--space-16); }
        .about-mission h2 { font-size: 2rem; letter-spacing: -0.5px; margin-top: var(--space-2); }
        .about-stats-grid { display: grid; grid-template-columns: 1fr 1fr; gap: var(--space-4); }
        .about-stat-card { text-align: center; }
        .about-stat-num { font-size: 2.4rem; font-weight: 900; font-family: 'Plus Jakarta Sans', sans-serif; letter-spacing: -1px; background: linear-gradient(135deg, var(--brand-primary), hsl(280, 80%, 60%)); -webkit-background-clip: text; -webkit-text-fill-color: transparent; background-clip: text; }
        .about-stat-label { font-size: 13px; font-weight: 600; color: var(--text-muted); margin-top: var(--space-1); }
        .value-card { text-align: center; padding: var(--space-8); }
        .value-icon { font-size: 2.5rem; margin-bottom: var(--space-4); }
        .value-card h3 { margin-bottom: var(--space-3); }
        .value-card p { color: var(--text-secondary); font-size: 15px; line-height: 1.7; }
        .timeline { display: flex; flex-direction: column; gap: var(--space-4); max-width: 700px; margin: 0 auto; }
        .timeline-item { display: grid; grid-template-columns: 80px 1fr; gap: var(--space-5); align-items: start; }
        .timeline-year { font-size: 1.1rem; font-weight: 800; color: var(--brand-primary); padding-top: var(--space-5); text-align: right; }
        .timeline-card h4 { margin-bottom: var(--space-2); font-size: 1rem; }
        .timeline-card p { color: var(--text-secondary); font-size: 14px; line-height: 1.6; }
        .timeline-card-active { border-color: var(--brand-primary); box-shadow: 0 0 0 1px var(--brand-primary), var(--shadow-md); }
        @media (max-width: 700px) {
            .about-mission { grid-template-columns: 1fr; }
            .timeline-item { grid-template-columns: 60px 1fr; }
        }
    </style>

</asp:Content>
