WITH tabledef as (
    SELECT schemaname,
        't' AS typename,
        tablename AS objectname,
        tableowner as owner,
        schemaname + '.' + tablename AS fullname
    FROM pg_tables
    UNION 
    SELECT schemaname,
        'v' AS typename,
        viewname AS objectname,
        viewowner as owner,
        schemaname + '.' + viewname AS fullname
    FROM pg_views
),
res AS (
    SELECT t.*,
    CASE HAS_TABLE_PRIVILEGE(u.usename, t.fullname, 'select')
    WHEN true THEN u.usename
    ELSE NULL END AS sel,
    CASE HAS_TABLE_PRIVILEGE(u.usename, t.fullname, 'insert')
    WHEN true THEN u.usename
    ELSE NULL END AS ins,
    CASE HAS_TABLE_PRIVILEGE(u.usename, t.fullname, 'update')
    WHEN true THEN u.usename
    ELSE NULL END AS upd,
    CASE HAS_TABLE_PRIVILEGE(u.usename, t.fullname, 'delete')
    WHEN true THEN u.usename
    ELSE NULL END AS del,
    CASE HAS_TABLE_PRIVILEGE(u.usename, t.fullname, 'references')
    WHEN true THEN u.usename
    ELSE NULL END AS ref
    FROM tabledef AS t
    JOIN pg_user AS u
    ON HAS_TABLE_PRIVILEGE(u.usename, t.fullname, 'select') = true
        OR HAS_TABLE_PRIVILEGE(u.usename, t.fullname, 'insert') = true
        OR HAS_TABLE_PRIVILEGE(u.usename, t.fullname, 'update') = true
        OR HAS_TABLE_PRIVILEGE(u.usename, t.fullname, 'delete') = true
        OR HAS_TABLE_PRIVILEGE(u.usename, t.fullname, 'references') = true
        OR t.owner = u.usename
    WHERE t.schemaname in ('<schema>')
)
SELECT schemaname, objectname, owner, sel, ins, upd, del, ref FROM res
WHERE sel not in ('<super_user_list>')
AND objectname = '<table_name>'
ORDER BY schemaname, objectname;