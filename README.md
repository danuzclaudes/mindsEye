# MindsEye
MindsEye is a research project to explore visualization and usability of Electronic Health Records (EHR) system, to help the clinicians gain overview of patients' conditions.

## Install and run Play with Activator
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
