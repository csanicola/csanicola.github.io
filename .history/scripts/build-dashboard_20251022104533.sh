#!/bin/bash
set -e

echo "Building dashboard..."

# Clone and build glance
if [ ! -d "glance-temp" ]; then
    git clone https://github.com/glanceapp/glance.git glance-temp
fi

cd glance-temp
git pull
go build -o glance-app

# Export as static HTML
./glance-app --config ../glance-config/config.yml export-html > ../_dashboard-content.html

cd ..

# Create a proper Jekyll page in the _pages directory
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

# Clean up
rm -rf glance-temp _dashboard-content.html

echo "Dashboard built successfully!"