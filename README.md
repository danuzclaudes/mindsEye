# MindsEye
MindsEye is a research project to explore visualization and usability of Electronic Health Records (EHR) system, to help the clinicians gain overview of patients' conditions.

This is a <b>Full-Stack</b> project that I'm responsible for <b>end-to-end technical designs, implementation, testing, documentation, delivery and maintenance</b> of all the services.
The application is following RESTful architectural style and the framework that I'm using is called `Play Framework` in Java.
+ Model: PostgreSQL; Java for Object-relational mapping (ORM) design pattern
+ View: Scala template; jQuery, AJAX; Vis library
+ Controller: Java

## Install and run Play-Activator
+ Helper Video
  - https://www.youtube.com/watch?v=bLrmnjPQsZc
+ Java JDK 1.8+
+ Download latest Typesafe Activator
  - Go to Play official: https://www.playframework.com/documentation/2.4.x/Installing
  - Choose `Download the latest Typesafe Activator`;
  - Download the mini-package with no bundled dependencies (1M)
  - Unzip the downloaded zip file
    - `unzip typesafe-activator-{app_version}-minimal.zip`
  - Change diretory by `cd activator-{app_version}-minimal`
  - Add Executables to file permission:
    - `chmod u+x /path/to/activator`
  - Run `./activator new /path/to/project`
    - Here I'd choose `~/Documents/mindseye` for reference;
    - The console displays "Choose from these featured templates or enter a template name:";
    - Type 5 and enter;
    - For the first time it would take couple of minutes to build dependencies automatically.
  - Add `activator` to PATH and check by `activator -h`
  - Remove the downloaded and unzipped files and change directory to MindsEye project
  - Type command `activator run` to start the HTTP server on port 9000
  - Open browser and type `localhost:9000` and the welcome page will come up
  - Type `activator` command to launch the Play console
  - You can either set up configuration for Eclipse or IntelliJ for convenience
    - https://www.playframework.com/documentation/2.4.x/IDE

## Configure Play-EBean Plugin and PostgreSQL connection
+ Documentation
  - https://www.playframework.com/documentation/2.4.x/JavaDatabase#Configuring-JDBC-connection-pools
+ Assume that the PostgresSQL database has been installed and service is running
  - `pg_ctl status/start`
+ Create new database by `createdb mindseye`
+ `build.sbt`:
  - Enable the Play EBean plugin:
    - `lazy val myProject = (project in file(".")).enablePlugins(PlayJava, PlayEbean)`
  - Add dependency on postgresql library:
    - `libraryDependencies += "org.postgresql" % "postgresql" % "9.4-1201-jdbc41"`
    - Library URL can be referred from http://mvnrepository.com/artifact/org.postgresql/postgresql
+ conf/application.conf:
  - Configure the PostgreSQL settings:
    - `db.default.driver=org.postgresql.Driver`
    - `db.default.url="jdbc:postgresql://username:password@localhost:port/dbname"`
    - `db.default.username=username`
    - `db.default.passowrd="password"`
+ project/plugins.sbt:
  - Uncomment the line:
    - `addSbtPlugin("com.typesafe.sbt" % "sbt-play-ebean" % "1.0.0")`
+ Run and check on `localhost:9000`
  - Click to apply the automated SQL script
  - As long as the service is running and database is connected, Play framework will automatically generate sql files
    - in folder `conf/evolutions/default`
  - Once there's any error, read carefully on the system logs, they are very helpful.
+ ORM Mapping by Ebean: http://ebean-orm.github.io/docs/mapping/

## HTTP router: `conf/routes`
+ Documentation: https://www.playframework.com/documentation/2.4.x/JavaRouting
+ The router is the component that translates each incoming HTTP request to a public method in a controller class
  - HTTP method: `GET/POST/PUT/DELETE`
  - request path, or self-defined RESTful API: `/patient/:id`, `/visit/:id/medications`, etc
  - call definition: `controllers.YourClass.method(para: Type)`
+ Design your own request path and related call def first to expand new APIs.
+ RESTful APIs


  ```javascript
  GET     /                           controllers.Application.index()
  POST    /patient                    controllers.Patient.post()
  GET     /patient/:id                controllers.Patient.dashboard(id: Integer)
  GET     /patient/:id/visits         controllers.Visit.getAll(id: Integer)
  GET     /patient/:id/medications    controllers.Medication.getByPatient(id: Integer)
  GET     /visit/:id/medications      controllers.Medication.getByVisit(id: String)
  GET     /error/:id                  controllers.Application.handleError(id: Integer)
  ```

## Deployment - Ruby server & OpenShift
+ Reference here: https://www.playframework.com/documentation/latest/Deploying
+ Configure the application secret
+ Run `activator`, and in the play console, run `dist` to generate a ZIP file containing all JAR files needed to run your application in the `target/universal` folder
+ Run script `./$PRODUCTION_HOME/bin/<project-name> &`
+ BZ: How to solve the problem that server does not have Java 8?
  - Download jdk8 from Oracle and move it to your own java home
  - Unzip the file and add the following at the beginning of `$PRODUCTION_HOME/bin/<project-name>` file
    ```shell
    export JAVA_HOME=/path/to/jdk1.8.0_xx
    export PATH=$JAVA_HOME:$PATH
    echo $PATH
    ```

  - This script will automatically be applied when play production is running
+ BZ: For errors of "This application is already running"
  - Delete `/$PROJECT_HOME/RUNNING_PID` file.
  - Check environment: `ps afx | grep mindseye` to check if the script is running at backend; kill it if necessary
  - You may also apply the following to `bin/<project-name>` script if you install PostgreSQL through my [script](./conf/evolutions/default/Postgres-Setup.sh)

    ```shell
    # Set up PostgreSQL
    export PG_HOME=/export/home/c/chongrui/postgres
    PATH=$PG_HOME/bin:$PATH
    export PATH
    export PGDATA=$PG_HOME/data
    pg_ctl status
    ```

+ After running the `$PRODUCTION_HOME/bin/<project-name>` script, the play framework will be running at background using port 9000 on the server.
  - Then you can access it throught the server's hostname or IP address since it is listening to all IP addresses by `0.0.0.0`.
  - However, you might need to ask sys admin to open the port 9000 on the server;
    - check with `nmap <hostname>`
+ BZ: How to deploy on OpenShift?
  - DO PLEASE send me a new issue if you have successfully deployed it, especially the shitty db connection...
