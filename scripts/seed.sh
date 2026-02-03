#!/usr/bin/env bash
set -euo pipefail

# Seed data by running the seed migrations explicitly (idempotent).
docker compose exec -T postgres psql -U supportdesk -d supportdesk -v ON_ERROR_STOP=1 -f "migrations/002_seed_roles.sql"
docker compose exec -T postgres psql -U supportdesk -d supportdesk -v ON_ERROR_STOP=1 -f "migrations/003_seed_admin.sql"

echo "Seed complete."
