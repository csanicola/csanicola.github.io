#!/bin/bash
set -e

echo "Building dashboard..."

# Check if we're in GitHub Actions
if [ -n "$GITHUB_ACTIONS" ]; then
    echo "Running in GitHub Actions - building real dashboard..."
    
    # Clone and build glance
    git clone https://github.com/glanceapp/glance.git glance-temp
    cd glance-temp
    go build -o glance-app
    ./glance-app --config ../glance-config/config.yml export-html > ../_dashboard-content.html
    cd ..
    rm -rf glance-temp
    
else
    echo "Running locally - creating preview dashboard..."
    
    # Create a preview file that explains the setup
    cat > _dashboard-content.html << 'EOF'
<div class="dashboard-preview">
    <div style="text-align: center; padding: 2rem; background: #f8f9fa; border-radius: 8px;">
        <h2>🚀 Personal Dashboard</h2>
        <p>This dashboard automatically updates every 2 hours with fresh content.</p>
        <div style="display: inline-block; text-align: left; background: white; padding: 1rem; border-radius: 4px; margin: 1rem 0;">
            <h4>📊 Current Feeds:</h4>
            <ul>
                <li>Hacker News Frontpage</li>
                <li>Formula 1 Latest News</li>
                <li>YouTube Channel Updates</li>
                <li>Custom RSS Feeds</li>
            </ul>
        </div>
        <p><strong>Next automated update:</strong> Via GitHub Actions</p>
        <p><em>The live version with real data will be available after the next GitHub Actions run.</em></p>
    </div>
</div>
EOF
fi

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
rm -f _dashboard-content.html

echo "Dashboard processing complete!"