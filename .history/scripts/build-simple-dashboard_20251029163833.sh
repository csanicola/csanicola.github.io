#!/bin/bash
set -e

echo "Building comprehensive static dashboard..."

# Create a Python script with all recommended sections
cat > scripts/rss_dashboard.py << 'EOF'
import feedparser
from datetime import datetime
import time

def fetch_rss_feed(url, max_items=5):
    try:
        feed = feedparser.parse(url)
        items = []
        for entry in feed.entries[:max_items]:
            # Clean up the title and get date
            title = entry.title[:120] + "..." if len(entry.title) > 120 else entry.title
            published = entry.get('published', entry.get('updated', 'Recent'))
            # Format date nicely
            if published != 'Recent':
                try:
                    published = datetime.strptime(published[:16], '%a, %d %b %Y').strftime('%b %d')
                except:
                    try:
                        published = datetime.strptime(published[:10], '%Y-%m-%d').strftime('%b %d')
                    except:
                        published = published[:10]
            
            items.append({
                'title': title,
                'link': entry.link,
                'published': published
            })
        return items
    except Exception as e:
        return [{'title': f'📡 Feed temporarily unavailable', 'link': '#', 'published': 'Now'}]

# Generate the dashboard content
print('''---
layout: page
title: Dashboard
permalink: /dashboard/
nav: true
---

<div class="dashboard-container">
  <h1>📊 Personal Dashboard</h1>
  <p><strong>Last updated:</strong>''', datetime.now().strftime("%Y-%m-%d %H:%M"), '''</p>
  <p class="subtitle">Refreshed every 4 hours • All times local</p>
  
  <div class="dashboard-grid">
''')

# TECH & GAMING SECTION
print('''    <div class="dashboard-section">
      <h2>🖥️ Tech & Gaming</h2>''')

tech_feeds = [
    ('https://www.theverge.com/rss/index.xml', 'The Verge', '💻'),
    ('https://techcrunch.com/feed/', 'TechCrunch', '🚀'),
    ('https://www.gamespot.com/feeds/mashup', 'GameSpot', '🎮'),
    ('https://www.pcgamer.com/rss/', 'PC Gamer', '🖥️'),
    ('https://kotaku.com/rss', 'Kotaku', '👾'),
]

for url, title, emoji in tech_feeds:
    print(f'<div class="feed-widget">')
    print(f'<h3>{emoji} {title}</h3>')
    items = fetch_rss_feed(url, 4)
    for item in items:
        print(f'<div class="feed-item">')
        print(f'<a href="{item["link"]}" target="_blank" rel="noopener">{item["title"]}</a>')
        print(f'<span class="feed-date">{item["published"]}</span>')
        print(f'</div>')
    print(f'</div>')
    time.sleep(1)

print('''    </div>''')

# PRODUCTIVITY & TOOLS SECTION
print('''    <div class="dashboard-section">
      <h2>📚 Productivity & Tools</h2>''')

productivity_feeds = [
    ('https://obsidian.md/blog/rss.xml', 'Obsidian Blog', '📝'),
    ('https://blog.obsidian.md/rss/', 'Obsidian Updates', '🔄'),
    ('https://www.reddit.com/r/ObsidianMD/.rss', 'r/ObsidianMD', '💬'),
    ('https://feeds.feedburner.com/NotionBlog', 'Notion Blog', '🗂️'),
    ('https://blog.todoist.com/feed/', 'Todoist Blog', '✅'),
]

for url, title, emoji in productivity_feeds:
    print(f'<div class="feed-widget">')
    print(f'<h3>{emoji} {title}</h3>')
    items = fetch_rss_feed(url, 3)
    for item in items:
        print(f'<div class="feed-item">')
        print(f'<a href="{item["link"]}" target="_blank" rel="noopener">{item["title"]}</a>')
        print(f'<span class="feed-date">{item["published"]}</span>')
        print(f'</div>')
    print(f'</div>')
    time.sleep(1)

print('''    </div>''')

# NEWS & ENTERTAINMENT SECTION
print('''    <div class="dashboard-section">
      <h2>📰 News & Entertainment</h2>''')

news_feeds = [
    ('https://feeds.bbci.co.uk/news/uk/rss.xml', 'BBC News', '🇬🇧'),
    ('https://www.wired.com/feed/rss', 'WIRED', '🔬'),
    ('https://rss.cnn.com/rss/edition.rss', 'CNN', '🌍'),
    ('https://feeds.npr.org/1001/rss.xml', 'NPR', '🎙️'),
    ('https://www.theonion.com/rss', 'The Onion', '😂'),
]

for url, title, emoji in news_feeds:
    print(f'<div class="feed-widget">')
    print(f'<h3>{emoji} {title}</h3>')
    items = fetch_rss_feed(url, 3)
    for item in items:
        print(f'<div class="feed-item">')
        print(f'<a href="{item["link"]}" target="_blank" rel="noopener">{item["title"]}</a>')
        print(f'<span class="feed-date">{item["published"]}</span>')
        print(f'</div>')
    print(f'</div>')
    time.sleep(1)

print('''    </div>''')

# K-POP & ASIAN ENTERTAINMENT SECTION
print('''    <div class="dashboard-section">
      <h2>🎤 K-Pop & Asian Entertainment</h2>''')

kpop_feeds = [
    ('https://www.koreaboo.com/feed/', 'Koreaboo', '🇰🇷'),
    ('https://www.allkpop.com/feed', 'AllKpop', '✨'),
    ('https://www.soompi.com/feed', 'Soompi', '📰'),
    ('https://www.billboard.com/rss/billboard-news', 'Billboard', '🏆'),
    ('https://www.reddit.com/r/kpopthoughts/.rss', 'r/kpopthoughts', '💭'),
]

for url, title, emoji in kpop_feeds:
    print(f'<div class="feed-widget">')
    print(f'<h3>{emoji} {title}</h3>')
    items = fetch_rss_feed(url, 3)
    for item in items:
        print(f'<div class="feed-item">')
        print(f'<a href="{item["link"]}" target="_blank" rel="noopener">{item["title"]}</a>')
        print(f'<span class="feed-date">{item["published"]}</span>')
        print(f'</div>')
    print(f'</div>')
    time.sleep(1)

print('''    </div>''')

# LGBTQ+ & THAI GL CONTENT SECTION
print('''    <div class="dashboard-section">
      <h2>🌈 LGBTQ+ & Thai GL</h2>''')

lgbtq_feeds = [
    ('https://www.autostraddle.com/feed/', 'Autostraddle', '🌈'),
    ('https://www.them.us/rss', 'Them', '🎭'),
    ('https://www.reddit.com/r/ThaiGL/.rss', 'r/ThaiGL', '🇹🇭'),
    ('https://www.reddit.com/r/GirlsLove/.rss', 'r/GirlsLove', '❤️'),
]

for url, title, emoji in lgbtq_feeds:
    print(f'<div class="feed-widget">')
    print(f'<h3>{emoji} {title}</h3>')
    items = fetch_rss_feed(url, 3)
    for item in items:
        print(f'<div class="feed-item">')
        print(f'<a href="{item["link"]}" target="_blank" rel="noopener">{item["title"]}</a>')
        print(f'<span class="feed-date">{item["published"]}</span>')
        print(f'</div>')
    print(f'</div>')
    time.sleep(1)

print('''    </div>''')

# ESPORTS & GAMING NEWS SECTION
print('''    <div class="dashboard-section">
      <h2>🎮 Esports & Gaming</h2>''')

esports_feeds = [
    ('https://www.reddit.com/r/leagueoflegends/.rss', 'r/leagueoflegends', '🎯'),
    ('https://www.reddit.com/r/gaming/.rss', 'r/gaming', '👾'),
    ('https://lolesports.com/rss', 'LoL Esports', '⚔️'),
    ('https://www.gamespot.com/feeds/news/', 'GameSpot News', '📰'),
]

for url, title, emoji in esports_feeds:
    print(f'<div class="feed-widget">')
    print(f'<h3>{emoji} {title}</h3>')
    items = fetch_rss_feed(url, 3)
    for item in items:
        print(f'<div class="feed-item">')
        print(f'<a href="{item["link"]}" target="_blank" rel="noopener">{item["title"]}</a>')
        print(f'<span class="feed-date">{item["published"]}</span>')
        print(f'</div>')
    print(f'</div>')
    time.sleep(1)

print('''    </div>''')

# ANALYTICS & DATA SCIENCE SECTION
print('''    <div class="dashboard-section">
      <h2>📊 Analytics & Data Science</h2>''')

analytics_feeds = [
    ('https://r-bloggers.com/feed/', 'R-Bloggers', '📊'),
    ('https://blog.rstudio.com/index.xml', 'RStudio Blog', '🔬'),
    ('https://mode.com/blog/rss/', 'Mode Analytics', '📈'),
    ('https://www.reddit.com/r/analytics/.rss', 'r/analytics', '💬'),
]

for url, title, emoji in analytics_feeds:
    print(f'<div class="feed-widget">')
    print(f'<h3>{emoji} {title}</h3>')
    items = fetch_rss_feed(url, 3)
    for item in items:
        print(f'<div class="feed-item">')
        print(f'<a href="{item["link"]}" target="_blank" rel="noopener">{item["title"]}</a>')
        print(f'<span class="feed-date">{item["published"]}</span>')
        print(f'</div>')
    print(f'</div>')
    time.sleep(1)

print('''    </div>''')

# QUICK STATUS & QUICK LINKS COMBINED SECTION
print('''    <div class="dashboard-section combined-section">
      <div class="status-column">
        <h2>⏰ Current Status</h2>
        <div class="status-widget">
          <div class="status-item">
            <span class="status-label">F1 Season:</span>
            <span class="status-value">2024 Ongoing</span>
          </div>
          <div class="status-item">
            <span class="status-label">Premier League:</span>
            <span class="status-value">2023/24 Season</span>
          </div>
          <div class="status-item">
            <span class="status-label">K-Pop:</span>
            <span class="status-value">Active Releases</span>
          </div>
          <div class="status-item">
            <span class="status-label">NHL:</span>
            <span class="status-value">2023-24 Season</span>
          </div>
        </div>
        
        <div class="calendar-widget">
          <h3>📅 This Week</h3>
          <div class="calendar-item">
            <span class="day">Mon</span>
            <span class="event">New Music Releases</span>
          </div>
          <div class="calendar-item">
            <span class="day">Wed</span>
            <span class="event">F1 Updates</span>
          </div>
          <div class="calendar-item">
            <span class="day">Fri</span>
            <span class="event">Gaming News</span>
          </div>
          <div class="calendar-item">
            <span class="day">Sun</span>
            <span class="event">Sports Recap</span>
          </div>
        </div>
      </div>
      
      <div class="links-column">
        <h2>⚡ Quick Links</h2>
        <div class="quick-links-grid">
          <!-- Tech & Gaming -->
          <div class="links-category">
            <h4>🎮 Gaming & Tech</h4>
            <a href="https://twitch.tv/trackingthepros" target="_blank" rel="noopener">Twitch: TrackingThePros</a>
            <a href="https://twitch.tv/lck" target="_blank" rel="noopener">Twitch: LCK</a>
            <a href="https://youtube.com/@LinusTechTips" target="_blank" rel="noopener">YouTube: LTT</a>
            <a href="https://youtube.com/@theradbrad" target="_blank" rel="noopener">YouTube: theRadBrad</a>
          </div>
          
          <!-- K-Pop -->
          <div class="links-category">
            <h4>🎵 K-Pop</h4>
            <a href="https://youtube.com/@REDVELVET" target="_blank" rel="noopener">YouTube: Red Velvet</a>
            <a href="https://youtube.com/@official_twice" target="_blank" rel="noopener">YouTube: TWICE</a>
            <a href="https://youtube.com/@SHINee" target="_blank" rel="noopener">YouTube: SHINee</a>
            <a href="https://youtube.com/@OfficialMAMAMOO" target="_blank" rel="noopener">YouTube: MAMAMOO</a>
          </div>
          
          <!-- Sports -->
          <div class="links-category">
            <h4>🏆 Sports</h4>
            <a href="https://www.formula1.com/" target="_blank" rel="noopener">F1 Official</a>
            <a href="https://www.manutd.com/" target="_blank" rel="noopener">Man United</a>
            <a href="https://www.nhl.com/" target="_blank" rel="noopener">NHL</a>
            <a href="https://www.espn.com/" target="_blank" rel="noopener">ESPN</a>
          </div>
          
          <!-- Communities -->
          <div class="links-category">
            <h4>💬 Communities</h4>
            <a href="https://reddit.com/r/technology" target="_blank" rel="noopener">r/technology</a>
            <a href="https://reddit.com/r/kpop" target="_blank" rel="noopener">r/kpop</a>
            <a href="https://reddit.com/r/ManchesterUnited" target="_blank" rel="noopener">r/ManchesterUnited</a>
            <a href="https://reddit.com/r/GirlsLove" target="_blank" rel="noopener">r/GirlsLove</a>
          </div>
        </div>
      </div>
    </div>''')

# Close the HTML
print('''  </div>
</div>

<style>
.dashboard-container {
  max-width: 1600px;
  margin: 0 auto;
  padding: 20px;
}

.dashboard-grid {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(400px, 1fr));
  gap: 25px;
  margin-top: 20px;
}

.dashboard-section {
  background: white;
  padding: 25px;
  border-radius: 12px;
  box-shadow: 0 4px 6px rgba(0,0,0,0.1);
  border: 1px solid #e1e5e9;
}

.dashboard-section h2 {
  margin-top: 0;
  color: #2c3e50;
  border-bottom: 2px solid #3498db;
  padding-bottom: 10px;
  margin-bottom: 20px;
  font-size: 1.3em;
}

.subtitle {
  color: #7f8c8d;
  font-size: 0.9em;
  margin-top: -10px;
  margin-bottom: 20px;
}

.feed-widget {
  margin-bottom: 25px;
  padding-bottom: 20px;
  border-bottom: 1px solid #ecf0f1;
}

.feed-widget:last-child {
  border-bottom: none;
  margin-bottom: 0;
}

.feed-widget h3 {
  margin: 0 0 15px 0;
  color: #34495e;
  font-size: 1.1em;
  display: flex;
  align-items: center;
  gap: 8px;
}

.feed-item {
  margin: 12px 0;
  padding: 12px;
  background: #f8f9fa;
  border-radius: 8px;
  border-left: 4px solid #3498db;
  display: flex;
  justify-content: space-between;
  align-items: flex-start;
  gap: 10px;
  transition: transform 0.2s ease;
}

.feed-item:hover {
  transform: translateY(-2px);
  box-shadow: 0 4px 8px rgba(0,0,0,0.1);
}

.feed-item a {
  text-decoration: none;
  color: #2c3e50;
  font-weight: 500;
  flex: 1;
  line-height: 1.4;
}

.feed-item a:hover {
  color: #3498db;
}

.feed-date {
  color: #7f8c8d;
  font-size: 0.8em;
  white-space: nowrap;
  background: #e9ecef;
  padding: 4px 8px;
  border-radius: 4px;
  font-weight: 500;
}

/* Combined Section Styles */
.combined-section {
  display: grid;
  grid-template-columns: 1fr 2fr;
  gap: 30px;
}

.status-column, .links-column {
  display: flex;
  flex-direction: column;
  gap: 20px;
}

.status-widget {
  background: #f8f9fa;
  padding: 20px;
  border-radius: 8px;
  border-left: 4px solid #27ae60;
}

.status-item {
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding: 8px 0;
  border-bottom: 1px solid #e9ecef;
}

.status-item:last-child {
  border-bottom: none;
}

.status-label {
  font-weight: 600;
  color: #2c3e50;
}

.status-value {
  color: #27ae60;
  font-weight: 500;
  background: #d5f4e6;
  padding: 4px 8px;
  border-radius: 4px;
  font-size: 0.9em;
}

.calendar-widget {
  background: #fff3cd;
  padding: 20px;
  border-radius: 8px;
  border-left: 4px solid #ffc107;
}

.calendar-widget h3 {
  margin-top: 0;
  margin-bottom: 15px;
  color: #856404;
}

.calendar-item {
  display: flex;
  align-items: center;
  gap: 15px;
  padding: 8px 0;
  border-bottom: 1px solid #ffeaa7;
}

.calendar-item:last-child {
  border-bottom: none;
}

.day {
  font-weight: bold;
  color: #856404;
  min-width: 35px;
}

.event {
  color: #856404;
  flex: 1;
}

.quick-links-grid {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(180px, 1fr));
  gap: 20px;
}

.links-category {
  display: flex;
  flex-direction: column;
  gap: 10px;
}

.links-category h4 {
  margin: 0 0 10px 0;
  color: #2c3e50;
  font-size: 1em;
  border-bottom: 2px solid #bdc3c7;
  padding-bottom: 5px;
}

.links-category a {
  padding: 10px 12px;
  background: #ecf0f1;
  border-radius: 6px;
  text-decoration: none;
  color: #2c3e50;
  font-size: 0.9em;
  transition: all 0.2s ease;
  border: 1px solid transparent;
  text-align: center;
}

.links-category a:hover {
  background: #3498db;
  color: white;
  transform: translateX(5px);
  text-decoration: none;
}

/* Section-specific colors */
.dashboard-section:nth-child(1) { border-top: 4px solid #e74c3c; } /* Tech - Red */
.dashboard-section:nth-child(2) { border-top: 4px solid #3498db; } /* Productivity - Blue */
.dashboard-section:nth-child(3) { border-top: 4px solid #9b59b6; } /* News - Purple */
.dashboard-section:nth-child(4) { border-top: 4px solid #e67e22; } /* K-Pop - Orange */
.dashboard-section:nth-child(5) { border-top: 4px solid #e84393; } /* LGBTQ+ - Pink */
.dashboard-section:nth-child(6) { border-top: 4px solid #00cec9; } /* Esports - Teal */
.dashboard-section:nth-child(7) { border-top: 4px solid #fdcb6e; } /* Analytics - Yellow */
.dashboard-section:nth-child(8) { border-top: 4px solid #27ae60; } /* Combined - Green */

@media (max-width: 1200px) {
  .combined-section {
    grid-template-columns: 1fr;
    gap: 20px;
  }
}

@media (max-width: 768px) {
  .dashboard-grid {
    grid-template-columns: 1fr;
  }
  
  .quick-links-grid {
    grid-template-columns: 1fr;
  }
  
  .feed-item {
    flex-direction: column;
    gap: 8px;
  }
  
  .feed-date {
    align-self: flex-start;
  }
  
  .status-item {
    flex-direction: column;
    align-items: flex-start;
    gap: 5px;
  }
  
  .calendar-item {
    flex-direction: column;
    align-items: flex-start;
    gap: 5px;
  }
}

.loading {
  text-align: center;
  color: #7f8c8d;
  font-style: italic;
  padding: 20px;
}
</style>
''')
EOF

# Run the Python script to generate the dashboard
python3 scripts/rss_dashboard.py > _pages/dashboard.md

# Cleanup
rm -f scripts/rss_dashboard.py

echo "Comprehensive static dashboard built successfully!"