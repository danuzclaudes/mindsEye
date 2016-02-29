-- Execute this sql file by `psql -d mindseye -f ./conf/evolutions/default/mindseye-devel.sql`
-- `truncate medication; delete from visit where patient_id=15; select * from visit; select * from medication;`
-- drop database mindseye;
-- create database mindseye;
select datname from pg_database where datname='mindseye';

DO
$body$
BEGIN
    IF NOT EXISTS (
        SELECT * FROM pg_roles where rolname='mindseye') THEN
    create role mindseye with NOCREATEDB CREATEROLE CREATEUSER LOGIN PASSWORD 'changeme';
    END IF;
END
$body$;
select rolname from pg_roles where rolname='mindseye';

-- drop table if exists visit;
create table IF NOT EXISTS visit (
    -- md5 hashes for visit id
    visit_id varchar(32) not null,
    patient_id integer not null,
    visit_date date not null default CURRENT_DATE,
    cgi_score integer not null,
    visit_group integer DEFAULT 0,
    visit_notes text,
    primary key (visit_id, visit_date)
);
\d visit

-- drop table if exists medication;
create table IF NOT EXISTS medication (
    med_id serial PRIMARY KEY,
    med_name varchar(32) not null,
    -- start date of this drug should be related to most recent start date
    med_start_date date not null,
    med_end_date date,
    med_group varchar(5) not null,
    prescribed_on_visit varchar(32) not null
    -- doctor_name varchar(32) not null,
);
\d medication

insert into visit (visit_id, patient_id, visit_date, cgi_score, visit_notes) values
('84f22a76e57ab37dde3af8ec5e21f670', 15, TO_DATE('1/10/2011', 'MM/DD/YYYY'), 7,
'<b>SILS</b> educates innovative and responsible thinkers who will lead the \\n
 information professions; discovers principles and impacts of information; \\n
 creates systems, techniques, and policies to advance information processes \\n
 and services; and advances information creation, access, use, management, \\n
 and stewardship to improve the quality of life for diverse local, national, and global communities.'
);
insert into medication (med_id, med_name, med_start_date, med_end_date, med_group, prescribed_on_visit) values
(1, 'BUPR', TO_DATE('1/12/2011', 'MM/DD/YYYY'), NULL, 'BUP', '84f22a76e57ab37dde3af8ec5e21f670');

insert into visit (visit_id, patient_id, visit_date, cgi_score, visit_notes) values
(md5(CURRENT_TIMESTAMP :: TEXT), 15, TO_DATE('1/12/2011', 'MM/DD/YYYY'), 7,
'Ms. Bingham is a 24 year old woman who complains of worsening sore throat \\n
since yesterday morning. She has never had a similar problem in the past. \\n
She has no difficulty swallowing, but notes that swallowing makes the pain worse. \\n
Nothing makes it better. There is no SOB or sensation of choking or dysphagia. \\n
\n\nFHx: father with HTN<br>FHx: married with 2 children, No ETOH or drugs, monogamous with husband'
);

insert into visit (visit_id, patient_id, visit_date, cgi_score, visit_notes) values
(md5(CURRENT_TIMESTAMP :: TEXT), 15, TO_DATE('3/9/2011', 'MM/DD/YYYY'), 7,
'Ms. Bingham is a 24 year old woman who complains of worsening sore throat \\n
since yesterday morning. She has never had a similar problem in the past. \\n
She has no difficulty swallowing, but notes that swallowing makes the pain worse. \\n
Nothing makes it better. There is no SOB or sensation of choking or dysphagia.'
);

insert into visit (visit_id, patient_id, visit_date, cgi_score, visit_notes) values
(md5(CURRENT_TIMESTAMP :: TEXT), 15, TO_DATE('1/5/2011', 'MM/DD/YYYY'), 2,
'Ms. Bingham is a 24 year old woman who complains of worsening sore throat \\n
\n\nFHx: father with HTN<br>FHx: married with 2 children, No ETOH or drugs, monogamous with husband');

insert into visit (visit_id, patient_id, visit_date, cgi_score, visit_notes) values
(md5(CURRENT_TIMESTAMP :: TEXT), 15, TO_DATE('5/11/2011', 'MM/DD/YYYY'), 7,
'She has no difficulty swallowing, but notes that swallowing makes the pain worse. \\n
Nothing makes it better. There is no SOB or sensation of choking or dysphagia. \\n
\n\nFHx: father with HTN<br>FHx: married with 2 children, No ETOH or drugs, monogamous with husband');

insert into visit (visit_id, patient_id, visit_date, cgi_score, visit_notes) values
(md5(CURRENT_TIMESTAMP :: TEXT), 15, TO_DATE('6/29/2011', 'MM/DD/YYYY'), 5, 'Notes for patient # 15');

insert into visit (visit_id, patient_id, visit_date, cgi_score, visit_notes) values
(md5(CURRENT_TIMESTAMP :: TEXT), 15, TO_DATE('6/15/2011', 'MM/DD/YYYY'), 7, 'Notes for patient # 15');

insert into visit (visit_id, patient_id, visit_date, cgi_score, visit_notes) values
(md5(CURRENT_TIMESTAMP :: TEXT), 15, TO_DATE('3/30/2011', 'MM/DD/YYYY'), 7, 'Notes for patient # 15');

insert into visit (visit_id, patient_id, visit_date, cgi_score, visit_notes) values
(md5(CURRENT_TIMESTAMP :: TEXT), 15, TO_DATE('5/4/2011', 'MM/DD/YYYY'), 7, 'Notes for patient # 15');

insert into visit (visit_id, patient_id, visit_date, cgi_score, visit_notes) values
(md5(CURRENT_TIMESTAMP :: TEXT), 15, TO_DATE('2/9/2011', 'MM/DD/YYYY'), 7, 'Notes for patient # 15');

insert into visit (visit_id, patient_id, visit_date, cgi_score, visit_notes) values
(md5(CURRENT_TIMESTAMP :: TEXT), 15, TO_DATE('7/25/2011', 'MM/DD/YYYY'), 7, 'Notes for patient # 15');

insert into visit (visit_id, patient_id, visit_date, cgi_score, visit_notes) values
(md5(CURRENT_TIMESTAMP :: TEXT), 15, TO_DATE('8/1/2011', 'MM/DD/YYYY'), 7, 'Notes for patient # 15');

insert into visit (visit_id, patient_id, visit_date, cgi_score, visit_notes) values
(md5(CURRENT_TIMESTAMP :: TEXT), 15, TO_DATE('4/27/2011', 'MM/DD/YYYY'), 6, 'Notes for patient # 15');

insert into visit (visit_id, patient_id, visit_date, cgi_score, visit_notes) values
(md5(CURRENT_TIMESTAMP :: TEXT), 15, TO_DATE('2/2/2011', 'MM/DD/YYYY'), 7, 'Notes for patient # 15');

insert into visit (visit_id, patient_id, visit_date, cgi_score, visit_notes) values
(md5(CURRENT_TIMESTAMP :: TEXT), 15, TO_DATE('4/21/2011', 'MM/DD/YYYY'), 1, 'Notes for patient # 15');

insert into visit (visit_id, patient_id, visit_date, cgi_score, visit_notes) values
(md5(CURRENT_TIMESTAMP :: TEXT), 15, TO_DATE('6/24/2011', 'MM/DD/YYYY'), 4, 'Notes for patient # 15');

insert into visit (visit_id, patient_id, visit_date, cgi_score, visit_notes) values
(md5(CURRENT_TIMESTAMP :: TEXT), 15, TO_DATE('3/23/2011', 'MM/DD/YYYY'), 1, 'Notes for patient # 15');