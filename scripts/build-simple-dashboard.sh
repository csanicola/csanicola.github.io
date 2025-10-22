#!/bin/bash
set -e

echo "Building simple RSS dashboard..."

# Create a Python script to fetch RSS feeds
cat > scripts/rss_dashboard.py << 'EOF'
import feedparser
import json
from datetime import datetime
import sys

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

# Define your RSS feeds
feeds = {
    'Hacker News': 'https://hnrss.org/frontpage',
    'F1 News': 'https://www.formula1.com/en/latest/all.xml',
    # Add more feeds here
}

print('<div class="simple-dashboard">')
print(f'<h2>Personal Dashboard</h2>')
print(f'<p><strong>Last updated:</strong> {datetime.now().strftime("%Y-%m-%d %H:%M")}</p>')

for feed_name, feed_url in feeds.items():
    print(f'<div class="feed-widget">')
    print(f'<h3>📰 {feed_name}</h3>')
    
    items = fetch_rss_feed(feed_url)
    for item in items:
        print(f'<div class="feed-item">')
        print(f'<a href="{item["link"]}" target="_blank">{item["title"]}</a>')
        print(f'<br><small>{item["published"]}</small>')
        print(f'</div>')
    
    print(f'</div>')

print('</div>')
EOF

# Run the Python script to generate dashboard content
python3 scripts/rss_dashboard.py > _dashboard-content.html

# Create the Jekyll page
cat > _pages/dashboard.md << 'EOF'
---
layout: page
title: Dashboard
permalink: /dashboard/
nav: true
---

<div class="dashboard-container">
EOF

cat _dashboard-content.html >> _pages/dashboard.md

echo '</div>' >> _pages/dashboard.md

# Cleanup
rm -f _dashboard-content.html scripts/rss_dashboard.py

echo "Simple dashboard built successfully!"