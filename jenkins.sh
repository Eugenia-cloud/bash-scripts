#!/bin/bash
# Maintainer LASER-FOCUS 
# this script can only run of debain base OS
echo 'this script will take about 5 min to run and perform the following tasks:'
echo  $'\e[1;33m'Jenkins$'\e[0m'
echo  $'\e[1;33m'start jenkins daemon$'\e[0m'
echo  $'\e[1;33m'Java $'\e[0m'
echo  $'\e[1;33m'Maven$'\e[0m'
echo  $'\e[1;33m'Set JAVA home$'\e[0m'
echo  $'\e[1;33m'set Maven home$'\e[0m'
echo  $'\e[1;33m'display Java and Maven home at the end of the script$'\e[0m'
echo
sleep 3
ID=$(id -u)
if 
[[ $ID -eq 0 ]]
then
echo
echo you are Root and therefore let us gather some facts 
else
echo you are not Root please loging as a root user
exit 1
fi
echo
echo ‘PLEASE be patient with this script it will take about 5mn to unpack all required packages’
echo
echo
echo  $'\e[1;33m' When prompted please Press ENTER in your keyboard to unpack Java$'\e[0m'
echo
echo
sleep 2

sudo add-apt-repository ppa:openjdk-r/ppa
sudo apt-get update
sudo apt install unzip -y
sudo apt-get install -y openjdk-8-jdk

#Install Jenkins

#wget -q -O - https://pkg.jenkins.io/debian/jenkins-ci.org.key | sudo apt-key add -
wget -q -O - https://pkg.jenkins.io/debian-stable/jenkins.io.key | sudo apt-key add -
echo deb https://pkg.jenkins.io/debian-stable binary/ | sudo tee /etc/apt/sources.list.d/jenkins.list
sudo apt-get update
sudo apt-get install -y jenkins
sudo systemctl start jenkins

#Install Maven  ( on Jenkins machine )

## cd /tmp ; wget http://mirrors.estointernet.in/apache/maven/maven-3/3.6.1/binaries/apache-maven-3.6.1-bin.tar.gz
## cd /tmp ; wget http://apachemirror.wuchna.com/maven/maven-3/3.6.2/binaries/apache-maven-3.6.2-bin.tar.gz
cd /tmp ; wget http://apachemirror.wuchna.com/maven/maven-3/3.6.3/binaries/apache-maven-3.6.3-bin.tar.gz
cd /tmp ; tar -xzf apache-maven-3.6.3-bin.tar.gz -C /opt

#Install SonarQube-runner ( on Jenkins machine )

#cd /tmp ; wget 

echo
echo
echo  $'\e[1;33m' If any question about SONAR-RUNNER-2 appear it means you have it installed  already just enter yes couple of  time on your keyboard until the script stop asking that question  $'\e[0m'
echo 
sleep 3
http://repo2.maven.org/maven2/org/codehaus/sonar/runner/sonar-runner-dist/2.4/sonar-runner-dist-2.4.zip
cd /tmp ; wget https://repo1.maven.org/maven2/org/codehaus/sonar/runner/sonar-runner-dist/2.4/sonar-runner-dist-2.4.zip
cd /tmp ; unzip sonar-runner-dist-2.4.zip
cd /tmp ; mv sonar-runner-2.4 /opt

#Set JAVA_HOME & MAVEN_HOME as environment variables on Jenkins machine
mkdir -p /home/backup
cp -p /etc/profile /home/backup/profile_`date +%d%b%Y-%H%M`
echo "MAVEN_HOME=/opt/apache-maven-3.6.3" >> /etc/profile
#echo "JAVA_HOME=/usr/lib/jvm/java-8-oracle" >> /etc/profile
echo "JAVA_HOME=/usr/lib/jvm/java-8-openjdk-amd64" >> /etc/profile
echo "PATH=\$JAVA_HOME/bin:\$MAVEN_HOME/bin:\$PATH" >> /etc/profile
source /etc/profile  ## to reload the configuration

echo
echo


echo 'here is your maven and java environment location'
echo                  $'\e[1;33m'$MAVEN_HOME $'\e[0m'

echo
sleep 2
echo                  $'\e[1;33m'$JAVA_HOME $'\e[0m'

echo
echo Now that this was successful go to jenkins set maven and java home using information above

echo
echo
echo "Thank you for using this script"


exit
