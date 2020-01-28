select  concat(coalesce(given_name,''),' ', coalesce(middle_name,'') ,' ',coalesce(family_name,'') ) as 'Full Names', concat('(Follow up status)',"\n",'     -----------',"\n",'(TB Status)') as 'Month of Starting PMTCT' ,
concat(cd4month0,"\n",'------',"\n",weightMonth0) as '0',
concat(cd4month1,"\n",'------',"\n",weightMonth1) as '1', concat(cd4month2,"\n",'------',"\n",weightMonth2) as '2', 
concat('(Follow up status)  wt(kg)',"\n",'----------',"\n",'(TB Status)  CD4/Vl') as 'Month',
concat(cd4month3,"\n",'------',"\n",weightMonth3) as '3',
concat(cd4month4,"\n",'------',"\n",weightMonth4) as '4', concat(cd4month5,"\n",'------',"\n",weightMonth5) as '5',
concat(cd4month6,"\n",'------',"\n",weightMonth6) as '6',concat(cd4month7,"\n",'------',"\n",weightMonth7) as '7',
concat(cd4month8,"\n",'------',"\n",weightMonth8) as '8',concat(cd4month9,"\n",'------',"\n",weightMonth9) as '9',
concat(cd4month10,"\n",'------',"\n",weightMonth10) as '10',concat(cd4month11,"\n",'------',"\n",weightMonth11) as '11',
concat(cd4month12,"\n",'------',"\n",weightMonth12) as '12',concat(cd4month13,"\n",'------',"\n",weightMonth13) as '13',
concat(cd4month14,"\n",'------',"\n",weightMonth14) as '14',concat(cd4month15,"\n",'------',"\n",weightMonth15) as '15'
 from (
select given_name, middle_name,family_name, tpersonDemographics.personid, cd4month0,cd4month1,cd4month2,cd4month3,cd4month4 ,cd4month5 ,cd4month6 ,cd4month7 ,cd4month8,cd4month9,cd4month10,cd4month11,cd4month12,
cd4month13 ,cd4month14 ,cd4month15 from (
select distinct(pn.person_id) as 'personid', pn.given_name, pn.middle_name, pn.family_name, pa.value , p.gender as 'gender' , TIMESTAMPDIFF(YEAR,birthdate,NOW()) as 'Age' from person_name pn 
left join person_attribute pa on pn.person_id = pa.person_id 
left join person p on pn.person_id = p.person_id
left join obs ob on pa.person_id = ob.person_id
where pa.person_attribute_type_id 
= (select person_attribute_type_id from person_attribute_type where name = 'UniqueArtNo') and p.gender = 'F' 
and concept_id = (select concept_id from concept_name where name = 'HIV - Entry Point' 
and concept_name_type = 'fully_specified'  ) and 
value_coded = (select concept_id from concept_name where name = 'ANC Clinic' and concept_name_type = 'fully_specified')
and ob.date_created between '#startDate#' and '#endDate#'
)tpersonDemographics
left join(
select person_id, 
(case when date_created between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(LAST_DAY('#startDate#'),'%Y-%m-%d 23:59:59') then value_numeric else 0 end) as 'cd4month0'
from obs where  concept_id = (select concept_id from concept_name where name  = 'CD4' and concept_name_type = 'fully_specified') group by person_id
)tcd4month0 on tpersonDemographics.personid = tcd4month0.person_id
left join(
select person_id, value_numeric as 'cd4month1'
from obs where concept_id = (select concept_id from concept_name where name  = 'CD4' and concept_name_type = 'fully_specified') and date_created between DATE_ADD(DATE_FORMAT('#startDate#','%Y-%m-01'), INTERVAL 1 MONTH)  and
 DATE_ADD(DATE_FORMAT(LAST_DAY('#startDate#'),'%Y-%m-%d 23:59:59'), INTERVAL 1 MONTH)  group by person_id
 )tttcd4month1 on tpersonDemographics.personid= tttcd4month1.person_id
 left join(
select person_id, value_numeric as 'cd4month2'
from obs where concept_id = (select concept_id from concept_name where name  = 'CD4' and concept_name_type = 'fully_specified') and date_created between DATE_ADD(DATE_FORMAT('#startDate#','%Y-%m-01'), INTERVAL 2 MONTH)  and
 DATE_ADD(DATE_FORMAT(LAST_DAY('#startDate#'),'%Y-%m-%d 23:59:59'), INTERVAL 2 MONTH)  group by person_id
 )tttcd4month2 on tpersonDemographics.personid= tttcd4month2.person_id
 left join(
select person_id, value_numeric as 'cd4month3'
from obs where concept_id = (select concept_id from concept_name where name  = 'CD4' and concept_name_type = 'fully_specified') and date_created between DATE_ADD(DATE_FORMAT('#startDate#','%Y-%m-01'), INTERVAL 3 MONTH)  and
 DATE_ADD(DATE_FORMAT(LAST_DAY('#startDate#'),'%Y-%m-%d 23:59:59'), INTERVAL 3 MONTH)  group by person_id
 )tttcd4month3 on tpersonDemographics.personid= tttcd4month3.person_id
left join (
select person_id, value_numeric as 'cd4month4'
from obs where concept_id = (select concept_id from concept_name where name  = 'CD4' and concept_name_type = 'fully_specified') and date_created between DATE_ADD(DATE_FORMAT('#startDate#','%Y-%m-01'), INTERVAL 4 MONTH)  and
 DATE_ADD(DATE_FORMAT(LAST_DAY('#startDate#'),'%Y-%m-%d 23:59:59'), INTERVAL 4 MONTH)  group by person_id
)ttcd4month4 on tpersonDemographics.personid= ttcd4month4.person_id
left join (
select person_id, value_numeric as 'cd4month5'
from obs where concept_id = (select concept_id from concept_name where name  = 'CD4' and concept_name_type = 'fully_specified') and date_created between DATE_ADD(DATE_FORMAT('#startDate#','%Y-%m-01'), INTERVAL 5 MONTH)  and
 DATE_ADD(DATE_FORMAT(LAST_DAY('#startDate#'),'%Y-%m-%d 23:59:59'), INTERVAL 5 MONTH)  group by person_id
)ttcd4month5 on tpersonDemographics.personid= ttcd4month5.person_id
left join (
select person_id, value_numeric as 'cd4month6'
from obs where concept_id = (select concept_id from concept_name where name  = 'CD4' and concept_name_type = 'fully_specified') and date_created between DATE_ADD(DATE_FORMAT('#startDate#','%Y-%m-01'), INTERVAL 6 MONTH)  and
 DATE_ADD(DATE_FORMAT(LAST_DAY('#startDate#'),'%Y-%m-%d 23:59:59'), INTERVAL 6 MONTH)  group by person_id
)ttcd4month6 on tpersonDemographics.personid= ttcd4month6.person_id
left join (
select person_id, value_numeric as 'cd4month7'
from obs where concept_id = (select concept_id from concept_name where name  = 'CD4' and concept_name_type = 'fully_specified') and date_created between DATE_ADD(DATE_FORMAT('#startDate#','%Y-%m-01'), INTERVAL 7 MONTH)  and
 DATE_ADD(DATE_FORMAT(LAST_DAY('#startDate#'),'%Y-%m-%d 23:59:59'), INTERVAL 7 MONTH)  group by person_id
)ttcd4month7 on tpersonDemographics.personid= ttcd4month7.person_id
left join (
select person_id, value_numeric as 'cd4month8'
from obs where concept_id = (select concept_id from concept_name where name  = 'CD4' and concept_name_type = 'fully_specified') and date_created between DATE_ADD(DATE_FORMAT('#startDate#','%Y-%m-01'), INTERVAL 8 MONTH)  and
 DATE_ADD(DATE_FORMAT(LAST_DAY('#startDate#'),'%Y-%m-%d 23:59:59'), INTERVAL 8 MONTH)  group by person_id
)ttcd4month8 on tpersonDemographics.personid= ttcd4month8.person_id
left join (
select person_id, value_numeric as 'cd4month9'
from obs where concept_id = (select concept_id from concept_name where name  = 'CD4' and concept_name_type = 'fully_specified') and date_created between DATE_ADD(DATE_FORMAT('#startDate#','%Y-%m-01'), INTERVAL 9 MONTH)  and
 DATE_ADD(DATE_FORMAT(LAST_DAY('#startDate#'),'%Y-%m-%d 23:59:59'), INTERVAL 9 MONTH)  group by person_id
)ttcd4month9 on tpersonDemographics.personid= ttcd4month9.person_id
left join (
select person_id, value_numeric as 'cd4month10'
from obs where concept_id = (select concept_id from concept_name where name  = 'CD4' and concept_name_type = 'fully_specified') and date_created between DATE_ADD(DATE_FORMAT('#startDate#','%Y-%m-01'), INTERVAL 10 MONTH)  and
 DATE_ADD(DATE_FORMAT(LAST_DAY('#startDate#'),'%Y-%m-%d 23:59:59'), INTERVAL 10 MONTH)  group by person_id
)ttcd4month10 on tpersonDemographics.personid= ttcd4month10.person_id
left join (
select person_id, value_numeric as 'cd4month11'
from obs where concept_id = (select concept_id from concept_name where name  = 'CD4' and concept_name_type = 'fully_specified') and date_created between DATE_ADD(DATE_FORMAT('#startDate#','%Y-%m-01'), INTERVAL 11 MONTH)  and
 DATE_ADD(DATE_FORMAT(LAST_DAY('#startDate#'),'%Y-%m-%d 23:59:59'), INTERVAL 11 MONTH)  group by person_id
)ttcd4month11 on tpersonDemographics.personid= ttcd4month11.person_id
left join (
select person_id, value_numeric as 'cd4month12'
from obs where concept_id = (select concept_id from concept_name where name  = 'CD4' and concept_name_type = 'fully_specified') and date_created between DATE_ADD(DATE_FORMAT('#startDate#','%Y-%m-01'), INTERVAL 12 MONTH)  and
 DATE_ADD(DATE_FORMAT(LAST_DAY('#startDate#'),'%Y-%m-%d 23:59:59'), INTERVAL 12 MONTH)  group by person_id
)ttcd4month12 on tpersonDemographics.personid= ttcd4month12.person_id
left join (
select person_id, value_numeric as 'cd4month13'
from obs where concept_id = (select concept_id from concept_name where name  = 'CD4' and concept_name_type = 'fully_specified') and date_created between DATE_ADD(DATE_FORMAT('#startDate#','%Y-%m-01'), INTERVAL 13 MONTH)  and
 DATE_ADD(DATE_FORMAT(LAST_DAY('#startDate#'),'%Y-%m-%d 23:59:59'), INTERVAL 13 MONTH)  group by person_id
)ttcd4month13 on tpersonDemographics.personid= ttcd4month13.person_id
left join (
select person_id, value_numeric as 'cd4month14'
from obs where concept_id = (select concept_id from concept_name where name  = 'CD4' and concept_name_type = 'fully_specified') and date_created between DATE_ADD(DATE_FORMAT('#startDate#','%Y-%m-01'), INTERVAL 14 MONTH)  and
 DATE_ADD(DATE_FORMAT(LAST_DAY('#startDate#'),'%Y-%m-%d 23:59:59'), INTERVAL 14 MONTH)  group by person_id
)ttcd4month14 on tpersonDemographics.personid= ttcd4month14.person_id
left join (
select person_id, value_numeric as 'cd4month15'
from obs where concept_id = (select concept_id from concept_name where name  = 'CD4' and concept_name_type = 'fully_specified') and date_created between DATE_ADD(DATE_FORMAT('#startDate#','%Y-%m-01'), INTERVAL 15 MONTH)  and
 DATE_ADD(DATE_FORMAT(LAST_DAY('#startDate#'),'%Y-%m-%d 23:59:59'), INTERVAL 15 MONTH)  group by person_id
)ttcd4month15 on tpersonDemographics.personid= ttcd4month15.person_id
)tcd4
left join (
select * from (
select tPersonDemographicscd415.personid , weightMonth0,weightMonth1,weightMonth2,weightMonth3,weightMonth4 ,weightMonth5 ,weightMonth6 ,weightMonth7 ,weightMonth8,weightMonth9,weightMonth10,weightMonth11,weightMonth12,
weightMonth13 ,weightMonth14 ,weightMonth15 from (
select distinct(pn.person_id) as 'personid', pn.given_name, pn.middle_name, pn.family_name, pa.value , p.gender as 'gender' , TIMESTAMPDIFF(YEAR,birthdate,NOW()) as 'Age' from person_name pn 
left join person_attribute pa on pn.person_id = pa.person_id 
left join person p on pn.person_id = p.person_id
left join obs ob on pa.person_id = ob.person_id
where pa.person_attribute_type_id 
= (select person_attribute_type_id from person_attribute_type where name = 'UniqueArtNo') and p.gender = 'F' 
and concept_id = (select concept_id from concept_name where name = 'HIV - Entry Point' 
and concept_name_type = 'fully_specified'  ) and 
value_coded = (select concept_id from concept_name where name = 'ANC Clinic' and concept_name_type = 'fully_specified')
and ob.date_created between '#startDate#' and '#endDate#'
)tPersonDemographicscd415
left join(
select person_id, 
(case when date_created between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(LAST_DAY('#startDate#'),'%Y-%m-%d 23:59:59') then value_numeric else 0 end) as 'weightMonth0'
from obs where  concept_id = (select concept_id from concept_name where name  = 'weight' and concept_name_type = 'fully_specified') group by person_id
)tweight0 on tPersonDemographicscd415.personid = tweight0.person_id
left join (
select person_id, value_numeric as 'weightMonth1'
from obs where concept_id = (select concept_id from concept_name where name  = 'weight' and concept_name_type = 'fully_specified') and date_created between DATE_ADD(DATE_FORMAT('#startDate#','%Y-%m-01'), INTERVAL 1 MONTH)  and
 DATE_ADD(DATE_FORMAT(LAST_DAY('#startDate#'),'%Y-%m-%d 23:59:59'), INTERVAL 1 MONTH)  group by person_id
)ttweight1 on tPersonDemographicscd415.personid = ttweight1.person_id
left join (
select person_id, value_numeric as 'weightMonth2'
from obs where concept_id = (select concept_id from concept_name where name  = 'weight' and concept_name_type = 'fully_specified') and date_created between DATE_ADD(DATE_FORMAT('#startDate#','%Y-%m-01'), INTERVAL 2 MONTH)  and
 DATE_ADD(DATE_FORMAT(LAST_DAY('#startDate#'),'%Y-%m-%d 23:59:59'), INTERVAL 2 MONTH)  group by person_id
)ttweight2 on tPersonDemographicscd415.personid = ttweight2.person_id
left join (
select person_id, value_numeric as 'weightMonth3'
from obs where concept_id = (select concept_id from concept_name where name  = 'weight' and concept_name_type = 'fully_specified') and date_created between DATE_ADD(DATE_FORMAT('#startDate#','%Y-%m-01'), INTERVAL 3 MONTH)  and
 DATE_ADD(DATE_FORMAT(LAST_DAY('#startDate#'),'%Y-%m-%d 23:59:59'), INTERVAL 3 MONTH)  group by person_id
)ttweight3 on tPersonDemographicscd415.personid = ttweight3.person_id
left join(
select person_id, value_numeric as 'weightMonth4'
from obs where concept_id = (select concept_id from concept_name where name  = 'weight' and concept_name_type = 'fully_specified') and date_created between DATE_ADD(DATE_FORMAT('#startDate#','%Y-%m-01'), INTERVAL 4 MONTH)  and
 DATE_ADD(DATE_FORMAT(LAST_DAY('#startDate#'),'%Y-%m-%d 23:59:59'), INTERVAL 4 MONTH)  group by person_id
)ttweight4 on tPersonDemographicscd415.personid = ttweight4.person_id
left join (
select person_id, value_numeric as 'weightMonth5'
from obs where concept_id = (select concept_id from concept_name where name  = 'weight' and concept_name_type = 'fully_specified') and date_created between DATE_ADD(DATE_FORMAT('#startDate#','%Y-%m-01'), INTERVAL 5 MONTH)  and
 DATE_ADD(DATE_FORMAT(LAST_DAY('#startDate#'),'%Y-%m-%d 23:59:59'), INTERVAL 5 MONTH)  group by person_id
)ttweight5 on tPersonDemographicscd415.personid = ttweight5.person_id
left join (
select person_id, value_numeric as 'weightMonth6'
from obs where concept_id = (select concept_id from concept_name where name  = 'weight' and concept_name_type = 'fully_specified') and date_created between DATE_ADD(DATE_FORMAT('#startDate#','%Y-%m-01'), INTERVAL 6 MONTH)  and
 DATE_ADD(DATE_FORMAT(LAST_DAY('#startDate#'),'%Y-%m-%d 23:59:59'), INTERVAL 6 MONTH)  group by person_id
)ttweight6 on tPersonDemographicscd415.personid = ttweight6.person_id
left join (
select person_id, value_numeric as 'weightMonth7'
from obs where concept_id = (select concept_id from concept_name where name  = 'weight' and concept_name_type = 'fully_specified') and date_created between DATE_ADD(DATE_FORMAT('#startDate#','%Y-%m-01'), INTERVAL 7 MONTH)  and
 DATE_ADD(DATE_FORMAT(LAST_DAY('#startDate#'),'%Y-%m-%d 23:59:59'), INTERVAL 7 MONTH)  group by person_id
)ttweight7 on tPersonDemographicscd415.personid = ttweight7.person_id
left join (
select person_id, value_numeric as 'weightMonth8'
from obs where concept_id = (select concept_id from concept_name where name  = 'weight' and concept_name_type = 'fully_specified') and date_created between DATE_ADD(DATE_FORMAT('#startDate#','%Y-%m-01'), INTERVAL 8 MONTH)  and
 DATE_ADD(DATE_FORMAT(LAST_DAY('#startDate#'),'%Y-%m-%d 23:59:59'), INTERVAL 8 MONTH)  group by person_id
)ttweight8 on tPersonDemographicscd415.personid = ttweight8.person_id
left join (
select person_id, value_numeric as 'weightMonth9'
from obs where concept_id = (select concept_id from concept_name where name  = 'weight' and concept_name_type = 'fully_specified') and date_created between DATE_ADD(DATE_FORMAT('#startDate#','%Y-%m-01'), INTERVAL 9 MONTH)  and
 DATE_ADD(DATE_FORMAT(LAST_DAY('#startDate#'),'%Y-%m-%d 23:59:59'), INTERVAL 9 MONTH)  group by person_id
)ttweight9 on tPersonDemographicscd415.personid = ttweight9.person_id
left join (
select person_id, value_numeric as 'weightMonth10'
from obs where concept_id = (select concept_id from concept_name where name  = 'weight' and concept_name_type = 'fully_specified') and date_created between DATE_ADD(DATE_FORMAT('#startDate#','%Y-%m-01'), INTERVAL 10 MONTH)  and
 DATE_ADD(DATE_FORMAT(LAST_DAY('#startDate#'),'%Y-%m-%d 23:59:59'), INTERVAL 10 MONTH)  group by person_id
)ttweight10 on tPersonDemographicscd415.personid = ttweight10.person_id
left join (
select person_id, value_numeric as 'weightMonth11'
from obs where concept_id = (select concept_id from concept_name where name  = 'weight' and concept_name_type = 'fully_specified') and date_created between DATE_ADD(DATE_FORMAT('#startDate#','%Y-%m-01'), INTERVAL 11 MONTH)  and
 DATE_ADD(DATE_FORMAT(LAST_DAY('#startDate#'),'%Y-%m-%d 23:59:59'), INTERVAL 11 MONTH)  group by person_id
)ttweight11 on tPersonDemographicscd415.personid = ttweight11.person_id
left join (
select person_id, value_numeric as 'weightMonth12'
from obs where concept_id = (select concept_id from concept_name where name  = 'weight' and concept_name_type = 'fully_specified') and date_created between DATE_ADD(DATE_FORMAT('#startDate#','%Y-%m-01'), INTERVAL 12 MONTH)  and
 DATE_ADD(DATE_FORMAT(LAST_DAY('#startDate#'),'%Y-%m-%d 23:59:59'), INTERVAL 12 MONTH)  group by person_id
)ttweight12 on tPersonDemographicscd415.personid = ttweight12.person_id
left join (
select person_id, value_numeric as 'weightMonth13'
from obs where concept_id = (select concept_id from concept_name where name  = 'weight' and concept_name_type = 'fully_specified') and date_created between DATE_ADD(DATE_FORMAT('#startDate#','%Y-%m-01'), INTERVAL 13 MONTH)  and
 DATE_ADD(DATE_FORMAT(LAST_DAY('#startDate#'),'%Y-%m-%d 23:59:59'), INTERVAL 13 MONTH)  group by person_id
)ttweight13 on tPersonDemographicscd415.personid = ttweight13.person_id
left join (
select person_id, value_numeric as 'weightMonth14'
from obs where concept_id = (select concept_id from concept_name where name  = 'weight' and concept_name_type = 'fully_specified') and date_created between DATE_ADD(DATE_FORMAT('#startDate#','%Y-%m-01'), INTERVAL 14 MONTH)  and
 DATE_ADD(DATE_FORMAT(LAST_DAY('#startDate#'),'%Y-%m-%d 23:59:59'), INTERVAL 14 MONTH)  group by person_id
)ttweight14 on tPersonDemographicscd415.personid = ttweight14.person_id
left join (
select person_id, value_numeric as 'weightMonth15'
from obs where concept_id = (select concept_id from concept_name where name  = 'weight' and concept_name_type = 'fully_specified') and date_created between DATE_ADD(DATE_FORMAT('#startDate#','%Y-%m-01'), INTERVAL 15 MONTH)  and
 DATE_ADD(DATE_FORMAT(LAST_DAY('#startDate#'),'%Y-%m-%d 23:59:59'), INTERVAL 15 MONTH)  group by person_id
)ttweight15 on tPersonDemographicscd415.personid = ttweight15.person_id
)t15weight
)tcd4weight15 on tcd4.personid = tcd4weight15.personid
