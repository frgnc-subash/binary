<%@ Page Title="Home" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Default.aspx.cs" Inherits="binary._Default" %>

<asp:Content ID="BodyContent" ContentPlaceHolderID="MainContent" runat="server">

    <%-- ── Hero ── --%>
    <section class="home-hero">
        <div class="site-container home-hero-inner">
            <div class="page-hero-badge">&#127760; The smarter way to learn a language</div>
            <h1>Master Any Language<br /><span class="gradient-text">Faster Than Ever</span></h1>
            <p class="lead">Binary combines bite-sized lessons, spaced repetition, and real conversation practice to get you fluent — faster. Start free, no credit card required.</p>
            <div class="page-hero-actions">
                <a class="btn btn-primary btn-xl" runat="server" href="~/Auth/Register.aspx">Start for Free &rarr;</a>
                <a class="btn btn-outline btn-lg" runat="server" href="~/Courses">Explore Courses</a>
            </div>
            <div class="home-hero-stats">
                <div class="stat-pill"><strong>50+</strong> Languages</div>
                <div class="stat-pill"><strong>2M+</strong> Learners</div>
                <div class="stat-pill"><strong>95%</strong> Completion Rate</div>
                <div class="stat-pill"><strong>Free</strong> to Start</div>
            </div>
        </div>
    </section>

    <%-- ── Language Picker Strip ── --%>
    <section class="section-sm lang-strip-section">
        <div class="site-container">
            <p class="lang-strip-label">Popular languages to learn right now</p>
            <div class="lang-strip">
                <a class="lang-chip" runat="server" href="~/Courses">&#127480;&#127477; Spanish</a>
                <a class="lang-chip" runat="server" href="~/Courses">&#127467;&#127479; French</a>
                <a class="lang-chip" runat="server" href="~/Courses">&#127465;&#127466; German</a>
                <a class="lang-chip" runat="server" href="~/Courses">&#127471;&#127477; Japanese</a>
                <a class="lang-chip" runat="server" href="~/Courses">&#127464;&#127475; Chinese</a>
                <a class="lang-chip" runat="server" href="~/Courses">&#127472;&#127479; Korean</a>
                <a class="lang-chip" runat="server" href="~/Courses">&#127470;&#127481; Italian</a>
                <a class="lang-chip" runat="server" href="~/Courses">&#127463;&#127479; Portuguese</a>
                <a class="lang-chip lang-chip-more" runat="server" href="~/Courses">+42 more</a>
            </div>
        </div>
    </section>

    <%-- ── How It Works ── --%>
    <section class="section">
        <div class="site-container">
            <div class="section-header">
                <div class="eyebrow">&#9997;&#65039; How It Works</div>
                <h2>Learn in Three Simple Steps</h2>
                <p>No overwhelm. Just a clear, structured path from beginner to confident speaker.</p>
                <div class="gradient-divider"></div>
            </div>
            <div class="grid-3 how-steps">
                <div class="how-step card">
                    <div class="card-body">
                        <div class="how-step-num">01</div>
                        <h3>Pick Your Language</h3>
                        <p>Choose from 50+ languages. We'll place you at the right level with a quick assessment.</p>
                    </div>
                </div>
                <div class="how-step card how-step-highlight">
                    <div class="card-body">
                        <div class="how-step-num">02</div>
                        <h3>Follow Your Path</h3>
                        <p>Work through interactive lessons — vocabulary, grammar, listening, and speaking — at your own pace.</p>
                    </div>
                </div>
                <div class="how-step card">
                    <div class="card-body">
                        <div class="how-step-num">03</div>
                        <h3>Track Progress</h3>
                        <p>Watch your streak grow and see your fluency score rise as you complete exercises every day.</p>
                    </div>
                </div>
            </div>
        </div>
    </section>

    <%-- ── Features ── --%>
    <section class="section features-section">
        <div class="site-container">
            <div class="section-header">
                <div class="eyebrow">&#10024; Features</div>
                <h2>Everything You Need to Succeed</h2>
                <p>Built around the science of language acquisition — not guesswork.</p>
                <div class="gradient-divider"></div>
            </div>
            <div class="grid-4">
                <div class="feature-card card">
                    <div class="card-body">
                        <div class="feature-icon">&#128218;</div>
                        <h4>Structured Curriculum</h4>
                        <p>Expert-designed courses with clear milestones from A1 to C2.</p>
                    </div>
                </div>
                <div class="feature-card card">
                    <div class="card-body">
                        <div class="feature-icon">&#129504;</div>
                        <h4>Spaced Repetition</h4>
                        <p>Our smart flashcard system surfaces words right when you need a reminder.</p>
                    </div>
                </div>
                <div class="feature-card card">
                    <div class="card-body">
                        <div class="feature-icon">&#127908;</div>
                        <h4>Speaking Practice</h4>
                        <p>AI-powered pronunciation feedback so you sound like a native speaker.</p>
                    </div>
                </div>
                <div class="feature-card card">
                    <div class="card-body">
                        <div class="feature-icon">&#128202;</div>
                        <h4>Progress Analytics</h4>
                        <p>Detailed dashboards showing your streak, XP, and skill breakdown.</p>
                    </div>
                </div>
                <div class="feature-card card">
                    <div class="card-body">
                        <div class="feature-icon">&#127775;</div>
                        <h4>Daily Challenges</h4>
                        <p>Short, daily exercises designed to keep you motivated and consistent.</p>
                    </div>
                </div>
                <div class="feature-card card">
                    <div class="card-body">
                        <div class="feature-icon">&#128101;</div>
                        <h4>Community</h4>
                        <p>Practice with a global community of learners at your level.</p>
                    </div>
                </div>
                <div class="feature-card card">
                    <div class="card-body">
                        <div class="feature-icon">&#127942;</div>
                        <h4>Certificates</h4>
                        <p>Earn shareable certificates as you complete each proficiency level.</p>
                    </div>
                </div>
                <div class="feature-card card">
                    <div class="card-body">
                        <div class="feature-icon">&#128241;</div>
                        <h4>Learn Anywhere</h4>
                        <p>Fully responsive — pick up right where you left off on any device.</p>
                    </div>
                </div>
            </div>
        </div>
    </section>

    <%-- ── Popular Courses ── --%>
    <section class="section">
        <div class="site-container">
            <div class="section-header">
                <div class="eyebrow">&#128218; Popular Courses</div>
                <h2>Start with a Top Course</h2>
                <p>Hand-curated by our language experts. Thousands of learners can't be wrong.</p>
                <div class="gradient-divider"></div>
            </div>
            <div class="grid-3">
                <div class="course-card card">
                    <div class="course-card-banner course-banner-es"></div>
                    <div class="card-body">
                        <div style="display:flex;align-items:center;justify-content:space-between;margin-bottom:12px;">
                            <span class="badge badge-primary">Beginner</span>
                            <span class="course-flag">&#127480;&#127477;</span>
                        </div>
                        <h3 class="course-title">Spanish for Beginners</h3>
                        <p class="course-desc">Master the fundamentals of Spanish — pronunciation, core vocabulary, and everyday conversation.</p>
                        <div class="course-meta">
                            <span>&#9733; 4.9</span>
                            <span>&#128100; 84k learners</span>
                            <span>&#128336; 40 lessons</span>
                        </div>
                        <div class="progress" style="margin-top:16px;" title="0% complete">
                            <div class="progress-bar" style="width:0%"></div>
                        </div>
                    </div>
                    <div class="card-footer">
                        <a class="btn btn-primary" style="width:100%;" runat="server" href="~/Courses">Start Course</a>
                    </div>
                </div>
                <div class="course-card card">
                    <div class="course-card-banner course-banner-fr"></div>
                    <div class="card-body">
                        <div style="display:flex;align-items:center;justify-content:space-between;margin-bottom:12px;">
                            <span class="badge badge-warning">Intermediate</span>
                            <span class="course-flag">&#127467;&#127479;</span>
                        </div>
                        <h3 class="course-title">French Immersion</h3>
                        <p class="course-desc">Dive into French culture, grammar, and conversation with rich audio and video content.</p>
                        <div class="course-meta">
                            <span>&#9733; 4.8</span>
                            <span>&#128100; 62k learners</span>
                            <span>&#128336; 55 lessons</span>
                        </div>
                        <div class="progress" style="margin-top:16px;" title="0% complete">
                            <div class="progress-bar" style="width:0%"></div>
                        </div>
                    </div>
                    <div class="card-footer">
                        <a class="btn btn-primary" style="width:100%;" runat="server" href="~/Courses">Start Course</a>
                    </div>
                </div>
                <div class="course-card card">
                    <div class="course-card-banner course-banner-jp"></div>
                    <div class="card-body">
                        <div style="display:flex;align-items:center;justify-content:space-between;margin-bottom:12px;">
                            <span class="badge badge-success">All Levels</span>
                            <span class="course-flag">&#127471;&#127477;</span>
                        </div>
                        <h3 class="course-title">Japanese: Zero to N3</h3>
                        <p class="course-desc">Complete Japanese track covering hiragana, katakana, kanji, and JLPT N3 grammar.</p>
                        <div class="course-meta">
                            <span>&#9733; 4.9</span>
                            <span>&#128100; 48k learners</span>
                            <span>&#128336; 80 lessons</span>
                        </div>
                        <div class="progress" style="margin-top:16px;" title="0% complete">
                            <div class="progress-bar" style="width:0%"></div>
                        </div>
                    </div>
                    <div class="card-footer">
                        <a class="btn btn-primary" style="width:100%;" runat="server" href="~/Courses">Start Course</a>
                    </div>
                </div>
            </div>
            <div style="text-align:center;margin-top:40px;">
                <a class="btn btn-outline btn-lg" runat="server" href="~/Courses">View All Courses &rarr;</a>
            </div>
        </div>
    </section>

    <%-- ── CTA Strip ── --%>
    <section class="cta-strip">
        <div class="site-container cta-strip-inner">
            <div class="cta-strip-text">
                <h2>Ready to start speaking?</h2>
                <p>Join over 2 million learners. Free forever. No credit card needed.</p>
            </div>
            <div class="page-hero-actions">
                <a class="btn btn-primary btn-xl" runat="server" href="~/Auth/Register.aspx">Create Free Account</a>
                <a class="btn btn-ghost btn-lg cta-ghost-btn" runat="server" href="~/Courses">Browse Courses</a>
            </div>
        </div>
    </section>

    <style>
        /* Home-specific styles */
        .home-hero {
            background: linear-gradient(160deg, hsl(230, 30%, 98%) 0%, hsl(246, 40%, 96%) 60%, hsl(246, 60%, 94%) 100%);
            padding: var(--space-24) 0 var(--space-20);
            text-align: center;
            position: relative;
            overflow: hidden;
        }

        .home-hero::before {
            content: '';
            position: absolute;
            inset: 0;
            background: radial-gradient(ellipse 80% 60% at 50% 0%, hsla(246, 80%, 60%, 0.12), transparent 70%);
            pointer-events: none;
        }

        .home-hero h1 {
            font-size: clamp(2.8rem, 6vw, 4.5rem);
            letter-spacing: -2px;
            margin-bottom: var(--space-5);
        }

        .home-hero-stats {
            display: flex;
            align-items: center;
            justify-content: center;
            gap: var(--space-3);
            flex-wrap: wrap;
            margin-top: var(--space-8);
        }

        /* Lang Strip */
        .lang-strip-section {
            border-top: 1px solid var(--border-light);
            border-bottom: 1px solid var(--border-light);
            background: var(--surface-base);
        }

        .lang-strip-label {
            text-align: center;
            font-size: 13px;
            font-weight: 600;
            color: var(--text-muted);
            text-transform: uppercase;
            letter-spacing: 0.8px;
            margin-bottom: var(--space-4);
        }

        .lang-strip {
            display: flex;
            align-items: center;
            justify-content: center;
            flex-wrap: wrap;
            gap: var(--space-2);
        }

        .lang-chip {
            display: inline-flex;
            align-items: center;
            gap: 6px;
            padding: 8px 18px;
            border-radius: var(--radius-pill);
            background: var(--surface-overlay);
            border: 1px solid var(--border-light);
            font-size: 14px;
            font-weight: 600;
            color: var(--text-secondary);
            transition: all var(--dur-fast) var(--ease);
        }

        .lang-chip:hover {
            background: hsla(246, 80%, 60%, 0.1);
            border-color: var(--brand-primary);
            color: var(--brand-primary);
            transform: translateY(-2px);
        }

        .lang-chip-more {
            background: linear-gradient(135deg, var(--brand-primary), var(--brand-primary-dark));
            color: #fff;
            border-color: transparent;
        }

        .lang-chip-more:hover {
            color: #fff;
            filter: brightness(1.1);
        }

        /* How Steps */
        .how-step .card-body { padding: var(--space-8); }

        .how-step-num {
            font-size: 2.5rem;
            font-weight: 900;
            color: var(--border-mid);
            line-height: 1;
            margin-bottom: var(--space-4);
            font-family: 'Plus Jakarta Sans', sans-serif;
        }

        .how-step h3 {
            font-size: 1.15rem;
            margin-bottom: var(--space-3);
        }

        .how-step p { color: var(--text-secondary); font-size: 15px; }

        .how-step-highlight {
            border-color: var(--brand-primary);
            box-shadow: 0 0 0 1px var(--brand-primary), var(--shadow-md);
        }

        .how-step-highlight .how-step-num {
            background: linear-gradient(135deg, var(--brand-primary), hsl(280, 80%, 60%));
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            background-clip: text;
        }

        /* Features */
        .features-section { background: var(--surface-overlay); }
        .feature-icon { font-size: 2rem; margin-bottom: var(--space-4); }
        .feature-card h4 { font-size: 1rem; margin-bottom: var(--space-2); }
        .feature-card p { font-size: 14px; color: var(--text-secondary); line-height: 1.6; }

        /* Course Cards */
        .course-card-banner {
            height: 140px;
            border-radius: 0;
        }

        .course-banner-es { background: linear-gradient(135deg, hsl(14, 90%, 60%), hsl(46, 90%, 55%)); }
        .course-banner-fr { background: linear-gradient(135deg, hsl(220, 80%, 55%), hsl(280, 70%, 60%)); }
        .course-banner-jp { background: linear-gradient(135deg, hsl(0, 80%, 60%), hsl(320, 70%, 55%)); }

        .course-flag { font-size: 1.8rem; }
        .course-title { font-size: 1.1rem; margin-bottom: var(--space-2); }
        .course-desc { font-size: 14px; color: var(--text-secondary); line-height: 1.6; margin-bottom: var(--space-4); }

        .course-meta {
            display: flex;
            gap: var(--space-4);
            font-size: 13px;
            color: var(--text-muted);
            font-weight: 500;
        }

        /* CTA Strip */
        .cta-strip {
            background: linear-gradient(135deg, var(--brand-primary-dark), hsl(280, 80%, 48%));
            padding: var(--space-16) 0;
            color: #fff;
        }

        .cta-strip-inner {
            display: flex;
            align-items: center;
            justify-content: space-between;
            gap: var(--space-8);
            flex-wrap: wrap;
        }

        .cta-strip-text h2 {
            font-size: clamp(1.5rem, 3vw, 2rem);
            letter-spacing: -0.5px;
            margin-bottom: var(--space-2);
            color: #fff;
        }

        .cta-strip-text p { color: hsla(0,0%,100%,0.78); font-size: 16px; }

        .cta-ghost-btn { color: hsla(0,0%,100%,0.85) !important; }
        .cta-ghost-btn:hover { background: hsla(0,0%,100%,0.12) !important; color: #fff !important; }
    </style>

</asp:Content>
