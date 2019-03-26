select 
  current_time, 
  c.relname, 
  l.database, 
  l.transaction, 
  l.pid, 
  a.usename, 
  l.mode, 
  l.granted
from pg_locks l 
join pg_catalog.pg_class c ON c.oid = l.relation
join pg_catalog.pg_stat_activity a ON a.procpid = l.pid
where l.pid <> pg_backend_pid();