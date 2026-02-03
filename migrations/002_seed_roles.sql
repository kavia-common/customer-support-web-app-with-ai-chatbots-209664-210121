BEGIN;

INSERT INTO roles (name, description)
VALUES
  ('customer', 'End user submitting support requests'),
  ('agent', 'Support agent handling tickets'),
  ('admin', 'Administrator with elevated permissions')
ON CONFLICT (name) DO NOTHING;

COMMIT;
