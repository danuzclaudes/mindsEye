# --- Created by Ebean DDL
# To stop Ebean DDL generation, remove this comment and start using Evolutions

# --- !Ups

create table medication (
  med_id                    serial not null,
  med_name                  varchar(32),
  med_start_date            date not null,
  med_end_date              date,
  med_group                 varchar(5) not null,
  prescribed_on_visit       varchar(32),
  constraint pk_medication primary key (med_id))
;

create table visit (
  visit_id                  varchar(32) not null,
  visit_date                date not null default CURRENT_DATE,
  cgi_score                 integer not null,
  visit_group               integer default 0,
  visit_notes               text,
  patient_id                integer not null,
  constraint pk_visit primary key (visit_id))
;

alter table medication add constraint fk_medication_prescribed_on_vi_1 foreign key (prescribed_on_visit) references visit (visit_id);
create index ix_medication_prescribed_on_vi_1 on medication (prescribed_on_visit);



# --- !Downs

drop table if exists medication cascade;

drop table if exists visit cascade;

