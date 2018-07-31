WITH q1 AS
(
  SELECT c.oid,
         nspname AS table_schema,
         relname AS TABLE_NAME,
         c.reltuples AS row_estimate,
         pg_total_relation_size(c.oid) AS total_bytes,
         pg_indexes_size(c.oid) AS index_bytes,
         pg_total_relation_size(reltoastrelid) AS toast_bytes
  FROM pg_class c
    LEFT JOIN pg_namespace n ON n.oid = c.relnamespace
  WHERE relkind = 'r'
),
q2 AS
(
  SELECT q1.*,
         total_bytes - index_bytes -COALESCE(toast_bytes,0) AS table_bytes
  FROM q1
),
res AS
(
  SELECT q2.*,
         pg_size_pretty(total_bytes) AS total,
         pg_size_pretty(index_bytes) AS INDEX,
         pg_size_pretty(toast_bytes) AS toast,
         pg_size_pretty(table_bytes) AS TABLE
  FROM q2
  WHERE table_schema NOT IN ('pg_catalog','information_schema')
)
SELECT *
FROM res
ORDER BY table_bytes DESC

