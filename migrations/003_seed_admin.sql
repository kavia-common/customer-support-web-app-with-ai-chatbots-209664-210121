BEGIN;

-- DEV/DEMO ONLY:
-- This creates an initial admin user:
--   email: admin@example.com
--   password: admin
--
-- IMPORTANT:
-- Replace password_hash with a proper bcrypt/argon2 hash from your backend in production.
-- The placeholder hash below is NOT secure; it's only to allow a minimal end-to-end demo DB bootstrap.
--
-- Suggested: have backend seed via API and store a real hash.
WITH admin_role AS (
  SELECT id FROM roles WHERE name = 'admin'
)
INSERT INTO users (email, password_hash, role_id, is_active)
SELECT
  'admin@example.com',
  '$2b$12$uQWcFv9G8kN5qQwqQwqQwOZ5j8z8o1yQ1u2s3d4f5g6h7i8j9k0l.'::text,
  admin_role.id,
  TRUE
FROM admin_role
ON CONFLICT (email) DO NOTHING;

COMMIT;
