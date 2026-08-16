<%@ Page Title="Home" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Default.aspx.cs" Inherits="binary._Default" %>

<asp:Content ID="BodyContent" ContentPlaceHolderID="MainContent" runat="server">

    <%-- hero section --%>
    <section class="section-sm hero-clean-section">
        <div class="site-container">
            <div class="hero-clean-grid">

                <%-- left column: value prop & cta --%>
                <div class="hero-clean-text">
                    <div class="hero-badge">
                        <span class="hero-badge-dot"></span>
                        <span>Language Learning Reimagined</span>
                    </div>
                    <h1 class="hero-clean-title">
                        Master real conversational fluency, one step at a time.
                    </h1>
                    <p class="hero-clean-lead">
                        Structured lessons, contextual vocabulary drills, and practical pronunciation practice designed for steady, lasting progress.
                    </p>
                    <div class="hero-clean-actions">
                        <a class="btn btn-primary btn-lg" runat="server" href="~/Auth/Register.aspx">Start Learning Free</a>
                        <a class="btn btn-outline btn-lg" runat="server" href="~/Courses">Explore Courses</a>
                    </div>
                    <div class="hero-clean-stats">
                        <div class="stat-clean-item">
                            <span class="stat-clean-num">50+</span>
                            <span class="stat-clean-label">Structured Courses</span>
                        </div>
                        <div class="stat-divider"></div>
                        <div class="stat-clean-item">
                            <span class="stat-clean-num">15 min</span>
                            <span class="stat-clean-label">Daily Study Rhythm</span>
                        </div>
                        <div class="stat-divider"></div>
                        <div class="stat-clean-item">
                            <span class="stat-clean-num">100%</span>
                            <span class="stat-clean-label">Free Access</span>
                        </div>
                    </div>
                </div>

                <%-- right column: interactive preview card --%>
                <div class="hero-preview-card card">
                    <div class="card-header" style="display:flex;justify-content:space-between;align-items:center;">
                        <div style="display:flex;align-items:center;gap:8px;">
                            <span class="badge badge-primary">Spanish &bull; Lesson 3</span>
                        </div>
                        <span style="font-size:12px;font-weight:700;color:var(--text-muted);">Vocabulary Focus</span>
                    </div>
                    <div class="card-body" style="padding:var(--space-6);">
                        <div class="vocab-card">
                            <div class="vocab-word">¿Cómo te llamas?</div>
                            <div class="vocab-phonetic">/ˈko.mo te ˈʝa.mas/</div>
                            <div class="vocab-translation">"What is your name?"</div>
                        </div>

                        <div class="practice-choice-list">
                            <div class="choice-item choice-selected">
                                <span class="choice-radio active"></span>
                                <span>My name is... (Me llamo...)</span>
                            </div>
                            <div class="choice-item">
                                <span class="choice-radio"></span>
                                <span>Where are you from? (¿De dónde eres?)</span>
                            </div>
                        </div>

                        <div style="display:flex;justify-content:space-between;align-items:center;margin-top:var(--space-5);">
                            <div style="flex:1;margin-right:var(--space-4);">
                                <div style="display:flex;justify-content:space-between;font-size:12px;font-weight:600;color:var(--text-muted);margin-bottom:4px;">
                                    <span>Lesson Progress</span>
                                    <span>60%</span>
                                </div>
                                <div class="progress"><div class="progress-bar" style="width:60%;"></div></div>
                            </div>
                            <span class="badge badge-success">Correct</span>
                        </div>
                    </div>
                </div>

            </div>
        </div>
    </section>

    <%-- language tracks bar --%>
    <section style="background:#ffffff;border-top:1px solid var(--border-light);border-bottom:1px solid var(--border-light);padding:var(--space-6) 0;">
        <div class="site-container">
            <div class="clean-lang-strip">
                <a class="clean-lang-chip" runat="server" href="~/Courses">
                    <span class="lang-chip-name">Spanish</span>
                    <span class="lang-chip-level">A1 &ndash; B2</span>
                </a>
                <a class="clean-lang-chip" runat="server" href="~/Courses">
                    <span class="lang-chip-name">French</span>
                    <span class="lang-chip-level">A1 &ndash; B2</span>
                </a>
                <a class="clean-lang-chip" runat="server" href="~/Courses">
                    <span class="lang-chip-name">Japanese</span>
                    <span class="lang-chip-level">N5 &ndash; N3</span>
                </a>
                <a class="clean-lang-chip" runat="server" href="~/Courses">
                    <span class="lang-chip-name">German</span>
                    <span class="lang-chip-level">A1 &ndash; B1</span>
                </a>
                <a class="clean-lang-chip" runat="server" href="~/Courses">
                    <span class="lang-chip-name">Korean</span>
                    <span class="lang-chip-level">Beginner</span>
                </a>
                <a class="clean-lang-chip" runat="server" href="~/Courses">
                    <span class="lang-chip-name">Italian</span>
                    <span class="lang-chip-level">A1 &ndash; B1</span>
                </a>
            </div>
        </div>
    </section>

    <%-- learning pillars --%>
    <section class="section">
        <div class="site-container">
            <div style="text-align:center;max-width:580px;margin:0 auto var(--space-10);">
                <span class="badge badge-primary" style="margin-bottom:var(--space-2);">Learning Methodology</span>
                <h2 style="font-size:2rem;margin-bottom:var(--space-2);">Designed for Natural Retention</h2>
                <p style="color:var(--text-secondary);font-size:15px;">A structured curriculum that balances listening, reading, speaking, and quiz validation.</p>
            </div>

            <div class="grid-3">
                <div class="card card-body clean-feature-card">
                    <div class="clean-icon-wrap">
                        <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><polygon points="12 2 2 7 12 12 22 7 12 2"></polygon><polyline points="2 17 12 22 22 17"></polyline><polyline points="2 12 12 17 22 12"></polyline></svg>
                    </div>
                    <h3>Bite-Sized Modules</h3>
                    <p>Short, 10-15 minute interactive modules that seamlessly fit into your daily routine without burnout.</p>
                </div>
                <div class="card card-body clean-feature-card">
                    <div class="clean-icon-wrap">
                        <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><circle cx="12" cy="12" r="10"></circle><polyline points="12 6 12 12 16 14"></polyline></svg>
                    </div>
                    <h3>Spaced Repetition</h3>
                    <p>Review difficult vocabulary at optimal intervals to convert short-term memory into long-term recall.</p>
                </div>
                <div class="card card-body clean-feature-card">
                    <div class="clean-icon-wrap">
                        <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M22 11.08V12a10 10 0 1 1-5.93-9.14"></path><polyline points="22 4 12 14.01 9 11.01"></polyline></svg>
                    </div>
                    <h3>Immediate Feedback</h3>
                    <p>Validate your understanding after every lesson with automated grading and detailed explanations.</p>
                </div>
            </div>
        </div>
    </section>

    <%-- clean cta banner --%>
    <section class="section-sm" style="background:#ffffff;border-top:1px solid var(--border-light);text-align:center;padding:var(--space-12) 0;">
        <div class="site-container" style="max-width:620px;margin:0 auto;">
            <h2 style="font-size:1.9rem;margin-bottom:var(--space-3);">Start your learning journey today</h2>
            <p style="color:var(--text-secondary);font-size:15px;margin-bottom:var(--space-6);">Create your free account in 30 seconds and start practicing immediately.</p>
            <a class="btn btn-primary btn-lg" runat="server" href="~/Auth/Register.aspx">Create Free Account</a>
        </div>
    </section>

    <style>
        .hero-clean-section { padding: var(--space-12) 0; }
        .hero-clean-grid { display: grid; grid-template-columns: 1.1fr 0.9fr; gap: var(--space-10); align-items: center; }
        .hero-badge { display: inline-flex; align-items: center; gap: 8px; padding: 4px 12px; border-radius: var(--radius-pill); background: var(--brand-primary-soft); color: var(--brand-primary); font-size: 13px; font-weight: 700; margin-bottom: var(--space-4); }
        .hero-badge-dot { width: 6px; height: 6px; border-radius: 50%; background: var(--brand-primary); }
        .hero-clean-title { font-size: clamp(2rem, 3.5vw, 2.8rem); font-weight: 800; letter-spacing: -0.03em; margin-bottom: var(--space-4); color: var(--text-primary); }
        .hero-clean-lead { font-size: 16px; color: var(--text-secondary); line-height: 1.6; margin-bottom: var(--space-6); }
        .hero-clean-actions { display: flex; gap: var(--space-3); flex-wrap: wrap; margin-bottom: var(--space-8); }
        .hero-clean-stats { display: flex; align-items: center; gap: var(--space-5); }
        .stat-clean-item { display: flex; flex-direction: column; }
        .stat-clean-num { font-family: var(--font-heading); font-size: 1.3rem; font-weight: 800; color: var(--text-primary); }
        .stat-clean-label { font-size: 12px; color: var(--text-muted); font-weight: 500; }
        .stat-divider { width: 1px; height: 28px; background: var(--border-light); }
        .hero-preview-card { background: #ffffff; box-shadow: var(--shadow-card); }
        .vocab-card { text-align: center; padding: var(--space-4) var(--space-2); background: var(--bg-subtle); border-radius: var(--radius-md); margin-bottom: var(--space-4); }
        .vocab-word { font-family: var(--font-heading); font-size: 1.4rem; font-weight: 800; color: var(--brand-primary); }
        .vocab-phonetic { font-size: 13px; color: var(--text-muted); margin-top: 2px; }
        .vocab-translation { font-size: 14px; font-weight: 600; color: var(--text-secondary); margin-top: 4px; }
        .practice-choice-list { display: flex; flex-direction: column; gap: var(--space-2); }
        .choice-item { display: flex; align-items: center; gap: 10px; padding: 10px 14px; border-radius: var(--radius-md); border: 1px solid var(--border-light); font-size: 13.5px; font-weight: 600; cursor: pointer; transition: all 0.15s ease; }
        .choice-selected { background: var(--brand-primary-soft); border-color: var(--brand-primary); color: var(--brand-primary); }
        .choice-radio { width: 14px; height: 14px; border-radius: 50%; border: 2px solid var(--border-mid); }
        .choice-radio.active { border-color: var(--brand-primary); background: var(--brand-primary); }
        .clean-lang-strip { display: grid; grid-template-columns: repeat(auto-fit, minmax(140px, 1fr)); gap: var(--space-3); }
        .clean-lang-chip { display: flex; flex-direction: column; padding: 10px 14px; border-radius: var(--radius-md); background: var(--bg-subtle); border: 1px solid transparent; transition: all 0.15s ease; }
        .clean-lang-chip:hover { background: #ffffff; border-color: var(--brand-primary); box-shadow: var(--shadow-subtle); }
        .lang-chip-name { font-weight: 700; font-size: 14px; color: var(--text-primary); }
        .lang-chip-level { font-size: 12px; color: var(--text-muted); font-weight: 500; }
        .clean-feature-card { display: flex; flex-direction: column; gap: var(--space-2); }
        .clean-icon-wrap { width: 42px; height: 42px; border-radius: var(--radius-md); background: var(--brand-primary-soft); color: var(--brand-primary); display: inline-grid; place-items: center; margin-bottom: var(--space-2); }
        .clean-icon-wrap svg { width: 20px; height: 20px; }
        @media (max-width: 860px) { .hero-clean-grid { grid-template-columns: 1fr; } }
    </style>

</asp:Content>
