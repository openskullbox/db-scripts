WITH locks AS
(
  SELECT DISTINCT pid, relation, granted FROM pg_locks
)
SELECT a.txn_owner,
       a.txn_db,
       a.xid,
       a.pid,
       a.txn_start,
       a.lock_mode,
       a.relation AS table_id,
       nvl(TRIM(c."name"),d.relname) AS tablename,
       a.granted,
       b.pid AS blocking_pid,
       datediff(s,a.txn_start,getdate ()) / 86400 || ' d ' ||datediff(s,a.txn_start,getdate ()) % 86400 / 3600 || ' h ' ||datediff(s,a.txn_start,getdate ()) % 3600 / 60 || ' m ' ||datediff(s,a.txn_start,getdate ()) % 60 || ' s' AS txn_duration
FROM svv_transactions a
  LEFT JOIN locks b
         ON a.relation = b.relation
        AND a.granted = 'f'
        AND b.granted = 't'
  LEFT JOIN stv_tbl_perm c
         ON a.relation = c.id
        AND c.slice = 0
  LEFT JOIN pg_class d ON a.relation = d.oid
WHERE a.relation IS NOT NULL

