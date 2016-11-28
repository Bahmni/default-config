Select b.ip, b.name, b.age, b.gender, b.vdc, b.ward, b.diagnosis, b.first_diag_date,
if (b.first_diag_date <date('2015-03-15'), CHA1271, if (b.first_diag_date < date('2015-04-14'),'New','N/A')) as CHA1271,
if (b.first_diag_date <date('2015-04-14'), BAI0172, if (b.first_diag_date < date('2015-05-15'),'New','N/A'))            as BAI0172,
if (b.first_diag_date <date('2015-05-15'), JES0272, if (b.first_diag_date < date('2015-06-16'),'New','N/A'))            as JES0272,
if (b.first_diag_date <date('2015-06-16'), ASA0372, if (b.first_diag_date < date('2015-07-16'),'New','N/A'))            as ASA0372,
if (b.first_diag_date <date('2015-07-16'), SAU0472, if (b.first_diag_date < date('2015-08-18'),'New','N/A'))            as SAU0472,
if (b.first_diag_date <date('2015-08-18'), BHA0572, if (b.first_diag_date < date('2015-09-18'),'New','N/A'))            as BHA0572,
if (b.first_diag_date <date('2015-09-18'), ASO0672, if (b.first_diag_date < date('2015-10-18'),'New','N/A'))            as ASO0672,
if (b.first_diag_date <date('2015-10-18'), KAR0772, if (b.first_diag_date < date('2015-11-17'),'New','N/A'))            as KAR0772,
if (b.first_diag_date <date('2015-11-17'), MAN0872, if (b.first_diag_date < date('2015-12-16'),'New','N/A'))            as MAN0872,
if (b.first_diag_date <date('2015-12-16'), PUS0972, if (b.first_diag_date < date('2016-01-15'),'New','N/A'))            as PUS0972,
if (b.first_diag_date <date('2016-01-15'), MAG1072, if (b.first_diag_date < date('2016-02-13'),'New','N/A'))            as MAG1072,
if (b.first_diag_date <date('2016-02-13'), FAG1172, if (b.first_diag_date < date('2016-03-14'),'New','N/A'))            as FAG1172,
if (b.first_diag_date <date('2016-03-14'), CHA1272, if (b.first_diag_date < date('2016-04-13'),'New','N/A')) as CHA1272,
if (b.first_diag_date <date('2016-04-13'), BAI0173, if (b.first_diag_date < date('2016-05-14'),'New','N/A')) as BAI0173,
if (b.first_diag_date <date('2016-05-14'), JES0273, if (b.first_diag_date < date('2016-06-15'),'New','N/A')) as JES0273,
if (b.first_diag_date <date('2016-06-15'), ASA0373, if (b.first_diag_date < date('2016-07-16'),'New','N/A')) as ASA0373
From (
Select ip, name, age, gender, vdc, ward, group_concat(distinct diag SEPARATOR ', ') as diagnosis, min(date(diag_date)) as first_diag_date,
COALESCE(SUM(CHA1271),0) as CHA1271,
COALESCE(SUM(BAI0172),0) as BAI0172,
COALESCE(SUM(JES0272),0) as JES0272,
COALESCE(SUM(ASA0372),0) as ASA0372,
COALESCE(SUM(SAU0472),0) as SAU0472,
COALESCE(SUM(BHA0572),0) as BHA0572,
COALESCE(SUM(ASO0672),0) as ASO0672,
COALESCE(SUM(KAR0772),0) as KAR0772,
COALESCE(SUM(MAN0872),0) as MAN0872,
COALESCE(SUM(PUS0972),0) as PUS0972,
COALESCE(SUM(MAG1072),0) as MAG1072,
COALESCE(SUM(FAG1172),0) as FAG1172,
COALESCE(SUM(CHA1272),0) as CHA1272,
COALESCE(SUM(BAI0173),0) as BAI0173,
COALESCE(SUM(JES0273),0) as JES0273,
COALESCE(SUM(ASA0373),0) as ASA0373
from
(
SELECT
    pi.identifier AS 'IP',
    CONCAT_WS(' ', pn.given_name, pn.middle_name, pn.family_name) as 'Name',
	TIMESTAMPDIFF(YEAR,p.birthdate,CURDATE()) AS age,
    p.gender,
    pa.city_village as 'VDC',
    pa.address1 as 'Ward',
    pa.county_district as 'District', v.visit_id,
    (select name from concept_name where concept_id = o.value_coded and concept_name_type = 'FULLY_SPECIFIED' and voided = '0') as Diag,
    o.obs_datetime as 'Diag_date',
	case when date(v.date_started) between '2015-03-15' and '2015-04-13' then 1 end as 'CHA1271' ,
  case when date(v.date_started) between '2015-04-14' and '2015-05-14' then 1 end as 'BAI0172' ,
  case when date(v.date_started) between '2015-05-15' and '2015-06-15' then 1 end as 'JES0272' ,
  case when date(v.date_started) between '2015-06-16' and '2015-07-16' then 1 end as 'ASA0372' ,
  case when date(v.date_started) between '2015-07-16' and '2015-08-17' then 1 end as 'SAU0472' ,
  case when date(v.date_started) between '2015-08-18' and '2015-09-17' then 1 end as 'BHA0572' ,
  case when date(v.date_started) between '2015-09-18' and '2015-10-17' then 1 end as 'ASO0672' ,
  case when date(v.date_started) between '2015-10-18' and '2015-11-16' then 1 end as 'KAR0772' ,
  case when date(v.date_started) between '2015-11-17' and '2015-12-15' then 1 end as 'MAN0872' ,
  case when date(v.date_started) between '2015-12-16' and '2016-01-14' then 1 end as 'PUS0972' ,
  case when date(v.date_started) between '2016-01-15' and '2016-02-12' then 1 end as 'MAG1072' ,
  case when date(v.date_started) between '2016-02-13' and '2016-03-13' then 1 end as 'FAG1172' ,
  case when date(v.date_started) between '2016-03-14' and '2016-04-12' then 1 end as 'CHA1272' ,
  case when date(v.date_started) between '2016-04-13' and '2016-05-13' then 1 end as 'BAI0173' ,
  case when date(v.date_started) between '2016-05-14' and '2016-06-14' then 1 end as 'JES0273' ,
  case when date(v.date_started) between '2016-06-15' and '2016-07-15' then 1 end as 'ASA0373'
FROM
   person p
        INNER JOIN
    patient_identifier pi ON p.person_id = pi.patient_id
        AND pi.identifier != 'BAH200052'
        AND pi.voided = '0'
          AND pi.preferred = 1
        INNER JOIN
    person_name pn ON pn.person_id = p.person_id
        AND pn.voided = '0'
        INNER JOIN
    person_address pa ON pa.person_id = pn.person_id
    AND pa.voided = '0'
    INNER JOIN
    visit v ON v.patient_id = p.person_id
    LEFT JOIN
    obs o ON o.person_id = p.person_id
    and o.voided = '0'
    and o.concept_id = '15' AND o.value_coded in ('5526', '5716', '5650', '5654', '2596', '5672', '5658', '4059', '3787', '5511', '2622', '5620')
where p.voided = '0'
and date(v.date_started) between '2015-03-15' and CURDATE()
and p.person_id in (SELECT person_id FROM obs WHERE concept_id = '15' AND value_coded in ('5526', '5716', '5650', '5654', '2596', '5672', '5658', '4059', '3787', '5511', '2622', '5620') AND voided = '0')
and pa.county_district = 'Achham'
and pa.city_village in ('Baijanath','Baradadevi','Bhagyashwari','Chandika','Gajara','Hattikot','Jalapadevi','Janalikot','Lungra','Mastamandaun','Nawathana','Payal','Ridikot','Siddheshwar','Sanfebagar Municipality','Sanfebagar')
group by IP, Name, age, gender, VDC, Ward, District, Diag, visit_id
) a
group by a.ip, a.name, a.age, a.gender, a.vdc, a.ward
) b
group by b.ip, b.name, b.age, b.gender, b.vdc, b.ward, b.diagnosis
ORDER BY b.vdc, b.ward, b.name ASC;