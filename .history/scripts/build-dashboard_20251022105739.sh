#!/bin/bash
set -e

echo "Building dashboard..."

# Always use the pre-built binary approach (more reliable)
echo "Downloading Glance binary..."

# Download the latest Glance binary for Linux (amd64)
GLANCE_VERSION="0.9.2"
BINARY_URL="https://github.com/glanceapp/glance/releases/download/v${GLANCE_VERSION}/glance_${GLANCE_VERSION}_linux_amd64.tar.gz"

# Download and extract
wget -q -O glance.tar.gz "$BINARY_URL"
tar -xzf glance.tar.gz
chmod +x glance

# Export as static HTML
./glance --config glance-config/config.yml export-html > _dashboard-content.html

# Clean up downloaded files
rm -f glance glance.tar.gz

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

# Clean up
rm -f _dashboard-content.html

echo "Dashboard built successfully!"