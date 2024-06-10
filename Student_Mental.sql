-- Create Database
CREATE DATABASE mental;

USE mental;
-- Tables
SELECT * FROM studentmental;
ALTER TABLE `mental`.`studentmental` 
RENAME TO  `mental`.`student_mh` ;
-- Tables
SELECT * FROM student_mh;
-- Data Cleaning
# Data types
describe student_mh;

# change of column names

alter table student_mh
rename column `Choose your gender` to gender,
rename column `What is your course?` to course,
rename column `Your current year of Study` to study_year,
rename column `What is your CGPA?` to CGPA,
rename column `Marital status` to married,
rename column `Do you have Depression?` to depressed,
rename column `Do you have Anxiety?` to anxiety,
rename column `Do you have Panic attack?` to panic_attacks,
rename column `Did you seek any specialist for a treatment?` to lfor_treatment;


# data formatting

alter table student_mh
add column timestamp_f timestamp;

update student_mh
set timestamp_f = str_to_date(Timestamp, '%d/%m/%Y %H:%i:%s');

alter table student_mh
add column grade float;

update student_mh
set grade = (substring_index(CGPA, ' - ', 1) + substring_index(CGPA, ' - ', -1)) / 2;




alter table student_mh
add column study_year_f int;

update student_mh
set study_year_f = (substring_index(study_year, ' ', -1));



# glimpse at what profession interviewers studying

select distinct course
from student_mh;

# adding new column

alter table student_mh
add column faculty varchar(50);

UPDATE student_mh
SET faculty = 'RCEP'
WHERE course IN ('KIRKHS', 'Irkhs', 'Islamic education','Pendidikan islam', 'Human Resources', 'Psychology', 'Usuluddin ', 'Malcom', 'Human Sciences ', 'Communication ', 'Pendidikan Islam ');

UPDATE student_mh
SET faculty = 'IT'
WHERE course IN ('BIT', 'BCS', 'IT', 'CTS');

UPDATE student_mh
SET faculty = 'Law'
WHERE course IN ('Laws', 'Law', 'Fiqh fatwa ', 'Fiqh');

UPDATE student_mh
SET faculty = 'Faculty of Medicine'
WHERE course IN ('Biomedical science', 'MHSC', 'Kop', 'Biotechnology', 'Diploma Nursing', 'Radiography', 'Nursing ');

UPDATE student_mh
SET faculty = 'Economics and Management'
WHERE course IN ('Mathemathics', 'KENMS', 'Accounting ', 'Banking Studies', 'Business Administration', 'Econs');

UPDATE student_mh
SET faculty = 'Environment'
WHERE course IN ('ENM', 'Marine science');

UPDATE student_mh
SET faculty = 'Linguistics'
WHERE course IN ('TAASL', 'BENL', 'DIPLOMA TESL');

UPDATE student_mh
SET faculty = 'Art'
WHERE course IN ('ALA');

UPDATE student_mh
SET faculty = 'Engineering'
WHERE course IN ('KOE', 'Engine', 'engin', 'Engineering');

select course, faculty
from student_mh
where faculty is null; 

describe student_mh;

alter table student_mh
drop column Timestamp;

alter table student_mh
drop column study_year;

alter table student_mh
drop column CGPA;

# Count interviewed by faculty

select faculty, count(*) as count
from student_mh
group by faculty
order by count desc;

# Depression factor among faculties

select faculty, depressed, count(*) as count
from student_mh
group by faculty, depressed
order by count desc;

# depressed by year of study and faculty

select study_year_f, faculty, depressed, count(*) as count
from student_mh
group by faculty, study_year_f, depressed
order by study_year_f,count desc;

# depression, grades and year of study 

select depressed, study_year_f, avg(grade) over (partition by study_year_f) as year_cgpa, count(*) as count
from student_mh
group by depressed, study_year_f, grade, study_year_f
order by study_year_f, depressed;

# average grades, average grades among those, who are depressed and not

select
  (select avg(grade) from student_mh) as total_cgpa,
  (select avg(grade) from student_mh where depressed = 'Yes') as total_avg_cgpa_depressed,
  (select avg(grade) from student_mh where depressed = 'No') as total_avg_cgpa_not_depressed;
  
  # grades of those, who are depressed, but looking or having mental treatment

with cte as (
    select lfor_treatment, avg(grade) as cgpa_avg
    from student_mh
    where depressed = 'Yes'
    group by lfor_treatment
)
select cgpa_avg
from cte
where lfor_treatment = 'Yes'
group by lfor_treatment;

# depression amd marital status

select married, depressed, count(*)
from student_mh
group by married, depressed
order by married;

# grades by marital status divided by depressed ones and who are not. 

select married, depressed, avg(grade), count(*)
from student_mh
group by married, depressed;
# psychological and mental challenges by gender

select gender,
    count(case when depressed = 'Yes' then 1 end) as  dep,
    count(case when anxiety = 'Yes' then 1 end)   as  anx,
    count(case when panic_attacks = 'Yes' then 1 end) pa
from student_mh
group by gender;

# grades by those, who have panick attacks, anxiety and depression vs those, who don't have any of it

select
    (select avg(grade) from student_mh where panic_attacks = 'Yes' and anxiety = 'Yes' and depressed = 'Yes') as depanpa_yes,
    (select avg(grade) from student_mh where panic_attacks = 'No'and anxiety = 'No' and depressed = 'No') as depanpa_no;
    # average age vs average age who are depressed and who are not

select
    (select avg(Age) from student_mh where Age is not null) as avg_age,
    (select avg(Age) from student_mh where depressed = 'Yes' and Age is not null) as avg_dep_age,
    (select avg(Age) from student_mh where depressed = 'No' and Age is not null) as avg_notdep_age;
    # age and depression

select Age, depressed, count(*) as count
from student_mh
where Age is not null
group by Age, depressed
order by Age, count desc;
select * from student_mh;