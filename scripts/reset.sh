#!/usr/bin/env bash
set -euo pipefail

# DANGEROUS: resets the schema in the local dev database.
# This is intended ONLY for local development.

docker compose exec -T postgres psql -U supportdesk -d supportdesk -v ON_ERROR_STOP=1 -c "
DO \$\$ DECLARE
  r RECORD;
BEGIN
  -- Drop tables first
  FOR r IN (SELECT tablename FROM pg_tables WHERE schemaname = 'public') LOOP
    EXECUTE 'DROP TABLE IF EXISTS ' || quote_ident(r.tablename) || ' CASCADE';
  END LOOP;

  -- Drop types (enums)
  IF EXISTS (SELECT 1 FROM pg_type WHERE typname = 'ticket_status') THEN
    EXECUTE 'DROP TYPE ticket_status';
  END IF;
  IF EXISTS (SELECT 1 FROM pg_type WHERE typname = 'ticket_priority') THEN
    EXECUTE 'DROP TYPE ticket_priority';
  END IF;
  IF EXISTS (SELECT 1 FROM pg_type WHERE typname = 'chat_author') THEN
    EXECUTE 'DROP TYPE chat_author';
  END IF;
  IF EXISTS (SELECT 1 FROM pg_type WHERE typname = 'notification_status') THEN
    EXECUTE 'DROP TYPE notification_status';
  END IF;

  -- Drop function
  IF EXISTS (SELECT 1 FROM pg_proc WHERE proname = 'set_updated_at') THEN
    EXECUTE 'DROP FUNCTION set_updated_at()';
  END IF;
END \$\$;
"

echo "Reset complete."
