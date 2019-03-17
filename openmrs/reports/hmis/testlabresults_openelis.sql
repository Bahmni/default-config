SELECT DISTINCT
  t.name        AS test,
  count(r.id)   AS total_count
FROM test_section ts
  INNER JOIN test t ON ts.id = t.test_section_id AND t.is_active = 'Y'
  LEFT OUTER JOIN analysis a ON t.id = a.test_id
  LEFT OUTER JOIN result r ON a.id = r.analysis_id and cast(r.lastupdated as date) BETWEEN '2016-04-04' and '2016-04-04' and r.value != ''
  LEFT OUTER JOIN result r1 ON r1.result_type = 'D' and r1.value != '' and r.id=r1.id and r1.abnormal=true
  LEFT OUTER JOIN result r2 on r2.result_type = 'D' and r2.value != '' and r.id=r2.id and r2.abnormal=false
GROUP BY t.name,t.id
order by t.name;
