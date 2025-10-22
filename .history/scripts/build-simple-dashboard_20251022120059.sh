#!/bin/bash
set -e

echo "Building comprehensive dashboard..."

# Create a Python script to fetch all your feeds
cat > scripts/rss_dashboard.py << 'EOF'
import feedparser
import requests
import json
from datetime import datetime
import time

def fetch_rss_feed(url, max_items=5):
    try:
        feed = feedparser.parse(url)
        items = []
        for entry in feed.entries[:max_items]:
            items.append({
                'title': entry.title,
                'link': entry.link,
                'published': entry.get('published', 'No date')
            })
        return items
    except Exception as e:
        return [{'title': f'Error fetching feed: {e}', 'link': '#', 'published': 'Error'}]

def fetch_json_data(url, title):
    try:
        response = requests.get(url, timeout=10)
        if response.status_code == 200:
            return f"<div class='data-item'><strong>{title}:</strong> Data loaded successfully</div>"
        else:
            return f"<div class='data-item error'><strong>{title}:</strong> API Error {response.status_code}</div>"
    except Exception as e:
        return f"<div class='data-item error'><strong>{title}:</strong> Connection error</div>"

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
  
  <div class="dashboard-grid">
''')

# News Feeds Section
print('''    <div class="dashboard-section">
      <h2>📰 News & Tech</h2>''')

news_feeds = [
    ('https://feeds.bbci.co.uk/news/uk/rss.xml', 'BBC News'),
    ('https://www.theverge.com/rss/index.xml', 'The Verge'),
    ('https://www.gamespot.com/feeds/mashup', 'GameSpot'),
    ('https://www.wired.com/feed/rss', 'WIRED'),
    ('https://techcrunch.com/feed/', 'TechCrunch'),
    ('https://www.koreaboo.com/feed/', 'Koreaboo'),
    ('https://rss.app/feeds/uTAh28NvFk2AaOES.xml', 'AllKpop'),
    ('https://feed.cnet.com/feed/news', 'CNET')
]

for url, title in news_feeds:
    print(f'<div class="feed-widget">')
    print(f'<h3>📖 {title}</h3>')
    items = fetch_rss_feed(url, 3)
    for item in items:
        print(f'<div class="feed-item">')
        print(f'<a href="{item["link"]}" target="_blank" rel="noopener">{item["title"]}</a>')
        print(f'<br><small>{item["published"]}</small>')
        print(f'</div>')
    print(f'</div>')
    time.sleep(0.5)  # Be nice to the servers

print('''    </div>''')

# Formula 1 Section
print('''    <div class="dashboard-section">
      <h2>🏎️ Formula 1</h2>''')

f1_endpoints = [
    ('https://f1api.dev/api/current/next', 'Next Race'),
    ('https://f1api.dev/api/current/last/race', 'Last Race Results'),
    ('https://f1api.dev/api/current/drivers-championship', 'Drivers Standings'),
    ('https://f1api.dev/api/current/constructors-championship', 'Constructors Standings'),
    ('https://f1api.dev/api/current/next?timezone=Europe/London', 'Next Race (London Time)')
]

for url, title in f1_endpoints:
    print(fetch_json_data(url, title))
    time.sleep(0.5)

print('''    </div>''')

# Sports Section
print('''    <div class="dashboard-section">
      <h2>⚽ Sports</h2>''')

sports_endpoints = [
    ('https://api.football-data.org/v4/teams/66/matches?status=SCHEDULED,FINISHED', 'Manchester United Fixtures'),
    ('https://api-web.nhle.com/v1/score/now', 'NHL Today')
]

for url, title in sports_endpoints:
    print(fetch_json_data(url, title))
    time.sleep(0.5)

print('''    </div>''')

# Twitch Channels Section
print('''    <div class="dashboard-section">
      <h2>🎮 Twitch Channels</h2>
      <div class="channel-grid">''')

twitch_channels = [
    'trackingthepros', 'amazonian', 'jakenbakelive', 'lck', 'lpl', 
    'lec', 'eeowna', 'EJ_SA', 'vanillamace', 'UniandOMU'
]

for channel in twitch_channels:
    print(f'<div class="channel-item">📺 {channel}</div>')

print('''      </div>
    </div>''')

# YouTube Channels Section
print('''    <div class="dashboard-section">
      <h2>📺 YouTube Channels</h2>
      <div class="channel-grid">''')

youtube_channels = [
    'Linus Tech Tips', 'theRadBrad', 'Stephanie Soo', 'Rotten Mango', 'The TRY Channel',
    'The Unsolicited Truth', 'Trixie & Katya', 'Tzuyang', 'Gongsam Table', 'Taskmaster',
    'Primitive Technology', 'Mother\'s Basement', 'Gigguk', 'Nickcompoops',
    'Red Velvet', 'Chaeyeon', 'tripleS', 'SHINee', 'IU', 'Minho', 'Mamamoo', 'Hwasa', 'Twice'
]

for channel in youtube_channels:
    print(f'<div class="channel-item">🎬 {channel}</div>')

print('''      </div>
    </div>''')

# Reddit Section
print('''    <div class="dashboard-section">
      <h2>💬 Reddit Communities</h2>
      <div class="channel-grid">''')

reddit_feeds = [
    'technology', 'ObsidianMD', 'analytics', 'AskReddit', 'kpop',
    'ManchesterUnited', 'ThaiGL', 'GirlsLove'
]

for feed in reddit_feeds:
    print(f'<div class="channel-item">🔗 r/{feed}</div>')

print('''      </div>
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
  padding: 20px;
  border-radius: 12px;
  box-shadow: 0 4px 6px rgba(0,0,0,0.1);
  border: 1px solid #e1e5e9;
}

.dashboard-section h2 {
  margin-top: 0;
  color: #2c3e50;
  border-bottom: 2px solid #3498db;
  padding-bottom: 10px;
  margin-bottom: 15px;
}

.feed-widget {
  margin-bottom: 20px;
  padding-bottom: 15px;
  border-bottom: 1px solid #ecf0f1;
}

.feed-widget:last-child {
  border-bottom: none;
  margin-bottom: 0;
}

.feed-widget h3 {
  margin: 0 0 10px 0;
  color: #34495e;
  font-size: 1.1em;
}

.feed-item {
  margin: 8px 0;
  padding: 8px;
  background: #f8f9fa;
  border-radius: 6px;
  border-left: 3px solid #3498db;
}

.feed-item a {
  text-decoration: none;
  color: #2c3e50;
  font-weight: 500;
}

.feed-item a:hover {
  color: #3498db;
}

.feed-item small {
  color: #7f8c8d;
  font-size: 0.85em;
}

.channel-grid {
  display: grid;
  grid-template-columns: repeat(auto-fill, minmax(150px, 1fr));
  gap: 8px;
}

.channel-item {
  padding: 6px 10px;
  background: #ecf0f1;
  border-radius: 6px;
  font-size: 0.9em;
  text-align: center;
}

.data-item {
  padding: 8px;
  margin: 5px 0;
  background: #e8f5e8;
  border-radius: 6px;
  border-left: 3px solid #27ae60;
}

.data-item.error {
  background: #ffeaa7;
  border-left-color: #fdcb6e;
}

@media (max-width: 768px) {
  .dashboard-grid {
    grid-template-columns: 1fr;
  }
  
  .channel-grid {
    grid-template-columns: repeat(auto-fill, minmax(120px, 1fr));
  }
}
</style>
''')
EOF

# Run the Python script to generate the dashboard
python3 scripts/rss_dashboard.py > _pages/dashboard.md

# Cleanup
rm -f scripts/rss_dashboard.py

echo "Comprehensive dashboard built successfully!"