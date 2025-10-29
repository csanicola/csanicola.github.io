#!/bin/bash
set -e

echo "Building static RSS-powered dashboard..."

# Create a Python script that only uses RSS feeds
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
            title = entry.title[:100] + "..." if len(entry.title) > 100 else entry.title
            published = entry.get('published', entry.get('updated', 'Recent'))
            # Format date nicely
            if published != 'Recent':
                try:
                    published = datetime.strptime(published[:16], '%a, %d %b %Y').strftime('%b %d')
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
  <h1>📊 Daily Digest</h1>
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
    time.sleep(1)  # Be nice to servers

print('''    </div>''')

# NEWS & ENTERTAINMENT SECTION
print('''    <div class="dashboard-section">
      <h2>📰 News & Entertainment</h2>''')

news_feeds = [
    ('https://feeds.bbci.co.uk/news/uk/rss.xml', 'BBC News', '🇬🇧'),
    ('https://www.wired.com/feed/rss', 'WIRED', '🔬'),
    ('http://rss.cnn.com/rss/cnn_topstories.rss', 'CNN', '🌍'),
    ('https://feeds.npr.org/1001/rss.xml', 'NPR', '🎙️'),
    ('https://www.theonion.com/rss', 'The Onion', '😂'),
]

for url, title, emoji in news_feeds:
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

# K-POP & ASIAN ENTERTAINMENT SECTION
print('''    <div class="dashboard-section">
      <h2>🎤 K-Pop & Asian Entertainment</h2>''')

kpop_feeds = [
    ('https://www.koreaboo.com/feed/', 'Koreaboo', '🇰🇷'),
    ('https://www.allkpop.com/feed', 'AllKpop', '✨'),
    ('https://feeds.feedburner.com/NetizenBuzz', 'Netizen Buzz', '🐝'),
    ('https://www.soompi.com/feed', 'Soompi', '📰'),
    ('https://www.asianjunkie.com/category/k-entertainment/feed/', 'Asian Junkie', '🔥'),
]

for url, title, emoji in kpop_feeds:
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

# FORMULA 1 & SPORTS SECTION (RSS-based)
print('''    <div class="dashboard-section">
      <h2>🏎️ Formula 1 & Sports</h2>''')

sports_feeds = [
    ('https://www.espn.com/espn/rss/news', 'ESPN', '🏈'),
    ('https://www.skysports.com/rss/12040', 'Sky Sports F1', '🏎️'),
    ('https://www.manutd.com/en/feeds/news', 'Man United', '🔴'),
    ('https://www.nhl.com/rss/news', 'NHL', '🏒'),
]

for url, title, emoji in sports_feeds:
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

# QUICK LINKS SECTION
print('''    <div class="dashboard-section">
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
    </div>''')

# Close the HTML
print('''  </div>
</div>

<style>
.dashboard-container {
  max-width: 1400px;
  margin: 0 auto;
  padding: 20px;
}

.dashboard-grid {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(400px, 1fr));
  gap: 20px;
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
  justify-content: between;
  align-items: flex-start;
  gap: 10px;
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
  padding: 2px 6px;
  border-radius: 4px;
  font-weight: 500;
}

.quick-links-grid {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
  gap: 20px;
}

.links-category {
  display: flex;
  flex-direction: column;
  gap: 8px;
}

.links-category h4 {
  margin: 0 0 8px 0;
  color: #2c3e50;
  font-size: 1em;
  border-bottom: 1px solid #bdc3c7;
  padding-bottom: 5px;
}

.links-category a {
  padding: 8px 12px;
  background: #ecf0f1;
  border-radius: 6px;
  text-decoration: none;
  color: #2c3e50;
  font-size: 0.9em;
  transition: all 0.2s ease;
  border: 1px solid transparent;
}

.links-category a:hover {
  background: #3498db;
  color: white;
  transform: translateX(5px);
  text-decoration: none;
}

/* Section-specific colors */
.dashboard-section:nth-child(1) { border-top: 4px solid #e74c3c; } /* Tech - Red */
.dashboard-section:nth-child(2) { border-top: 4px solid #3498db; } /* News - Blue */
.dashboard-section:nth-child(3) { border-top: 4px solid #9b59b6; } /* K-Pop - Purple */
.dashboard-section:nth-child(4) { border-top: 4px solid #27ae60; } /* Sports - Green */
.dashboard-section:nth-child(5) { border-top: 4px solid #f39c12; } /* Links - Orange */

@media (max-width: 768px) {
  .dashboard-grid {
    grid-template-columns: 1fr;
  }
  
  .quick-links-grid {
    grid-template-columns: 1fr;
  }
  
  .feed-item {
    flex-direction: column;
    gap: 5px;
  }
  
  .feed-date {
    align-self: flex-start;
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

echo "Static RSS dashboard built successfully!"