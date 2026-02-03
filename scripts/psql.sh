#!/usr/bin/env bash
set -euo pipefail

# Convenience wrapper for local dev. Uses docker compose service.
docker compose exec -it postgres psql -U supportdesk -d supportdesk
