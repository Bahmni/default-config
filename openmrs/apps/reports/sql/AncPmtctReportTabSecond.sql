select   concat(coalesce(given_name,''),' ', coalesce(middle_name,'') ,' ',coalesce(family_name,'') ) as 'Full Names',
concat('(Follow up status)  wt(kg)',"\n",'------------',"\n",'(TB Status)  CD4/Vl') as 'Month of Starting PMTCT',
concat(cd4month16,"\n",'------',"\n",weightMonth16) as '16', concat(cd4month17,"\n",'------',"\n",weightMonth17) as '17', 
concat(cd4month18,"\n",'------',"\n",weightMonth18) as '18',
concat(cd4month19,"\n",'------',"\n",weightMonth19) as '19', concat(cd4month20,"\n",'------',"\n",weightMonth20) as '20',
concat(cd4month21,"\n",'------',"\n",weightMonth21) as '21',concat(cd4month22,"\n",'------',"\n",weightMonth22) as '22',
concat(cd4month23,"\n",'------',"\n",weightMonth23) as '23',concat(cd4month24,"\n",'------',"\n",weightMonth24) as '24',
concat(cd4month25,"\n",'------',"\n",weightMonth25) as '25',concat(cd4month26,"\n",'------',"\n",weightMonth26) as '26',
concat(cd4month27,"\n",'------',"\n",weightMonth27) as '27',concat(cd4month28,"\n",'------',"\n",weightMonth28) as '28',
concat(cd4month29,"\n",'------',"\n",weightMonth29) as '29',concat(cd4month30,"\n",'------',"\n",weightMonth30) as '30',
concat(cd4month31,"\n",'------',"\n",weightMonth31) as '31',concat(cd4month32,"\n",'------',"\n",weightMonth32) as '32',
concat(cd4month33,"\n",'------',"\n",weightMonth33) as '33',concat(cd4month34,"\n",'------',"\n",weightMonth34) as '34',
concat(cd4month35,"\n",'------',"\n",weightMonth35) as '35',concat(cd4month36,"\n",'------',"\n",weightMonth36) as '36',
concat(cd4month37,"\n",'------',"\n",weightMonth37) as '37',concat(cd4month38,"\n",'------',"\n",weightMonth38) as '38'
 from (
select given_name, middle_name,family_name, tpersonDemographics.personid, cd4month0,cd4month16,cd4month17,cd4month18 ,cd4month19 ,cd4month20 ,cd4month21 ,cd4month22,cd4month23,cd4month24,cd4month25,cd4month26,
cd4month27 ,cd4month28 ,cd4month29 , cd4month30 ,cd4month31 ,cd4month32, cd4month33 ,cd4month34 ,cd4month35 ,cd4month36 ,cd4month37 , cd4month38  from (
select distinct(pn.person_id) as 'personid', pn.given_name, pn.middle_name, pn.family_name, pa.value , p.gender as 'gender' , TIMESTAMPDIFF(YEAR,birthdate,NOW()) as 'Age' from person_name pn 
left join person_attribute pa on pn.person_id = pa.person_id 
left join person p on pn.person_id = p.person_id
left join obs ob on pa.person_id = ob.person_id
where pa.person_attribute_type_id 
= (select person_attribute_type_id from person_attribute_type where name = 'UniqueArtNo') and p.gender = 'F' 
and concept_id = (select concept_id from concept_name where name = 'HIV - Entry Point' 
and concept_name_type = 'fully_specified'  ) and 
value_coded = (select concept_id from concept_name where name = 'ANC Clinic' and concept_name_type = 'fully_specified')
and ob.date_created between '#startDate#' and DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59')
)tpersonDemographics
left join(
select person_id, 
(case when date_created between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(LAST_DAY('#startDate#'),'%Y-%m-%d 23:59:59') then value_numeric else 0 end) as 'cd4month0'
from obs where  concept_id = (select concept_id from concept_name where name  = 'CD4' and concept_name_type = 'fully_specified') group by person_id
)tcd4month0 on tpersonDemographics.personid = tcd4month0.person_id
left join(
select person_id, value_numeric as 'cd4month16'
from obs where concept_id = (select concept_id from concept_name where name  = 'CD4' and concept_name_type = 'fully_specified') and date_created between DATE_ADD(DATE_FORMAT('#startDate#','%Y-%m-01'), INTERVAL 16 MONTH)  and
 DATE_ADD(DATE_FORMAT(LAST_DAY('#startDate#'),'%Y-%m-%d 23:59:59'), INTERVAL 16 MONTH)  group by person_id
 )tttcd4month16 on tpersonDemographics.personid= tttcd4month16.person_id
 left join(
select person_id, value_numeric as 'cd4month17'
from obs where concept_id = (select concept_id from concept_name where name  = 'CD4' and concept_name_type = 'fully_specified') and date_created between DATE_ADD(DATE_FORMAT('#startDate#','%Y-%m-01'), INTERVAL 17 MONTH)  and
 DATE_ADD(DATE_FORMAT(LAST_DAY('#startDate#'),'%Y-%m-%d 23:59:59'), INTERVAL 17 MONTH)  group by person_id
 )tttcd4month17 on tpersonDemographics.personid= tttcd4month17.person_id
 left join(
select person_id, value_numeric as 'cd4month18'
from obs where concept_id = (select concept_id from concept_name where name  = 'CD4' and concept_name_type = 'fully_specified') and date_created between DATE_ADD(DATE_FORMAT('#startDate#','%Y-%m-01'), INTERVAL 18 MONTH)  and
 DATE_ADD(DATE_FORMAT(LAST_DAY('#startDate#'),'%Y-%m-%d 23:59:59'), INTERVAL 18 MONTH)  group by person_id
 )tttcd4month18 on tpersonDemographics.personid= tttcd4month18.person_id
left join (
select person_id, value_numeric as 'cd4month19'
from obs where concept_id = (select concept_id from concept_name where name  = 'CD4' and concept_name_type = 'fully_specified') and date_created between DATE_ADD(DATE_FORMAT('#startDate#','%Y-%m-01'), INTERVAL 19 MONTH)  and
 DATE_ADD(DATE_FORMAT(LAST_DAY('#startDate#'),'%Y-%m-%d 23:59:59'), INTERVAL 19 MONTH)  group by person_id
)ttcd4month19 on tpersonDemographics.personid= ttcd4month19.person_id
left join (
select person_id, value_numeric as 'cd4month20'
from obs where concept_id = (select concept_id from concept_name where name  = 'CD4' and concept_name_type = 'fully_specified') and date_created between DATE_ADD(DATE_FORMAT('#startDate#','%Y-%m-01'), INTERVAL 20 MONTH)  and
 DATE_ADD(DATE_FORMAT(LAST_DAY('#startDate#'),'%Y-%m-%d 23:59:59'), INTERVAL 20 MONTH)  group by person_id
)ttcd4month20 on tpersonDemographics.personid= ttcd4month20.person_id
left join (
select person_id, value_numeric as 'cd4month21'
from obs where concept_id = (select concept_id from concept_name where name  = 'CD4' and concept_name_type = 'fully_specified') and date_created between DATE_ADD(DATE_FORMAT('#startDate#','%Y-%m-01'), INTERVAL 21 MONTH)  and
 DATE_ADD(DATE_FORMAT(LAST_DAY('#startDate#'),'%Y-%m-%d 23:59:59'), INTERVAL 21 MONTH)  group by person_id
)ttcd4month21 on tpersonDemographics.personid= ttcd4month21.person_id
left join (
select person_id, value_numeric as 'cd4month22'
from obs where concept_id = (select concept_id from concept_name where name  = 'CD4' and concept_name_type = 'fully_specified') and date_created between DATE_ADD(DATE_FORMAT('#startDate#','%Y-%m-01'), INTERVAL 22 MONTH)  and
 DATE_ADD(DATE_FORMAT(LAST_DAY('#startDate#'),'%Y-%m-%d 23:59:59'), INTERVAL 22 MONTH)  group by person_id
)ttcd4month22 on tpersonDemographics.personid= ttcd4month22.person_id
left join (
select person_id, value_numeric as 'cd4month23'
from obs where concept_id = (select concept_id from concept_name where name  = 'CD4' and concept_name_type = 'fully_specified') and date_created between DATE_ADD(DATE_FORMAT('#startDate#','%Y-%m-01'), INTERVAL 23 MONTH)  and
 DATE_ADD(DATE_FORMAT(LAST_DAY('#startDate#'),'%Y-%m-%d 23:59:59'), INTERVAL 23 MONTH)  group by person_id
)ttcd4month23 on tpersonDemographics.personid= ttcd4month23.person_id
left join (
select person_id, value_numeric as 'cd4month24'
from obs where concept_id = (select concept_id from concept_name where name  = 'CD4' and concept_name_type = 'fully_specified') and date_created between DATE_ADD(DATE_FORMAT('#startDate#','%Y-%m-01'), INTERVAL 24 MONTH)  and
 DATE_ADD(DATE_FORMAT(LAST_DAY('#startDate#'),'%Y-%m-%d 23:59:59'), INTERVAL 24 MONTH)  group by person_id
)ttcd4month24 on tpersonDemographics.personid= ttcd4month24.person_id
left join (
select person_id, value_numeric as 'cd4month25'
from obs where concept_id = (select concept_id from concept_name where name  = 'CD4' and concept_name_type = 'fully_specified') and date_created between DATE_ADD(DATE_FORMAT('#startDate#','%Y-%m-01'), INTERVAL 25 MONTH)  and
 DATE_ADD(DATE_FORMAT(LAST_DAY('#startDate#'),'%Y-%m-%d 23:59:59'), INTERVAL 25 MONTH)  group by person_id
)ttcd4month25 on tpersonDemographics.personid= ttcd4month25.person_id
left join (
select person_id, value_numeric as 'cd4month26'
from obs where concept_id = (select concept_id from concept_name where name  = 'CD4' and concept_name_type = 'fully_specified') and date_created between DATE_ADD(DATE_FORMAT('#startDate#','%Y-%m-01'), INTERVAL 26 MONTH)  and
 DATE_ADD(DATE_FORMAT(LAST_DAY('#startDate#'),'%Y-%m-%d 23:59:59'), INTERVAL 26 MONTH)  group by person_id
)ttcd4month26 on tpersonDemographics.personid= ttcd4month26.person_id
left join (
select person_id, value_numeric as 'cd4month27'
from obs where concept_id = (select concept_id from concept_name where name  = 'CD4' and concept_name_type = 'fully_specified') and date_created between DATE_ADD(DATE_FORMAT('#startDate#','%Y-%m-01'), INTERVAL 27 MONTH)  and
 DATE_ADD(DATE_FORMAT(LAST_DAY('#startDate#'),'%Y-%m-%d 23:59:59'), INTERVAL 27 MONTH)  group by person_id
)ttcd4month27 on tpersonDemographics.personid= ttcd4month27.person_id
left join (
select person_id, value_numeric as 'cd4month28'
from obs where concept_id = (select concept_id from concept_name where name  = 'CD4' and concept_name_type = 'fully_specified') and date_created between DATE_ADD(DATE_FORMAT('#startDate#','%Y-%m-01'), INTERVAL 28 MONTH)  and
 DATE_ADD(DATE_FORMAT(LAST_DAY('#startDate#'),'%Y-%m-%d 23:59:59'), INTERVAL 28 MONTH)  group by person_id
)ttcd4month28 on tpersonDemographics.personid= ttcd4month28.person_id
left join (
select person_id, value_numeric as 'cd4month29'
from obs where concept_id = (select concept_id from concept_name where name  = 'CD4' and concept_name_type = 'fully_specified') and date_created between DATE_ADD(DATE_FORMAT('#startDate#','%Y-%m-01'), INTERVAL 29 MONTH)  and
 DATE_ADD(DATE_FORMAT(LAST_DAY('#startDate#'),'%Y-%m-%d 23:59:59'), INTERVAL 29 MONTH)  group by person_id
)ttcd4month29 on tpersonDemographics.personid= ttcd4month29.person_id
left join (
select person_id, value_numeric as 'cd4month30'
from obs where concept_id = (select concept_id from concept_name where name  = 'CD4' and concept_name_type = 'fully_specified') and date_created between DATE_ADD(DATE_FORMAT('#startDate#','%Y-%m-01'), INTERVAL 30 MONTH)  and
 DATE_ADD(DATE_FORMAT(LAST_DAY('#startDate#'),'%Y-%m-%d 23:59:59'), INTERVAL 30 MONTH)  group by person_id
)ttcd4month30 on tpersonDemographics.personid= ttcd4month30.person_id
left join (
select person_id, value_numeric as 'cd4month31'
from obs where concept_id = (select concept_id from concept_name where name  = 'CD4' and concept_name_type = 'fully_specified') and date_created between DATE_ADD(DATE_FORMAT('#startDate#','%Y-%m-01'), INTERVAL 31 MONTH)  and
 DATE_ADD(DATE_FORMAT(LAST_DAY('#startDate#'),'%Y-%m-%d 23:59:59'), INTERVAL 31 MONTH)  group by person_id
)ttcd4month31 on tpersonDemographics.personid= ttcd4month31.person_id
left join (
select person_id, value_numeric as 'cd4month32'
from obs where concept_id = (select concept_id from concept_name where name  = 'CD4' and concept_name_type = 'fully_specified') and date_created between DATE_ADD(DATE_FORMAT('#startDate#','%Y-%m-01'), INTERVAL 32 MONTH)  and
 DATE_ADD(DATE_FORMAT(LAST_DAY('#startDate#'),'%Y-%m-%d 23:59:59'), INTERVAL 32 MONTH)  group by person_id
)ttcd4month32 on tpersonDemographics.personid= ttcd4month32.person_id
left join (
select person_id, value_numeric as 'cd4month33'
from obs where concept_id = (select concept_id from concept_name where name  = 'CD4' and concept_name_type = 'fully_specified') and date_created between DATE_ADD(DATE_FORMAT('#startDate#','%Y-%m-01'), INTERVAL 33 MONTH)  and
 DATE_ADD(DATE_FORMAT(LAST_DAY('#startDate#'),'%Y-%m-%d 23:59:59'), INTERVAL 33 MONTH)  group by person_id
)ttcd4month33 on tpersonDemographics.personid= ttcd4month33.person_id
left join (
select person_id, value_numeric as 'cd4month34'
from obs where concept_id = (select concept_id from concept_name where name  = 'CD4' and concept_name_type = 'fully_specified') and date_created between DATE_ADD(DATE_FORMAT('#startDate#','%Y-%m-01'), INTERVAL 34 MONTH)  and
 DATE_ADD(DATE_FORMAT(LAST_DAY('#startDate#'),'%Y-%m-%d 23:59:59'), INTERVAL 34 MONTH)  group by person_id
)ttcd4month34 on tpersonDemographics.personid= ttcd4month34.person_id
left join (
select person_id, value_numeric as 'cd4month35'
from obs where concept_id = (select concept_id from concept_name where name  = 'CD4' and concept_name_type = 'fully_specified') and date_created between DATE_ADD(DATE_FORMAT('#startDate#','%Y-%m-01'), INTERVAL 35 MONTH)  and
 DATE_ADD(DATE_FORMAT(LAST_DAY('#startDate#'),'%Y-%m-%d 23:59:59'), INTERVAL 35 MONTH)  group by person_id
)ttcd4month35 on tpersonDemographics.personid= ttcd4month35.person_id
left join (
select person_id, value_numeric as 'cd4month36'
from obs where concept_id = (select concept_id from concept_name where name  = 'CD4' and concept_name_type = 'fully_specified') and date_created between DATE_ADD(DATE_FORMAT('#startDate#','%Y-%m-01'), INTERVAL 36 MONTH)  and
 DATE_ADD(DATE_FORMAT(LAST_DAY('#startDate#'),'%Y-%m-%d 23:59:59'), INTERVAL 36 MONTH)  group by person_id
)ttcd4month36 on tpersonDemographics.personid= ttcd4month36.person_id
left join (
select person_id, value_numeric as 'cd4month37'
from obs where concept_id = (select concept_id from concept_name where name  = 'CD4' and concept_name_type = 'fully_specified') and date_created between DATE_ADD(DATE_FORMAT('#startDate#','%Y-%m-01'), INTERVAL 37 MONTH)  and
 DATE_ADD(DATE_FORMAT(LAST_DAY('#startDate#'),'%Y-%m-%d 23:59:59'), INTERVAL 37 MONTH)  group by person_id
)ttcd4month37 on tpersonDemographics.personid= ttcd4month37.person_id
left join (
select person_id, value_numeric as 'cd4month38'
from obs where concept_id = (select concept_id from concept_name where name  = 'CD4' and concept_name_type = 'fully_specified') and date_created between DATE_ADD(DATE_FORMAT('#startDate#','%Y-%m-01'), INTERVAL 38 MONTH)  and
 DATE_ADD(DATE_FORMAT(LAST_DAY('#startDate#'),'%Y-%m-%d 23:59:59'), INTERVAL 38 MONTH)  group by person_id
)ttcd4month38 on tpersonDemographics.personid= ttcd4month38.person_id
)tcd4
left join (
select * from (
select tPersonDemographicscd415.personid , weightMonth0,weightMonth16,weightMonth17,weightMonth18 ,weightMonth19 ,weightMonth20 ,weightMonth21 ,weightMonth22,weightMonth23,weightMonth24,weightMonth25,weightMonth26,
weightMonth27 ,weightMonth28 ,weightMonth29,weightMonth30 ,weightMonth31 ,weightMonth32,weightMonth33 ,weightMonth34 ,weightMonth35,weightMonth36 ,weightMonth37 ,weightMonth38  from (
select distinct(pn.person_id) as 'personid', pn.given_name, pn.middle_name, pn.family_name, pa.value , p.gender as 'gender' , TIMESTAMPDIFF(YEAR,birthdate,NOW()) as 'Age' from person_name pn 
left join person_attribute pa on pn.person_id = pa.person_id 
left join person p on pn.person_id = p.person_id
left join obs ob on pa.person_id = ob.person_id
where pa.person_attribute_type_id 
= (select person_attribute_type_id from person_attribute_type where name = 'UniqueArtNo') and p.gender = 'F' 
and concept_id = (select concept_id from concept_name where name = 'HIV - Entry Point' 
and concept_name_type = 'fully_specified'  ) and 
value_coded = (select concept_id from concept_name where name = 'ANC Clinic' and concept_name_type = 'fully_specified')
and ob.date_created between '#startDate#' and DATE_FORMAT(('#endDate#'),'%Y-%m-%d 23:59:59')
)tPersonDemographicscd415
left join(
select person_id, 
(case when date_created between DATE_FORMAT('#startDate#','%Y-%m-01') and DATE_FORMAT(LAST_DAY('#startDate#'),'%Y-%m-%d 23:59:59') then value_numeric else 0 end) as 'weightMonth0'
from obs where  concept_id = (select concept_id from concept_name where name  = 'weight' and concept_name_type = 'fully_specified') group by person_id
)tweight0 on tPersonDemographicscd415.personid = tweight0.person_id
left join (
select person_id, value_numeric as 'weightMonth16'
from obs where concept_id = (select concept_id from concept_name where name  = 'weight' and concept_name_type = 'fully_specified') and date_created between DATE_ADD(DATE_FORMAT('#startDate#','%Y-%m-01'), INTERVAL 16 MONTH)  and
 DATE_ADD(DATE_FORMAT(LAST_DAY('#startDate#'),'%Y-%m-%d 23:59:59'), INTERVAL 16 MONTH)  group by person_id
)ttweight16 on tPersonDemographicscd415.personid = ttweight16.person_id
left join (
select person_id, value_numeric as 'weightMonth17'
from obs where concept_id = (select concept_id from concept_name where name  = 'weight' and concept_name_type = 'fully_specified') and date_created between DATE_ADD(DATE_FORMAT('#startDate#','%Y-%m-01'), INTERVAL 17 MONTH)  and
 DATE_ADD(DATE_FORMAT(LAST_DAY('#startDate#'),'%Y-%m-%d 23:59:59'), INTERVAL 17 MONTH)  group by person_id
)ttweight17 on tPersonDemographicscd415.personid = ttweight17.person_id
left join (
select person_id, value_numeric as 'weightMonth18'
from obs where concept_id = (select concept_id from concept_name where name  = 'weight' and concept_name_type = 'fully_specified') and date_created between DATE_ADD(DATE_FORMAT('#startDate#','%Y-%m-01'), INTERVAL 18 MONTH)  and
 DATE_ADD(DATE_FORMAT(LAST_DAY('#startDate#'),'%Y-%m-%d 23:59:59'), INTERVAL 18 MONTH)  group by person_id
)ttweight18 on tPersonDemographicscd415.personid = ttweight18.person_id
left join(
select person_id, value_numeric as 'weightMonth19'
from obs where concept_id = (select concept_id from concept_name where name  = 'weight' and concept_name_type = 'fully_specified') and date_created between DATE_ADD(DATE_FORMAT('#startDate#','%Y-%m-01'), INTERVAL 19 MONTH)  and
 DATE_ADD(DATE_FORMAT(LAST_DAY('#startDate#'),'%Y-%m-%d 23:59:59'), INTERVAL 19 MONTH)  group by person_id
)ttweight19 on tPersonDemographicscd415.personid = ttweight19.person_id
left join (
select person_id, value_numeric as 'weightMonth20'
from obs where concept_id = (select concept_id from concept_name where name  = 'weight' and concept_name_type = 'fully_specified') and date_created between DATE_ADD(DATE_FORMAT('#startDate#','%Y-%m-01'), INTERVAL 20 MONTH)  and
 DATE_ADD(DATE_FORMAT(LAST_DAY('#startDate#'),'%Y-%m-%d 23:59:59'), INTERVAL 20 MONTH)  group by person_id
)ttweight20 on tPersonDemographicscd415.personid = ttweight20.person_id
left join (
select person_id, value_numeric as 'weightMonth21'
from obs where concept_id = (select concept_id from concept_name where name  = 'weight' and concept_name_type = 'fully_specified') and date_created between DATE_ADD(DATE_FORMAT('#startDate#','%Y-%m-01'), INTERVAL 21 MONTH)  and
 DATE_ADD(DATE_FORMAT(LAST_DAY('#startDate#'),'%Y-%m-%d 23:59:59'), INTERVAL 21 MONTH)  group by person_id
)ttweight21 on tPersonDemographicscd415.personid = ttweight21.person_id
left join (
select person_id, value_numeric as 'weightMonth22'
from obs where concept_id = (select concept_id from concept_name where name  = 'weight' and concept_name_type = 'fully_specified') and date_created between DATE_ADD(DATE_FORMAT('#startDate#','%Y-%m-01'), INTERVAL 22 MONTH)  and
 DATE_ADD(DATE_FORMAT(LAST_DAY('#startDate#'),'%Y-%m-%d 23:59:59'), INTERVAL 22 MONTH)  group by person_id
)ttweight22 on tPersonDemographicscd415.personid = ttweight22.person_id
left join (
select person_id, value_numeric as 'weightMonth23'
from obs where concept_id = (select concept_id from concept_name where name  = 'weight' and concept_name_type = 'fully_specified') and date_created between DATE_ADD(DATE_FORMAT('#startDate#','%Y-%m-01'), INTERVAL 23 MONTH)  and
 DATE_ADD(DATE_FORMAT(LAST_DAY('#startDate#'),'%Y-%m-%d 23:59:59'), INTERVAL 23 MONTH)  group by person_id
)ttweight23 on tPersonDemographicscd415.personid = ttweight23.person_id
left join (
select person_id, value_numeric as 'weightMonth24'
from obs where concept_id = (select concept_id from concept_name where name  = 'weight' and concept_name_type = 'fully_specified') and date_created between DATE_ADD(DATE_FORMAT('#startDate#','%Y-%m-01'), INTERVAL 24 MONTH)  and
 DATE_ADD(DATE_FORMAT(LAST_DAY('#startDate#'),'%Y-%m-%d 23:59:59'), INTERVAL 24 MONTH)  group by person_id
)ttweight24 on tPersonDemographicscd415.personid = ttweight24.person_id
left join (
select person_id, value_numeric as 'weightMonth25'
from obs where concept_id = (select concept_id from concept_name where name  = 'weight' and concept_name_type = 'fully_specified') and date_created between DATE_ADD(DATE_FORMAT('#startDate#','%Y-%m-01'), INTERVAL 25 MONTH)  and
 DATE_ADD(DATE_FORMAT(LAST_DAY('#startDate#'),'%Y-%m-%d 23:59:59'), INTERVAL 25 MONTH)  group by person_id
)ttweight25 on tPersonDemographicscd415.personid = ttweight25.person_id
left join (
select person_id, value_numeric as 'weightMonth26'
from obs where concept_id = (select concept_id from concept_name where name  = 'weight' and concept_name_type = 'fully_specified') and date_created between DATE_ADD(DATE_FORMAT('#startDate#','%Y-%m-01'), INTERVAL 26 MONTH)  and
 DATE_ADD(DATE_FORMAT(LAST_DAY('#startDate#'),'%Y-%m-%d 23:59:59'), INTERVAL 26 MONTH)  group by person_id
)ttweight26 on tPersonDemographicscd415.personid = ttweight26.person_id
left join (
select person_id, value_numeric as 'weightMonth27'
from obs where concept_id = (select concept_id from concept_name where name  = 'weight' and concept_name_type = 'fully_specified') and date_created between DATE_ADD(DATE_FORMAT('#startDate#','%Y-%m-01'), INTERVAL 27 MONTH)  and
 DATE_ADD(DATE_FORMAT(LAST_DAY('#startDate#'),'%Y-%m-%d 23:59:59'), INTERVAL 27 MONTH)  group by person_id
)ttweight27 on tPersonDemographicscd415.personid = ttweight27.person_id
left join (
select person_id, value_numeric as 'weightMonth28'
from obs where concept_id = (select concept_id from concept_name where name  = 'weight' and concept_name_type = 'fully_specified') and date_created between DATE_ADD(DATE_FORMAT('#startDate#','%Y-%m-01'), INTERVAL 28 MONTH)  and
 DATE_ADD(DATE_FORMAT(LAST_DAY('#startDate#'),'%Y-%m-%d 23:59:59'), INTERVAL 28 MONTH)  group by person_id
)ttweight28 on tPersonDemographicscd415.personid = ttweight28.person_id
left join (
select person_id, value_numeric as 'weightMonth29'
from obs where concept_id = (select concept_id from concept_name where name  = 'weight' and concept_name_type = 'fully_specified') and date_created between DATE_ADD(DATE_FORMAT('#startDate#','%Y-%m-01'), INTERVAL 29 MONTH)  and
 DATE_ADD(DATE_FORMAT(LAST_DAY('#startDate#'),'%Y-%m-%d 23:59:59'), INTERVAL 29 MONTH)  group by person_id
)ttweight29 on tPersonDemographicscd415.personid = ttweight29.person_id
left join (
select person_id, value_numeric as 'weightMonth30'
from obs where concept_id = (select concept_id from concept_name where name  = 'weight' and concept_name_type = 'fully_specified') and date_created between DATE_ADD(DATE_FORMAT('#startDate#','%Y-%m-01'), INTERVAL 30 MONTH)  and
 DATE_ADD(DATE_FORMAT(LAST_DAY('#startDate#'),'%Y-%m-%d 23:59:59'), INTERVAL 30 MONTH)  group by person_id
)ttweight30 on tPersonDemographicscd415.personid = ttweight30.person_id
left join (
select person_id, value_numeric as 'weightMonth31'
from obs where concept_id = (select concept_id from concept_name where name  = 'weight' and concept_name_type = 'fully_specified') and date_created between DATE_ADD(DATE_FORMAT('#startDate#','%Y-%m-01'), INTERVAL 31 MONTH)  and
 DATE_ADD(DATE_FORMAT(LAST_DAY('#startDate#'),'%Y-%m-%d 23:59:59'), INTERVAL 31 MONTH)  group by person_id
)ttweight31 on tPersonDemographicscd415.personid = ttweight31.person_id
left join (
select person_id, value_numeric as 'weightMonth32'
from obs where concept_id = (select concept_id from concept_name where name  = 'weight' and concept_name_type = 'fully_specified') and date_created between DATE_ADD(DATE_FORMAT('#startDate#','%Y-%m-01'), INTERVAL 32 MONTH)  and
 DATE_ADD(DATE_FORMAT(LAST_DAY('#startDate#'),'%Y-%m-%d 23:59:59'), INTERVAL 32 MONTH)  group by person_id
)ttweight32 on tPersonDemographicscd415.personid = ttweight32.person_id
left join (
select person_id, value_numeric as 'weightMonth33'
from obs where concept_id = (select concept_id from concept_name where name  = 'weight' and concept_name_type = 'fully_specified') and date_created between DATE_ADD(DATE_FORMAT('#startDate#','%Y-%m-01'), INTERVAL 33 MONTH)  and
 DATE_ADD(DATE_FORMAT(LAST_DAY('#startDate#'),'%Y-%m-%d 23:59:59'), INTERVAL 33 MONTH)  group by person_id
)ttweight33 on tPersonDemographicscd415.personid = ttweight33.person_id
left join (
select person_id, value_numeric as 'weightMonth34'
from obs where concept_id = (select concept_id from concept_name where name  = 'weight' and concept_name_type = 'fully_specified') and date_created between DATE_ADD(DATE_FORMAT('#startDate#','%Y-%m-01'), INTERVAL 34 MONTH)  and
 DATE_ADD(DATE_FORMAT(LAST_DAY('#startDate#'),'%Y-%m-%d 23:59:59'), INTERVAL 34 MONTH)  group by person_id
)ttweight34 on tPersonDemographicscd415.personid = ttweight34.person_id
left join (
select person_id, value_numeric as 'weightMonth35'
from obs where concept_id = (select concept_id from concept_name where name  = 'weight' and concept_name_type = 'fully_specified') and date_created between DATE_ADD(DATE_FORMAT('#startDate#','%Y-%m-01'), INTERVAL 35 MONTH)  and
 DATE_ADD(DATE_FORMAT(LAST_DAY('#startDate#'),'%Y-%m-%d 23:59:59'), INTERVAL 35 MONTH)  group by person_id
)ttweight35 on tPersonDemographicscd415.personid = ttweight35.person_id
left join (
select person_id, value_numeric as 'weightMonth36'
from obs where concept_id = (select concept_id from concept_name where name  = 'weight' and concept_name_type = 'fully_specified') and date_created between DATE_ADD(DATE_FORMAT('#startDate#','%Y-%m-01'), INTERVAL 36 MONTH)  and
 DATE_ADD(DATE_FORMAT(LAST_DAY('#startDate#'),'%Y-%m-%d 23:59:59'), INTERVAL 36 MONTH)  group by person_id
)ttweight36 on tPersonDemographicscd415.personid = ttweight36.person_id
left join (
select person_id, value_numeric as 'weightMonth37'
from obs where concept_id = (select concept_id from concept_name where name  = 'weight' and concept_name_type = 'fully_specified') and date_created between DATE_ADD(DATE_FORMAT('#startDate#','%Y-%m-01'), INTERVAL 37 MONTH)  and
 DATE_ADD(DATE_FORMAT(LAST_DAY('#startDate#'),'%Y-%m-%d 23:59:59'), INTERVAL 37 MONTH)  group by person_id
)ttweight37 on tPersonDemographicscd415.personid = ttweight37.person_id
left join (
select person_id, value_numeric as 'weightMonth38'
from obs where concept_id = (select concept_id from concept_name where name  = 'weight' and concept_name_type = 'fully_specified') and date_created between DATE_ADD(DATE_FORMAT('#startDate#','%Y-%m-01'), INTERVAL 38 MONTH)  and
 DATE_ADD(DATE_FORMAT(LAST_DAY('#startDate#'),'%Y-%m-%d 23:59:59'), INTERVAL 38 MONTH)  group by person_id
)ttweight38 on tPersonDemographicscd415.personid = ttweight38.person_id
)t15weight
)tcd4weight15 on tcd4.personid = tcd4weight15.personid
