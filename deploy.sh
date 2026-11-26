#!/usr/bin/env bash
# Bygger og starter Salgsdemo med versjonsnummer = <dato>.<build>.
# Build = antall commits på main, så hver merge gir et nytt, stigende nummer.
set -euo pipefail
cd "$(dirname "$0")"
export BUILD_DATE=$(date +%Y-%m-%d)
export GIT_COMMIT=$(git rev-parse HEAD)
export APP_VERSION="$(date +%Y.%m.%d).$(git rev-list --count HEAD)"
echo "Deployer Salgsdemo v$APP_VERSION ($GIT_COMMIT)"
docker compose up -d --build
docker image prune -f >/dev/null
