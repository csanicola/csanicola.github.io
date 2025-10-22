#!/bin/bash
set -e

echo "Building comprehensive dashboard..."

# Create a Python script with improved APIs
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

def fetch_f1_data():
    try:
        # Use Ergast API which is more reliable for F1 data
        headers = {'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36'}

        # Get current season
        current_year = datetime.now().year
        base_url = f"http://ergast.com/api/f1/{current_year}"

        results = []

        # Next Race
        try:
            response = requests.get(f"{base_url}/next.json", headers=headers, timeout=10)
            if response.status_code == 200:
                data = response.json()
                race = data['MRData']['RaceTable']['Races'][0] if data['MRData']['RaceTable']['Races'] else None
                if race:
                    race_name = race['raceName']
                    race_date = race['date']
                    circuit = race['Circuit']['circuitName']
                    results.append(f"<div class='data-item'><strong>Next F1 Race:</strong> {race_name} at {circuit} on {race_date}</div>")
                else:
                    results.append("<div class='data-item'><strong>Next F1 Race:</strong> Season ended</div>")
            else:
                results.append("<div class='data-item error'><strong>Next F1 Race:</strong> API Error</div>")
        except:
            results.append("<div class='data-item error'><strong>Next F1 Race:</strong> Failed to fetch</div>")

        # Last Race Results
        try:
            response = requests.get(f"{base_url}/last/results.json", headers=headers, timeout=10)
            if response.status_code == 200:
                data = response.json()
                if data['MRData']['RaceTable']['Races']:
                    race = data['MRData']['RaceTable']['Races'][0]
                    winner = race['Results'][0]['Driver']
                    winner_name = f"{winner['givenName']} {winner['familyName']}"
                    results.append(f"<div class='data-item'><strong>Last F1 Race:</strong> {winner_name} won {race['raceName']}</div>")
                else:
                    results.append("<div class='data-item'><strong>Last F1 Race:</strong> No recent races</div>")
            else:
                results.append("<div class='data-item error'><strong>Last F1 Race:</strong> API Error</div>")
        except:
            results.append("<div class='data-item error'><strong>Last F1 Race:</strong> Failed to fetch</div>")

        # Driver Standings
        try:
            response = requests.get(f"{base_url}/driverStandings.json", headers=headers, timeout=10)
            if response.status_code == 200:
                data = response.json()
                standings = data['MRData']['StandingsTable']['StandingsLists'][0]['DriverStandings'][0]
                driver = standings['Driver']
                driver_name = f"{driver['givenName']} {driver['familyName']}"
                points = standings['points']
                results.append(f"<div class='data-item'><strong>F1 Drivers Standings:</strong> {driver_name} leads with {points} pts</div>")
            else:
                results.append("<div class='data-item error'><strong>F1 Drivers Standings:</strong> API Error</div>")
        except:
            results.append("<div class='data-item error'><strong>F1 Drivers Standings:</strong> Failed to fetch</div>")

        # Constructor Standings
        try:
            response = requests.get(f"{base_url}/constructorStandings.json", headers=headers, timeout=10)
            if response.status_code == 200:
                data = response.json()
                standings = data['MRData']['StandingsTable']['StandingsLists'][0]['ConstructorStandings'][0]
                constructor = standings['Constructor']['name']
                points = standings['points']
                results.append(f"<div class='data-item'><strong>F1 Constructors:</strong> {constructor} leads with {points} pts</div>")
            else:
                results.append("<div class='data-item error'><strong>F1 Constructors:</strong> API Error</div>")
        except:
            results.append("<div class='data-item error'><strong>F1 Constructors:</strong> Failed to fetch</div>")

        return "".join(results)

    except Exception as e:
        return f"<div class='data-item error'><strong>F1 Data:</strong> General error: {str(e)}</div>"

def fetch_sports_data():
    try:
        headers = {'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36'}
        results = []

        # Manchester United - Use a simpler API
        try:
            # Using a free football API without authentication
            response = requests.get("https://api.football-data.org/v4/competitions/PL/matches?status=SCHEDULED",
                                  headers=headers, timeout=10)
            if response.status_code == 200:
                data = response.json()
                man_utd_match = None
                for match in data.get('matches', []):
                    if match.get('homeTeam', {}).get('name') == 'Manchester United FC' or match.get('awayTeam', {}).get('name') == 'Manchester United FC':
                        man_utd_match = match
                        break

                if man_utd_match:
                    home_team = man_utd_match['homeTeam']['name']
                    away_team = man_utd_match['awayTeam']['name']
                    date = man_utd_match['utcDate'][:10]
                    results.append(f"<div class='data-item'><strong>Man United:</strong> {home_team} vs {away_team} on {date}</div>")
                else:
                    results.append("<div class='data-item'><strong>Man United:</strong> No upcoming matches found</div>")
            else:
                # Fallback to static info
                results.append("<div class='data-item'><strong>Man United:</strong> Check official site for fixtures</div>")
        except:
            results.append("<div class='data-item'><strong>Man United:</strong> Fixtures unavailable</div>")

        # NHL Data - Improved parsing
        try:
            response = requests.get("https://api-web.nhle.com/v1/score/now", headers=headers, timeout=10)
            if response.status_code == 200:
                data = response.json()
                games_today = []

                for game in data.get('games', []):
                    game_state = game.get('gameState')
                    if game_state in ['LIVE', 'FUTURE', 'CRITICAL']:
                        home_team = game.get('homeTeam', {}).get('name', {}).get('default', 'Home')
                        away_team = game.get('awayTeam', {}).get('name', {}).get('default', 'Away')

                        if game_state == 'LIVE':
                            home_score = game.get('homeTeam', {}).get('score', 0)
                            away_score = game.get('awayTeam', {}).get('score', 0)
                            games_today.append(f"{away_team} {away_score}-{home_score} {home_team} (LIVE)")
                        elif game_state == 'FUTURE':
                            start_time = game.get('startTimeUTC', '')[:16]
                            games_today.append(f"{away_team} vs {home_team} at {start_time}")

                if games_today:
                    results.append(f"<div class='data-item'><strong>NHL Today:</strong> {', '.join(games_today[:2])}</div>")
                else:
                    results.append("<div class='data-item'><strong>NHL Today:</strong> No games scheduled</div>")
            else:
                results.append("<div class='data-item error'><strong>NHL Today:</strong> API Error</div>")
        except Exception as e:
            results.append(f"<div class='data-item error'><strong>NHL Today:</strong> Failed to fetch</div>")

        return "".join(results)

    except Exception as e:
        return f"<div class='data-item error'><strong>Sports Data:</strong> General error</div>"

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

# Fetch F1 Data
print(fetch_f1_data())

# Fetch Sports Data
print(fetch_sports_data())

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