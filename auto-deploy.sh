#!/usr/bin/env bash
# Kjøres fra cron på ContainerOne. Henter origin/main og deployer hvis det har kommet nye commits.
# Repoet er public, så det brukes bevisst IKKE en self-hosted GitHub-runner (PR-er fra forks
# kunne da kjørt kode på serveren). Serveren trekker i stedet endringene selv.
set -euo pipefail
DIR=/home/tommy/salgsdemo
LOG=/home/tommy/scripts/logs/salgsdemo-deploy.log
exec 9>/tmp/salgsdemo-deploy.lock
flock -n 9 || exit 0
cd "$DIR"
git fetch -q origin main
if [ "$(git rev-parse HEAD)" = "$(git rev-parse origin/main)" ]; then exit 0; fi
{
  echo "$(date -u '+%Y-%m-%dT%H:%M:%SZ') ny commit $(git rev-parse --short origin/main) – deployer"
  git reset -q --hard origin/main
  ./deploy.sh
  for i in $(seq 1 20); do
    if docker exec salgsdemo-web wget -qO- http://127.0.0.1:3000/healthz >/dev/null 2>&1; then echo "helsesjekk OK"; exit 0; fi
    sleep 3
  done
  echo "HELSESJEKK FEILET"; exit 1
} >> "$LOG" 2>&1
