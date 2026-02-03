#!/usr/bin/env bash
set -euo pipefail

# Apply all migrations in lexical order.
# Uses docker compose exec to run psql inside the postgres container.

echo "Applying migrations..."
for f in migrations/*.sql; do
  echo " - $f"
  docker compose exec -T postgres psql -U supportdesk -d supportdesk -v ON_ERROR_STOP=1 -f "$f"
done

echo "Migrations complete."
