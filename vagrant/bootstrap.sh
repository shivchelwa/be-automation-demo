sudo su
yum -y upgrade
yum -y install wget
yum -y install unzip
yum -y install git
yum -y install java-1.8.0-openjdk-devel.x86_64
export JAVA_HOME=/usr/lib/jvm/java-1.8.0-openjdk-1.8.0.191.b12-1.el7_6.x86_64
export PATH=$PATH:$JAVA_HOME/bin

mkdir -p /opt/maven
cd /opt/maven
wget https://www-us.apache.org/dist/maven/maven-3/3.6.0/binaries/apache-maven-3.6.0-bin.tar.gz
tar -xvzf apache-maven-3.6.0-bin.tar.gz
cd ~
export M2_HOME=/opt/maven/apache-maven-3.6.0
export PATH=$PATH:$M2_HOME/bin
mkdir -p /opt/maven/repository
chmod -R 777 /opt/maven/repository

mkdir -p /tmp/as23install
cp /vagrant_data/TIB_activespaces_2.3.0_linux_x86_64.zip /tmp/as23install
cp /vagrant_data/my_activespaces_2.3.0.silent /tmp/as23install
cd /tmp/as23install
unzip TIB_activespaces_2.3.0_linux_x86_64.zip
./TIBCOUniversalInstaller-lnx-x86-64.bin -silent -V responseFile=my_activespaces_2.3.0.silent
cd ~
rm -rf /tmp/as23install

mkdir -p /tmp/be55install
cp /vagrant_data/TIB_businessevents-enterprise_5.5.0_linux26gl25_x86_64.zip /tmp/be55install
cp /vagrant_data/my_businessevents-enterprise_5.5.0.silent /tmp/be55install
cd /tmp/be55install
unzip TIB_businessevents-enterprise_5.5.0_linux26gl25_x86_64.zip
./TIBCOUniversalInstaller-lnx-x86-64.bin -silent -V responseFile=my_businessevents-enterprise_5.5.0.silent
cd ~
rm -rf /tmp/be55install


# Install Mamaven plugin
/opt/maven/apache-maven-3.6.0/bin/mvn -Dmaven.repo.local=/opt/maven/repository install:install-file -Dfile=/opt/tibco/be/5.5/maven/bin/be-maven-plugin-5.5.0.jar -DpomFile=/opt/tibco/be/5.5/maven/bin/pom.xml
# Generate a base docker image
cd /opt/tibco/be/5.5/docker/frominstall
./build_be_image_frominstallation.sh -v 5.5.0 -i v01 -o true
chmod -R 777 /opt/tibco/be/5.5/studio

wget -O /etc/yum.repos.d/jenkins.repo http://pkg.jenkins-ci.org/redhat/jenkins.repo
rpm --import https://jenkins-ci.org/redhat/jenkins-ci.org.key
yum -y install jenkins
usermod -a -G docker jenkins
service jenkins start

chmod -R 777 /opt/maven/repository
mkdir -p /opt/workspace/docker
chmod 777 /opt/workspace/docker
