SET @start_date = "2014-09-01";
SET @end_date = "2014-09-04";
SET @sql = NULL;

select  GROUP_CONCAT(DISTINCT
       CONCAT(
         'MAX(IF(cn.name = ''', name, ''', obs.value_numeric, NULL)) AS ''', name, '''')
     ) INTO @sql
   from obs 
   join concept_name as cn on cn.concept_id = obs.concept_id and cn.name in ('WEIGHT', 'HEIGHT');


SET @sql = CONCAT('SELECT concat(pn.given_name, " ", pn.family_name), obs.obs_datetime, ', @sql, ' 
   FROM person_name pn
   LEFT JOIN obs AS obs ON obs.person_id = pn.person_id
   left join concept_name cn on obs.concept_id = cn.concept_id and date(obs.obs_datetime) >=''', @start_date, ''' and date(obs.obs_datetime) <= ''', @end_date, ''' 
   where obs.value_numeric is not null
   GROUP BY cn.name, obs.obs_datetime order by obs.obs_datetime');


PREPARE stmt FROM @sql;
EXECUTE stmt;