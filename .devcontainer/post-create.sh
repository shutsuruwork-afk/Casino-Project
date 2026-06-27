#!/bin/bash
set -e

echo "Starting GameHub Codespace Post-Create Setup..."

# Next.js のパッケージインストール (HDDを消費しないクラウドなので気にせずnpm/pnpmが使えます)
if [ -d "lobby-ui" ]; then
    echo "Installing Next.js dependencies..."
    cd lobby-ui
    npm install
    cd ..
fi

echo "All setups completed successfully!"
