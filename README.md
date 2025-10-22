# csanicola.github.io

My personal academic website built with Jekyll and hosted on GitHub Pages. This site serves as my professional portfolio, blog, and personal dashboard.

## 🌐 Live Site

Visit the website: [https://csanicola.github.io/](https://csanicola.github.io/)

## 📁 Project Structure

```
csanicola.github.io/
├── .github/workflows/          # GitHub Actions workflows
│   └── update-dashboard.yml    # Auto-updates dashboard every 2 hours
├── _pages/                     # Main website pages
│   └── dashboard.md           # Auto-generated dashboard page
├── scripts/                    # Build and utility scripts
│   └── build-simple-dashboard.sh  # Dashboard generator script
├── glance-config/              # Glance dashboard configuration
│   └── config.yml             # Dashboard feeds and widgets config
├── assets/                     # Static assets (CSS, JS, images)
├── _layouts/                   # Jekyll layout templates
├── _includes/                  # Jekyll include files
├── _posts/                     # Blog posts and articles
├── _site/                      # Built site (generated, do not edit)
└── _config.yml                 # Jekyll configuration
```

## 🚀 Features

### Core Website
- **Professional Portfolio**: Academic background, research, and projects
- **Blog**: Technical writing and personal insights
- **Responsive Design**: Mobile-friendly academic theme
- **Fast Performance**: Optimized static site generation

### Personal Dashboard (`/dashboard/`)
- **Auto-updating**: Refreshes every 2 hours via GitHub Actions
- **Multiple Feeds**:
  - 📰 **News & Tech**: BBC, The Verge, WIRED, TechCrunch, CNET, etc.
  - 🏎️ **Formula 1**: Race schedules, results, and standings
  - ⚽ **Sports**: Manchester United fixtures and NHL scores
  - 🎮 **Twitch**: Followed gaming channels
  - 📺 **YouTube**: Subscribed channels (tech, gaming, K-pop)
  - 💬 **Reddit**: Favorite communities
- **Real-time Data**: RSS feeds and API integrations

## 🛠️ Technology Stack

- **Static Site Generator**: Jekyll 4.4.1
- **Hosting**: GitHub Pages
- **CI/CD**: GitHub Actions
- **Dashboard**: Custom Python/RSS integration
- **Styling**: Sass/CSS with responsive design

## 📊 Dashboard Configuration

The dashboard is configured in `glance-config/config.yml` and includes:

### Content Sources
- **RSS Feeds**: 8+ news and tech sources
- **Sports APIs**: F1, Premier League, NHL
- **Social Platforms**: Twitch, YouTube, Reddit
- **Custom Integrations**: K-pop news, gaming content

### Auto-Update Schedule
- **Frequency**: Every 2 hours
- **Trigger**: GitHub Actions scheduled workflow
- **Process**:
  1. Fetches latest RSS feeds
  2. Calls sports APIs
  3. Generates static HTML
  4. Commits and deploys updates

## 🚀 Deployment

### Automatic Deployment
The site automatically deploys via GitHub Actions:

1. **On push to `main` branch**
2. **Every 2 hours** (dashboard updates)
3. **Manual trigger** via GitHub Actions UI

### Manual Deployment
```bash
# Clone the repository
git clone https://github.com/csanicola/csanicola.github.io.git
cd csanicola.github.io

# Install dependencies
bundle install

# Build locally
bundle exec jekyll build

# Serve locally
bundle exec jekyll serve
```

### GitHub Pages Setup
1. Repository settings → Pages
2. Source: **GitHub Actions**
3. Branch: **gh-pages** (automatically created)
4. Custom domain: (if configured)

## 🔧 Customization

### Adding New Dashboard Feeds
1. Edit `glance-config/config.yml`
2. Add new RSS URLs or API endpoints
3. The changes will appear after the next auto-update

### Modifying Website Content
- **Pages**: Edit files in `_pages/`
- **Posts**: Add Markdown files to `_posts/`
- **Layout**: Modify `_layouts/` and `_includes/`
- **Styling**: Update `assets/css/`

### Local Development
```bash
# Install Ruby dependencies
bundle install

# Run local server
bundle exec jekyll serve

# Build for production
bundle exec jekyll build
```

## 📝 Content Management

### Blog Posts
- Location: `_posts/` directory
- Format: Markdown with YAML front matter
- Naming: `YYYY-MM-DD-title.md`

### Static Pages
- Location: `_pages/` directory
- Navigation: Controlled via `_config.yml`

### Dashboard Updates
- Automatic: Every 2 hours via GitHub Actions
- Manual: Push to `main` branch or trigger workflow
- Logs: Check GitHub Actions tab for build status

## 🔒 Security & Performance

- **HTTPS**: Enabled via GitHub Pages
- **CDN**: Served through GitHub's global CDN
- **Caching**: Browser and CDN caching optimized
- **Dependencies**: Regularly updated via bundle

## 🐛 Troubleshooting

### Common Issues

**Dashboard not updating:**
- Check GitHub Actions workflow runs
- Verify RSS feeds are accessible
- Review workflow logs for errors

**Build failures:**
- Verify Ruby/Jekyll versions match
- Check for syntax errors in Markdown
- Ensure all dependencies are installed

**Local development issues:**
```bash
# Clear Jekyll cache
bundle exec jekyll clean

# Update dependencies
bundle update

# Check Ruby version
ruby -v
```

## 📄 License

This project is open source and available under the [MIT License](LICENSE).

## 🤝 Contributing

While this is a personal website, feedback and suggestions are welcome through issues and pull requests.

## 📞 Contact

- **Website**: [csanicola.github.io](https://csanicola.github.io/)
- **GitHub**: [@csanicola](https://github.com/csanicola)
- **Dashboard**: [csanicola.github.io/dashboard/](https://csanicola.github.io/dashboard/)

---

*Last updated: $(date +%Y-%m-%d)*