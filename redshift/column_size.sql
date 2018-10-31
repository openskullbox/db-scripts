SELECT DATABASE,
       SCHEMA,
       TRIM(name) AS table_name,
       TRIM(pg_attribute.attname) AS column_name,
       COUNT(1) AS size
FROM svv_diskusage
  JOIN pg_attribute
    ON svv_diskusage.col = pg_attribute.attnum -1
   AND svv_diskusage.tbl = pg_attribute.attrelid
  JOIN svv_table_info ON svv_diskusage.tbl = svv_table_info.table_id
GROUP BY 1,
         2,
         3,
         4
ORDER BY 5 DESC;