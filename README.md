Streamlit app Docker Image (Linux)
1. Update packages

sudo yum update -y

2. Install Docker

curl -fsSL https://get.docker.com -o get-docker.sh
sudo sh get-docker.sh

3. Start & enable Docker service

sudo service docker start   # Amazon Linux 2
sudo systemctl enable docker  # Enable Docker on startup

4. Add user to Docker group (Amazon Linux uses 'ec2-user')

sudo usermod -aG docker ec2-user

5. Refresh group permissions (apply without logout)

newgrp docker

6. Clone your GitHub project

git clone "your-project"

7. Build Docker image

docker build -t entbappy/stapp:latest .

8. Check all images

docker images -a

9. Run the container on port 8501 in detached mode

docker run -d -p 8501:8501 entbappy/stapp

10. Check running containers

docker ps

11. Stop a running container (replace `container_id` with actual ID)

docker stop container_id

12. Remove all stopped containers

docker rm $(docker ps -a -q)

13. Log in to Docker Hub

docker login

14. Push the image to Docker Hub

docker push entbappy/stapp:latest

15. Check images again

docker images -a

16. Remove image from EC2

docker rmi entbappy/stapp:latest

17. Pull image from Docker Hub

docker pull entbappy/stapp



🔹 Key Differences Between Ubuntu & Amazon Linux
Command     	    Ubuntu	            AmazonLinux
Update packages	sudo apt-get update -y	sudo yum update -y
Install Docker	apt-get install docker.io -y	yum install docker -y (or via get-docker.sh)
Start Docker	systemctl start docker	service docker start
Enable Docker on Boot	systemctl enable docker	systemctl enable docker
Default User	ubuntu	ec2-user


Streamlit app Docker Image (Ubuntu)

1. Login with your AWS console and launch an EC2 instance

2. Run the following commands

Note: Do the port mapping to this port:- 8501
sudo apt-get update -y

sudo apt-get upgrade

#Install Docker

curl -fsSL https://get.docker.com -o get-docker.sh

sudo sh get-docker.sh

sudo usermod -aG docker ubuntu

newgrp docker

git clone "your-project"

docker build -t entbappy/stapp:latest . 

docker images -a  (check all images)

docker run -d -p 8501:8501 entbappy/stapp   ######(Run this image, port mapping, d mode which will run it all the time)

docker ps  (check container running)

docker stop container_id

docker rm $(docker ps -a -q) (delete all containers)

docker login 

docker push entbappy/stapp:latest (push image to docker hub from Ec2)

docker images -a (check all images)

docker rmi entbappy/stapp:latest (remove repo from ec2 & pull from docker hub)

docker pull entbappy/stapp
