# be-automation-demo
A proof of concept for BusinessEvents continuous integration and delivary.

## Build Flow

![BuildFlow](https://github.com/shivchelwa/be-automation-demo/blob/master/BE%20Continuous%20Integration.png)

# Setup Development Environment

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

## Maven Setup
* Create or Import a BusinessEvents Studio project
* Right click on project to Generate Maven POM file
* Edit POM file and set values to below tag for be-maven-plugin
  * beProjectDetails
    * beHome - Path to BE installtion directory. Use a property variable ${be.home} and use [settings.xml](https://github.com/shivchelwa/be-automation-demo/blob/master/vagrant/settings.xml) to set local install path using a profile.
    * earLocation - Path to ear file location, could be related e.g. target
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
 
## Maven Phases
The BusinessEvents EAR file be build, tested and pushed to local/remote repositories using Maven. Also you can build base and application docker image using Maven. You must setup Maven POM file. Either use BusinessStudio or command line to execute below maven phases
* mvn compile - builds a ear file at earLocation mentioned in pom configuration
* mvn test - compiles and execute junit test case suite
* mvn install - compiles, tests ear file and installs it in Local Maven repository
* mvn deploy - compiles, tests ear file and installs it in Remote Maven repository
* mvn build-base-image - If you want to generated base image using Maven
* mvn build-app-docker-file - Build a docker file for application
* mvn docker-install - Build a application docker image in Local Docker repository
* mvn docker-deploy - Build a application docker image in Remote Docker repository


# Setup a local Jenkins server

## Prerequisites
* VirtualBox
* Vagrant
* TIBCO ActiveSpace 2.3 and TIBCO BusinessEvents 5.5.0 linux ditributions

Setup a locaiton Jenkins server using Vagrant. A [Vagrantfile](https://github.com/shivchelwa/be-automation-demo/blob/master/vagrant/Vagrantfile) and [bootstrap.sh](https://github.com/shivchelwa/be-automation-demo/blob/master/vagrant/bootstrap.sh) are used to start a CentOS Virtualbox. Please note, you need to download ActiveSpace 2.3 BusinessEvents 5.5 linux distribtion from [TIBCO eDelivery](https://edelivery.tibco.com/storefront/index.ep) and place it in the same directory as Vagrantfile.

## Maven Profile
You need to add a maven profile using [settings.xml](https://github.com/shivchelwa/be-automation-demo/blob/master/vagrant/settings.xml) to set environment variables such as BE installtion directory any other target directories.

## Jenkins Configrations
* Unlock Jenkins using password at /var/lib/jenkins/secrets/initialAdminPassword
* Change admin password
* Install Jenkins Plugins - Maven Integration, GitHub, Pipeline
* Add Git, JDK and Maven under Global Tool Config

## BusinessEvents Jenkins Job
* Add a new item
* Provide Git project url
* Provede Maven Goals e.g. docker-deploy
* Alternatively,
 * Git Webhooks can be used to trigger the build job on git push notifications.
 * Jenkins Pipeline can be used setup multi stage delivery flow.
