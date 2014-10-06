select count(*) from coded_obs_view where concept_name = 'Chief Complaint';
select count(*) from text_obs_view where concept_name = 'Non-Coded Chief Complaint';

-- All chief complaint answers
select count(*) from concept_answer_view where question_concept_name = 'Chief Complaint Answers';

-- Top coded chief complaints
select value 'Chief Complaints', count(value) Total from coded_obs_view where concept_name = 'Chief Complaint' group by value order by total desc;

-- Top non-coded chief complaints
select value 'Chief Complaints', count(value) Total from text_obs_view where concept_name = 'Non-Coded Chief Complaint' group by value order by total desc limit 50;

-- Chief complaints never used
select answer_concept_name
from concept_answer_view
where question_concept_name = 'Chief Complaint Answers'
and answer_concept_id not in
  (select distinct answer_concept_id from coded_obs_view where concept_name = 'Chief Complaint');