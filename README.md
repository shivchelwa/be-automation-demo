# be-automation-demo
A proof of concept for BusinessEvents continuous integration and delivary.

## Build Flow

![BuildFlow](https://github.com/shivchelwa/be-automation-demo/blob/master/BE%20Continuous%20Integration.png)

## Setup Development Environment

Install below softwares on develpers machines
* TIBCO ActiveSpaces 2.3.0
* TIBCO BusinessEvents 5.5.0
* Apache Maven
* Docker

## Post Installation
* Add Maven to PATH and verify using mvn --version
* Set Up TIBCO BusinessEvents Maven Plug-in - This is a simple one time activity post . Open a shell and execute below command
```bash
BE_HOME/maven/bin/install-be-maven-plugin.sh
```
* Build a Base Docker Image for TIBCO BusinessEvents - To build a base image for TIBCO BusinessEvents. Open a shell and execute below command
```bash
BE_HOME/build_be_image_frominstallation.sh -v 5.5.0 -i v01 -o true
```
This command will create a base image with local repository with tag com.tibco.be:5.5.0-v01

## BusinessEvents Development Environment
* Create or Import a BusinessEvents Studio project
* Right click on project to Generate Maven POM file
* Edit POM file and set values to below tag for be-maven-plugin
  * beProjectDetails
    * beHome - path to installtion directory
    * earLocation - path to ear file location, could be related e.g. target
  * appImageConfig/
    * cddFileLocation - This location can be absolute of relative. Use Deployments/coverage.cdd
    * targetDir - This location can be absolute of relative. Use docker. This will create a docker directory under current project.
    * baseBEImage - Use the base image tag name. If you generated using above mentioned command use 5.5.0-v01
    * maintainer - Name of maintainer.
    * email - Email of maintainer.
    * labels - Any lables you may want to use e.g. ApplicationName=coverage,Version=5.5.0
    * appImage - Application image name with tag e.g. coverage:latest
    * overwriteDockerfile - Optional.
  * dockerRegistryConfig - Se value to each key/name
    * Repository - Name of your remote docker repository e.g. shivchelwa/coverage-app
    * Url - Remote docker repository url e.g. docker.io, <account_id>..dkr.ecr.<region>.amazonaws.com
    * TagImage - Tag the image e.g. shivchelwa/coverage-app:latest
