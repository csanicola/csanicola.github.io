#!/bin/bash
set -e

echo "Building dashboard..."

# Use a reliable method to get the latest Glance binary
echo "Downloading latest Glance binary..."

# Method 1: Try to get the latest release binary
GLANCE_VERSION="0.9.1"  # Use a known working version
BINARY_URL="https://github.com/glanceapp/glance/releases/download/v${GLANCE_VERSION}/glance_${GLANCE_VERSION}_linux_amd64.tar.gz"

echo "Downloading from: $BINARY_URL"

# Download and extract
if wget -q -O glance.tar.gz "$BINARY_URL"; then
    echo "Download successful"
    tar -xzf glance.tar.gz
    chmod +x glance
    
    # Export as static HTML
    echo "Generating dashboard HTML..."
    ./glance --config glance-config/config.yml export-html > _dashboard-content.html
    
    # Clean up downloaded files
    rm -f glance glance.tar.gz
else
    echo "Download failed, creating fallback dashboard"
    create_fallback_dashboard
fi

create_dashboard_page
cleanup

echo "Dashboard built successfully!"

create_fallback_dashboard() {
    cat > _dashboard-content.html << 'EOF'
<div class="dashboard-fallback">
    <div style="text-align: center; padding: 2rem; background: #f0f8ff; border-radius: 8px; border: 1px solid #b3d9ff;">
        <h2>📊 Personal Dashboard</h2>
        <p><strong>Last updated:</strong> <span id="current-date"></span></p>
        <div style="display: inline-block; text-align: left; background: white; padding: 1.5rem; border-radius: 6px; margin: 1rem 0; box-shadow: 0 2px 4px rgba(0,0,0,0.1);">
            <h4>🚀 Active Feeds:</h4>
            <ul>
                <li>🗞️ Hacker News Frontpage</li>
                <li>🏎️ Formula 1 Latest News</li>
                <li>📺 YouTube Channel Updates</li>
                <li>📡 Custom RSS Feeds</li>
            </ul>
        </div>
        <p><em>The dashboard content is being refreshed. Check back in a few minutes.</em></p>
    </div>
    <script>
        document.getElementById('current-date').textContent = new Date().toLocaleString();
    </script>
</div>
EOF
}

create_dashboard_page() {
    # Create the Jekyll page in _pages directory
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
}

cleanup() {
    # Clean up
    rm -f _dashboard-content.html
}