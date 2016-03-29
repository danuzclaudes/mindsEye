gmake --version
cd ~
mkdir postgres
cd postgres
wget http://ftp.postgresql.org/pub/source/v9.5.0/postgresql-9.5.0.tar.gz
md5sum postgresql-9.5.0.tar.gz

# Ensure that the path to postgres is correctly set
export PG_HOME=/var/lib/openshift/<uuid-for-openshift>/postgres

# start making the Postgres system
# gunzip postgresql-9.5.0.tar.gz; tar xf postgresql-9.5.0.tar
tar -zxf postgresql-9.5.0.tar.gz
cd postgresql-9.5.0
pwd
# dependency on readline package
# sudo yum install readline-devel.x86_64
./configure --prefix=$PG_HOME --with-pgport=2388
gmake world
gmake check
gmake install

# set up for using Postgres
# better way is to add to bashrc
env
LD_LIBRARY_PATH=$PG_HOME/lib:$LD_LIBRARY_PATH
export LD_LIBRARY_PATH
PATH=$PG_HOME/bin:$PATH
export PATH
cd $PG_HOME
mkdir data
export PGDATA=$PG_HOME/data
# BZ: don't export PATH in .bashrc; duplicate w/ /etc/profile
# start the program
export PGPORT=2388
pg_ctl initdb
pg_ctl start

# start using postgres
createdb test
# psql -d mydb -U myuser
psql test
   show  all;
   select * from pg_settings;
   SELECT version();
   \h
   \q

# do some checking
pg_ctl status
ps -elf |grep chongrui
pg_ctl restart
pg_controldata 
pg_config 
vacuumdb --analyze --verbose test/--all

