SELECT
  nspname AS schema,
  conrelid::regclass AS table_from,
  conname,
  pg_get_constraintdef(c.oid)
FROM
  pg_constraint c
    JOIN pg_namespace n
         ON n.oid = c.connamespace
