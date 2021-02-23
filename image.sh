#!/bin/bash -x


# Author: LASER-FOCUS

# Date: 1/1/2021




# Description: build and push images to dockerhub



# Checking if docker is installed on the host machine

sleep 2
echo ‘making sure you are root user’
K=$(id -u)
if 
[[  "${K}"  -eq  0  ]]
then 
echo 'you are root user and can now proceed with this script'
else
echo ‘Sorry you are not ROOT  user’
exit 1
fi

sleep 2
docker ps &> /dev/null
 

if [[ "${?}" -eq 0 ]] 
then 
echo " docker is installed "
else
echo "docker is not install"
sleep 2
echo " installing docker "
apt install docker.io -y &> /dev/null 
echo "docker is now installed "
sleep 2
echo "enabling start docker deamon"
systemctl enable docker
systemctl start docker 
fi

echo
echo "checking if docker is running"
systemctl status docker | grep active &> /dev/null

if [[ "${?}" -eq 0 ]]
then
echo " docker is active and running "
else
echo "docker is not running"
sleep 2
echo " restarting docker deamon" 
systemctl restart docker
echo "docker is actif and running "
sleep 2
fi


echo
sleep 2
 echo ‘checking removing previous file’
  rm -f Dockerfile &> /dev/null
  if
  [[  ${?}  -eq  0  ]]
  then
  echo ‘all existing Dockerfiles have been removed’
  else
  echo  ‘there is no file named Dockerfile’
  fi
echo 
sleep 2

echo "generating dockerfile"
echo ' FROM ubuntu' > Dockerfile

echo 'MAINTAINER  Yolly' >> Dockerfile
echo 'RUN apt  update  -y' >> Dockerfile
echo 'RUN apt install curl -y' >> Dockerfile
echo 'RUN apt install vim  -y' >> Dockerfile
echo 'RUN apt clean '  >> Dockerfile
echo 'RUN apt install finger -y '  >> Dockerfile 
echo 'RUN apt install wget -y '  >> Dockerfile
echo 'RUN apt install curl -y '  >> Dockerfile
#echo  ' RUN  apt install docker -y '  >> Dockerfile
echo  ' RUN apt install openjdk-11-jdk -y '  >> Dockerfile
echo  ' RUN apt-get install -y apache2 '  >> Dockerfile
echo  ' RUN apt install openjdk-8-jdk -y '  >> Dockerfile
echo  ' RUN apt install ansible -y '  >> Dockerfile
echo  ' RUN apt install git -y '  >> Dockerfile
echo  ' RUN apt install -y python3 '  >> Dockerfile 
echo  'CMD [“echo”, “Hello World”]'  >> Dockerfile
sleep 2
echo 
echo " checking if docker file has been created"
A=$(pwd)
B=Dockerfile
file=${A}/${B}
if [ -e "$file" ]
 then
    echo "File $B exists"
else 
    echo "File $B does not exist"
exit 1
fi
sleep 3
echo 


echo  ‘cleaning up docker space’ 
#echo  ‘stopping existing container’  
#docker stop $(docker ps  -aq)  &> /dev/null
#if 
#[[  ${?}  -eq  0  ]]
#then 
#echo ‘ all container are in stop state ’
#else
#echo  ‘ error failed to stop containers’
#exit 1
#fi


sleep 3
echo  ‘removing existing container’  
docker rm -f  $(docker ps  -aq)  &> /dev/null
if 
[[  ${?}  -eq  0  ]]
then 
echo ‘ all containers have been  removed  ’
else
echo  ‘error failed to removed containers’ &> /dev/null

fi



sleep 3
echo  ‘removing existing images’  
docker  rmi -f  $(docker images  -aq)  &> /dev/null
if 
[[  ${?}  -eq  0  ]]
then 
echo ‘ all images have been removed  ’
else
echo  ‘ error failed to removed all images’  &> /dev/null


fi

echo  'builing the image'
docker build -t yolly.image .  &> /dev/null


echo  ‘checking if the image has been built’
docker images  | grep yolly.image   &> /dev/null
if 
[[  ${?}  -eq  0  ]]
then 
echo ‘the image  exist ’
else
echo  ‘error no image called yolly.image available’ 
exit 1

fi


echo "Generating containers"
echo 'collecting input from reader'
sleep 3
echo
read -p 'enter the container name:  ' C
read -p 'enter the internal port: ' D
read -p 'enter externe port: ' E



sleep 3
echo 'creating your containers'
F=yolly.image
docker run -d  --name=$C -p ${D}:${E}  $F

sleep 3
echo 'renaming your image name'
docker tag yolly.image  linuxstudent/group_work_image  &> /dev/null

if
[[  ${?}  -eq  0  ]]
then
echo ‘the image  has been tagged’
else
echo  "ERROR fail to tag  the image"
exit 1

fi

docker push linuxstudent/group_work_image

if 
[[  ${?}  -eq  0  ]]
then
echo ‘the image  has been push to linuxstudent’
else
echo  "ERROR fail to push the image"
exit 1

fi