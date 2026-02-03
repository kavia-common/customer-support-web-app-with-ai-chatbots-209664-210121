# Cloud Database (PostgreSQL)

This repository contains the **Cloud Database** container for the Customer Support web app.

It provides:
- A normalized PostgreSQL schema for:
  - users/roles
  - auth sessions/tokens
  - tickets + comments
  - chat messages
  - attachments metadata
  - notifications
  - audit logs
- SQL migrations (ordered, idempotent for clean DBs)
- Seed data (baseline roles + an initial admin user)
- Local dev setup via Docker Compose

---

## Quick start (local dev)

Prereqs:
- Docker + Docker Compose

Start a local Postgres:
```bash
docker compose up -d
```

Run migrations:
```bash
./scripts/migrate.sh
```

Seed baseline data (roles + admin user):
```bash
./scripts/seed.sh
```

Connect with psql:
```bash
./scripts/psql.sh
```

Reset everything (DANGEROUS: drops schema objects):
```bash
./scripts/reset.sh
./scripts/migrate.sh
./scripts/seed.sh
```

---

## Configuration

Local dev uses Docker Compose defaults in `docker-compose.yml`:
- Host: `localhost`
- Port: `5432`
- Database: `supportdesk`
- User: `supportdesk`
- Password: `supportdesk`

If you need to change these, update `docker-compose.yml` and the scripts in `scripts/`.

---

## Schema overview (high level)

### Auth / RBAC
- `roles`: canonical roles (`customer`, `agent`, `admin`)
- `users`: email + password hash + role
- `sessions`: login sessions / bearer tokens (hashed token storage), expiration, revoke

### Tickets
- `tickets`: requester, optional assignee, status/priority, AI summary
- `ticket_comments`: threaded comments per ticket

### Chat
- `chat_messages`: real-time chat transcript; optionally linked to a ticket

### Attachments
- `attachments`: metadata only (storage handled elsewhere); can attach to tickets/comments/chat messages

### Notifications
- `notifications`: in-app notifications (delivery status and read tracking)

### Audit
- `audit_logs`: append-only audit events for key actions

---

## Migrations

Migrations live in `migrations/` and are applied in lexical order.

- `001_init.sql` creates extensions, enums, tables, constraints, and indexes.
- `002_seed_roles.sql` inserts baseline roles.
- `003_seed_admin.sql` inserts an initial admin user (email/password configurable in the SQL file; change before production).

---

## Notes for production

- Replace seeded admin credentials with a secure provisioning flow.
- Consider enabling row-level security policies if using Postgres directly from client apps (not recommended here).
- Ensure backups, PITR, and encryption are enabled in your managed Postgres service.
- If you use a real token system (JWT), you may store sessions for refresh tokens / revocation lists; this schema supports that.
