-- Clean up the database first:
-- `truncate medication; delete from visit where patient_id=15; select * from visit; select * from medication;`
-- `delete from patient where patient_id=15 or patient_id=171; select * from patient;`
-- Then execute this sql file by `psql -d mindseye -f ./conf/evolutions/default/mindseye-devel.sql`

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
    visit_type  char(1),
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
    med_group varchar(12) not null,
    prescribed_on_visit varchar(32) not null
    -- doctor_name varchar(32) not null,
);
\d medication

create table IF NOT EXISTS patient (
  patient_id                serial not null,
  patient_age               integer,
  patient_sex               char(3),
  patient_race              char(1),
  patient_primary_diagnosis varchar(256) not null,
  patient_secondary_diagnosis varchar(256),
  days_since_last_visit     integer default 0,
  constraint pk_patient primary key (patient_id));
\d patient

insert into patient (patient_id, patient_age, patient_sex, patient_race, patient_primary_diagnosis, patient_secondary_diagnosis, days_since_last_visit)
values (15, 40, 'F', 'W', 'Major depressive disorder', 'Schizophrenia; Anxiety disorders', 1);

insert into patient (patient_id, patient_age, patient_sex, patient_race, patient_primary_diagnosis, patient_secondary_diagnosis, days_since_last_visit)
values (171, 19, 'M', 'U', 'Obsessive-compulsive disorder', 'Panic disorders; Eating Disorder', 7);

insert into visit (visit_id, patient_id, visit_date, cgi_score, visit_notes, visit_type) values
('84f22a76e57ab37dde3af8ec5e21f670', 15, TO_DATE('1/12/2011', 'MM/DD/YYYY'), 7,
'Ms. Bingham is a 40 year old woman who complains of worsening Major depressive disorder.
She has never had a similar problem in the past.
She has no difficulty sleeping, but she notes that eating makes the pain worse.
Nothing makes it better. There is no SOB or sensation of choking or dysphagia.
\n\nFHx: father with HTN<br>FHx: married with 2 children, No ETOH or drugs, monogamous with husband',
'T');

insert into visit (visit_id, patient_id, visit_date, cgi_score, visit_notes, visit_type) values
('6cfd9f88b71b6907c520044a2f24304c', 15, TO_DATE('3/30/2011', 'MM/DD/YYYY'), 3,
'From today Mrs. Bingham starts to deploy a new medication CITALOPRAM;
she cease to take BUPROPION_XL due to the fact that her anxiety has relieved.','T');

insert into visit (visit_id, patient_id, visit_date, cgi_score, visit_notes, visit_type) values
('1c4adf64dc3b4f60bde4cf7e592cdb1f', 15, TO_DATE('5/11/2011', 'MM/DD/YYYY'), 3, 'Notes for patient # 15','I');

insert into medication (med_id, med_name, med_start_date, med_end_date, med_group, prescribed_on_visit) values
(1, 'BUPROPION-XL', TO_DATE('1/05/2011', 'MM/DD/YYYY'), TO_DATE('3/23/2011', 'MM/DD/YYYY'), 'BUP', '84f22a76e57ab37dde3af8ec5e21f670');

insert into medication (med_id, med_name, med_start_date, med_end_date, med_group, prescribed_on_visit) values
(2, 'CITALOPRAM', TO_DATE('1/12/2011', 'MM/DD/YYYY'), TO_DATE('3/9/2011', 'MM/DD/YYYY'), 'SSRI', '84f22a76e57ab37dde3af8ec5e21f670');

insert into medication (med_id, med_name, med_start_date, med_end_date, med_group, prescribed_on_visit) values
(3, 'FLUOXETINE HCL', TO_DATE('6/15/2011', 'MM/DD/YYYY'), TO_DATE('8/1/2011', 'MM/DD/YYYY'), 'SSRI', '6cfd9f88b71b6907c520044a2f24304c');

insert into medication (med_id, med_name, med_start_date, med_end_date, med_group, prescribed_on_visit) values
(4, 'PSYCHO THERAPY', TO_DATE('1/5/2011', 'MM/DD/YYYY'), TO_DATE('3/22/2011', 'MM/DD/YYYY'), 'PSYCH-THRPY', '84f22a76e57ab37dde3af8ec5e21f670');

insert into medication (med_id, med_name, med_start_date, med_end_date, med_group, prescribed_on_visit) values
(5, 'PSYCHO THERAPY', TO_DATE('4/9/2011', 'MM/DD/YYYY'), TO_DATE('6/15/2011', 'MM/DD/YYYY'), 'PSYCH-THRPY', '84f22a76e57ab37dde3af8ec5e21f670');

insert into medication (med_id, med_name, med_start_date, med_end_date, med_group, prescribed_on_visit) values
(6, 'BUPROPION-XL', TO_DATE('5/4/2011', 'MM/DD/YYYY'), TO_DATE('8/1/2011', 'MM/DD/YYYY'), 'BUP', '84f22a76e57ab37dde3af8ec5e21f670');

insert into medication (med_id, med_name, med_start_date, med_end_date, med_group, prescribed_on_visit) values
(7, 'LITHIUM CARBONATE', TO_DATE('3/30/2011', 'MM/DD/YYYY'), TO_DATE('5/7/2011', 'MM/DD/YYYY'), 'LI', '1c4adf64dc3b4f60bde4cf7e592cdb1f');

insert into medication (med_id, med_name, med_start_date, med_end_date, med_group, prescribed_on_visit) values
(8, 'OLANZAPINE', TO_DATE('3/30/2011', 'MM/DD/YYYY'), TO_DATE('5/9/2011', 'MM/DD/YYYY'), 'OLZ', '1c4adf64dc3b4f60bde4cf7e592cdb1f');


insert into visit (visit_id, patient_id, visit_date, cgi_score, visit_notes, visit_type) values
('a5bbb72434f264e2248f7c072e5217d7', 15, TO_DATE('4/9/2011', 'MM/DD/YYYY'), 7,
'Ms. Bingham is a 24 year old woman who complains of worsening Major depressive disorder,
since yesterday morning. She has never had a similar problem in the past.
She has no difficulty swallowing, but notes that swallowing makes the pain worse.
Nothing makes it better. There is no SOB or sensation of choking or dysphagia.','T'
);

insert into visit (visit_id, patient_id, visit_date, cgi_score, visit_notes, visit_type) values
(md5(CURRENT_TIMESTAMP :: TEXT), 15, TO_DATE('1/5/2011', 'MM/DD/YYYY'), 2,
'Ms. Bingham is a 24 year old woman who complains of worsening sore throat
\n\nFHx: father with HTN<br>FHx: married with 2 children, No ETOH or drugs, monogamous with husband','T');

insert into visit (visit_id, patient_id, visit_date, cgi_score, visit_notes, visit_type) values
(md5(CURRENT_TIMESTAMP :: TEXT), 15, TO_DATE('8/1/2011', 'MM/DD/YYYY'), 7,
'Good condition while needs further observation.','I');

insert into visit (visit_id, patient_id, visit_date, cgi_score, visit_notes, visit_type) values
(md5(CURRENT_TIMESTAMP :: TEXT), 15, TO_DATE('6/29/2011', 'MM/DD/YYYY'), 5, 'Notes for patient # 15','I');

insert into visit (visit_id, patient_id, visit_date, cgi_score, visit_notes, visit_type) values
(md5(CURRENT_TIMESTAMP :: TEXT), 15, TO_DATE('6/15/2011', 'MM/DD/YYYY'), 6, 'Notes for patient # 15','I');

insert into visit (visit_id, patient_id, visit_date, cgi_score, visit_notes, visit_type) values
(md5(CURRENT_TIMESTAMP :: TEXT), 15, TO_DATE('5/4/2011', 'MM/DD/YYYY'), 7, 'Notes for patient # 15','T');

insert into visit (visit_id, patient_id, visit_date, cgi_score, visit_notes, visit_type) values
(md5(CURRENT_TIMESTAMP :: TEXT), 15, TO_DATE('2/9/2011', 'MM/DD/YYYY'), 6, 'Notes for patient # 15','I');

insert into visit (visit_id, patient_id, visit_date, cgi_score, visit_notes, visit_type) values
(md5(CURRENT_TIMESTAMP :: TEXT), 15, TO_DATE('7/25/2011', 'MM/DD/YYYY'), 5, 'Notes for patient # 15','T');

insert into visit (visit_id, patient_id, visit_date, cgi_score, visit_notes, visit_type) values
(md5(CURRENT_TIMESTAMP :: TEXT), 15, TO_DATE('2/2/2011', 'MM/DD/YYYY'), 7, 'Notes for patient # 15','T');

insert into visit (visit_id, patient_id, visit_date, cgi_score, visit_notes, visit_type) values
(md5(CURRENT_TIMESTAMP :: TEXT), 15, TO_DATE('4/21/2011', 'MM/DD/YYYY'), 7, 'Notes for patient # 15','I');

insert into visit (visit_id, patient_id, visit_date, cgi_score, visit_notes, visit_type) values
(md5(CURRENT_TIMESTAMP :: TEXT), 15, TO_DATE('6/24/2011', 'MM/DD/YYYY'), 4, 'Notes for patient # 15','I');

insert into visit (visit_id, patient_id, visit_date, cgi_score, visit_notes, visit_type) values
(md5(CURRENT_TIMESTAMP :: TEXT), 15, TO_DATE('3/23/2011', 'MM/DD/YYYY'), 1, 'Notes for patient # 15','T');
