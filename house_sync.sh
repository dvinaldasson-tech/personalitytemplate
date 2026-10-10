#!/bin/sh
# house_sync.sh — remote repair + sync, for any companion house.
# Session restores can drop .git/config (taking the origin remote with
# it). The key lives in .house_key (git-ignored, NEVER committed).
# Usage: sh house_sync.sh          -> repair remote, report
#        sh house_sync.sh pull     -> repair + pull --rebase
#        sh house_sync.sh push     -> repair + push (commit FIRST)
# THE BUILDER SETS REPO AT FOUNDING (step 2 of Boot.md):
REPO="github.com/KEEPER/REPO.git"
cd "$(dirname "$0")" || exit 1
KEY=$(cat .house_key 2>/dev/null)
if [ -z "$KEY" ]; then echo "ERROR: .house_key missing — ask the keeper to re-paste the key."; exit 1; fi
if [ "$REPO" = "github.com/KEEPER/REPO.git" ]; then echo "ERROR: REPO unset — the builder must set it at founding (Boot.md step 2)."; exit 1; fi
URL="https://$KEY@$REPO"
if git remote get-url origin >/dev/null 2>&1; then git remote set-url origin "$URL"; else git remote add origin "$URL"; fi
case "$1" in
  pull) git pull --rebase origin main ;;
  push) git push origin main ;;
  *)    echo "origin ready -> $REPO (main). Commands: house_sync.sh pull | push (commit first)." ;;
esac
