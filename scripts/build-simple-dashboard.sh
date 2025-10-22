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

def fetch_f1_data(url, title):
    try:
        response = requests.get(url, timeout=10)
        if response.status_code == 200:
            data = response.json()

            if 'next' in url:
                # Next race data
                if data:
                    race = data[0] if isinstance(data, list) else data
                    return f"<div class='data-item'><strong>{title}:</strong> {race.get('raceName', 'N/A')} - {race.get('date', 'N/A')}</div>"

            elif 'last/race' in url:
                # Last race results
                if data and 'Results' in data:
                    winner = data['Results'][0] if data['Results'] else {}
                    driver = winner.get('Driver', {})
                    return f"<div class='data-item'><strong>{title}:</strong> {driver.get('givenName', '')} {driver.get('familyName', '')} ({winner.get('Constructor', {}).get('name', '')})</div>"

            elif 'drivers-championship' in url:
                # Drivers standings
                if data and 'Standings' in data:
                    leader = data['Standings'][0] if data['Standings'] else {}
                    return f"<div class='data-item'><strong>{title}:</strong> {leader.get('Driver', {}).get('givenName', '')} {leader.get('Driver', {}).get('familyName', '')} - {leader.get('points', 0)} pts</div>"

            elif 'constructors-championship' in url:
                # Constructors standings
                if data and 'Standings' in data:
                    leader = data['Standings'][0] if data['Standings'] else {}
                    return f"<div class='data-item'><strong>{title}:</strong> {leader.get('Constructor', {}).get('name', '')} - {leader.get('points', 0)} pts</div>"

            return f"<div class='data-item'><strong>{title}:</strong> Data parsed</div>"
        else:
            return f"<div class='data-item error'><strong>{title}:</strong> API Error {response.status_code}</div>"
    except Exception as e:
        return f"<div class='data-item error'><strong>{title}:</strong> Error: {str(e)}</div>"

def fetch_sports_data(url, title):
    try:
        headers = {}
        # Add User-Agent to avoid 403 errors
        headers['User-Agent'] = 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36'

        response = requests.get(url, headers=headers, timeout=10)
        if response.status_code == 200:
            data = response.json()

            if 'football-data' in url:
                # Manchester United fixtures
                matches = data.get('matches', [])
                next_match = None
                for match in matches:
                    if match.get('status') == 'SCHEDULED':
                        next_match = match
                        break

                if next_match:
                    home_team = next_match.get('homeTeam', {}).get('name', 'TBD')
                    away_team = next_match.get('awayTeam', {}).get('name', 'TBD')
                    date = next_match.get('utcDate', 'TBD')[:10]
                    return f"<div class='data-item'><strong>{title}:</strong> {home_team} vs {away_team} on {date}</div>"
                else:
                    return f"<div class='data-item'><strong>{title}:</strong> No upcoming matches</div>"

            elif 'nhl' in url:
                # NHL data
                games = data.get('games', [])
                today_games = [game for game in games if game.get('gameState') == 'LIVE' or game.get('gameState') == 'FUTURE']
                if today_games:
                    game = today_games[0]
                    home_team = game.get('homeTeam', {}).get('name', {}).get('default', 'Home')
                    away_team = game.get('awayTeam', {}).get('name', {}).get('default', 'Away')
                    return f"<div class='data-item'><strong>{title}:</strong> {away_team} vs {home_team}</div>"
                else:
                    return f"<div class='data-item'><strong>{title}:</strong> No games today</div>"

            return f"<div class='data-item'><strong>{title}:</strong> Data loaded</div>"
        else:
            return f"<div class='data-item error'><strong>{title}:</strong> API Error {response.status_code}</div>"
    except Exception as e:
        return f"<div class='data-item error'><strong>{title}:</strong> Error: {str(e)}</div>"

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
    time.sleep(0.5)

print('''    </div>''')

# Sports & F1 Section (Combined)
print('''    <div class="dashboard-section">
      <h2>🏆 Sports & Formula 1</h2>''')

# F1 Data
f1_endpoints = [
    ('https://f1api.dev/api/current/next', 'Next F1 Race'),
    ('https://f1api.dev/api/current/last/race', 'Last F1 Race'),
    ('https://f1api.dev/api/current/drivers-championship', 'F1 Drivers Standings'),
    ('https://f1api.dev/api/current/constructors-championship', 'F1 Constructors Standings')
]

for url, title in f1_endpoints:
    print(fetch_f1_data(url, title))
    time.sleep(0.5)

# Sports Data
sports_endpoints = [
    ('https://api.football-data.org/v4/teams/66/matches?status=SCHEDULED,FINISHED', 'Manchester United'),
    ('https://api-web.nhle.com/v1/score/now', 'NHL Today')
]

for url, title in sports_endpoints:
    print(fetch_sports_data(url, title))
    time.sleep(0.5)

print('''    </div>''')

# Twitch Channels Section
print('''    <div class="dashboard-section">
      <h2>🎮 Twitch Channels</h2>
      <div class="channel-grid">''')

twitch_channels = [
    ('trackingthepros', 'TrackingThePros'),
    ('amazonian', 'Amazonian'),
    ('jakenbakelive', 'JakenbakeLive'),
    ('lck', 'LCK'),
    ('lpl', 'LPL'),
    ('lec', 'LEC'),
    ('eeowna', 'Eeowna'),
    ('EJ_SA', 'EJ_SA'),
    ('vanillamace', 'VanillaMace'),
    ('UniandOMU', 'UniandOMU')
]

for channel_id, channel_name in twitch_channels:
    print(f'<a href="https://twitch.tv/{channel_id}" target="_blank" rel="noopener" class="channel-item">📺 {channel_name}</a>')

print('''      </div>
    </div>''')

# YouTube Channels Section
print('''    <div class="dashboard-section">
      <h2>📺 YouTube Channels</h2>
      <div class="channel-grid">''')

youtube_channels = [
    ('UCXuqSBlHAE6Xw-yeJA0Tunw', 'Linus Tech Tips'),
    ('UCpqXJOEqGS-TCnazcHCo0rA', 'theRadBrad'),
    ('UCo9ZZ04kIhN_8xGxvnjaduQ', 'Stephanie Soo'),
    ('UC0JJtK3m8pwy6rVgnBz47Rw', 'Rotten Mango'),
    ('UCabq3No3wXbs6Ut-Pux6SzA', 'The TRY Channel'),
    ('UCZ0p2Bqvtgy7XnEvis4l2FQ', 'The Unsolicited Truth'),
    ('UC2sgoh6YCrf8df1UMpUciTw', 'Trixie & Katya'),
    ('UCfpaSruWW3S4dibonKXENjA', 'Tzuyang'),
    ('UC2B5onlYkZ7IaVekR9yIB6w', 'Gongsam Table'),
    ('UCT5C7yaO3RVuOgwP8JVAujQ', 'Taskmaster'),
    ('UCAL3JXZSzSm8AlZyD3nQdBA', 'Primitive Technology'),
    ('UCBs2Y3i14e1NWQxOGliatmg', 'Mother\'s Basement'),
    ('UC7dF9qfBMXrSlaaFFDvV_Yg', 'Gigguk'),
    ('UC1Dp1VItMV-YbB9Nj7qaXjg', 'Nickcompoops'),
    ('UCk9GmdlDTBfgGRb7vXeRMoQ', 'Red Velvet'),
    ('UCxkWBN3nHuo0sCz0GBVWWaQ', 'Chaeyeon'),
    ('UCJnL-TBcsYrF2SLs7tmiC8Q', 'tripleS'),
    ('UCyPwRgc3gQGqhk6RoGS50Ug', 'SHINee'),
    ('UC3SyT4_WLHzN7JmHQwKQZww', 'IU'),
    ('UCeXaojJKJ9DVFkVM6O6drBQ', 'Minho'),
    ('UCuhAUMLzJxlP1W7mEk0_6lA', 'Mamamoo'),
    ('UCiM8arBZ-GyuBFG3wy6fEgw', 'Hwasa'),
    ('UCzgxx_DM2Dcb9Y1spb9mUJA', 'Twice')
]

for channel_id, channel_name in youtube_channels:
    print(f'<a href="https://youtube.com/channel/{channel_id}" target="_blank" rel="noopener" class="channel-item">🎬 {channel_name}</a>')

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
    print(f'<a href="https://reddit.com/r/{feed}" target="_blank" rel="noopener" class="channel-item">🔗 r/{feed}</a>')

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
  padding: 8px 10px;
  background: #ecf0f1;
  border-radius: 6px;
  font-size: 0.9em;
  text-align: center;
  text-decoration: none;
  color: #2c3e50;
  transition: all 0.2s ease;
  border: 1px solid transparent;
}

.channel-item:hover {
  background: #3498db;
  color: white;
  transform: translateY(-2px);
  box-shadow: 0 4px 8px rgba(52, 152, 219, 0.3);
  text-decoration: none;
}

.data-item {
  padding: 10px;
  margin: 8px 0;
  background: #e8f5e8;
  border-radius: 6px;
  border-left: 3px solid #27ae60;
  font-size: 0.95em;
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

echo "Enhanced dashboard built successfully!"