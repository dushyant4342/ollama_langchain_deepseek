# Streamlit app Docker Image (Linux2 AMI on EC2)

#1. Update packages

sudo yum update -y

#Install GIt

sudo yum install git -y


Other dependencies are installed inside docker
#Install Ollama and Deepseek in the Docker file
#curl -fsSL https://ollama.com/install.sh | sh
#ollama pull deepseek-r1:1.5b
#ollama --version
#which ollama
l#s ~/.ollama/
streamlit
python
langchain etc


#2. Install Docker

sudo yum install -y docker (worked)

docker --version

Docker version 25.0.6, build 32b99dd
#curl -fsSL https://get.docker.com -o get-docker.sh
#sudo sh get-docker.sh

#3. Start & enable Docker service

sudo service docker start   # Amazon Linux 2

sudo systemctl enable docker  # Enable Docker on startup
 
#4. Add user to Docker group (Amazon Linux uses 'ec2-user')

sudo usermod -aG docker ec2-user

#5. Refresh group permissions (apply without logout)

newgrp docker

#6. Clone your GitHub project

git clone "your-project"

git clone https://github.com/dushyant4342/ollama_langchain_deepseek.git

cd ollama_langchain_deepseek

#7. Build Docker image
#docker build -t entbappy/stapp:latest .  

docker build -t dushyant1334/deepseekr115b:latest .

(This command will build the Docker image with the tag dushyant1334/deepseekr115b:latest using the current directory (the .).

#8. Check all images

docker images -a

REPOSITORY                   TAG       IMAGE ID       CREATED         SIZE

dushyant1334/deepseekr115b   latest    b5d6868be76a   3 minutes ago   5.17GB

#9. Run the container on port 8501 in detached mode
#docker run -d -p 8501:8501 entbappy/stapp

docker run -d -p 8501:8501 dushyant1334/deepseekr115b:latest

#docker run -d -p 8501:8501 --name deepseek_app dushyant1334/deepseekr115b:latest
#docker run -d -p 8501:8501 -p 11434:11434 --name deepseek_container dushyant1334/deepseekr115b

#10. Check running containers

docker ps

docker logs <container_name>


#11. Stop a running container (replace `container_id` with actual ID) - it will stop website

docker stop container_id

#12. Remove all stopped containers

docker rm $(docker ps -a -q)

docker rmi -f $(docker images -q) #Delete all docker images

#13. Log in to Docker Hub

docker login

#14. Push the image to Docker Hub

#docker push entbappy/stapp:latest

docker push dushyant1334/deepseekr115b:latest

#15. Check images again

docker images -a

#16. Remove image from EC2

#docker rmi entbappy/stapp:latest

docker rmi dushyant1334/deepseekr115b

#17. Pull image from Docker Hub

#docker pull entbappy/stapp

docker pull dushyant1334/deepseekr115b

docker run -d -p 8501:8501 dushyant1334/deepseekr115b:latest

docker stop deepseek_container

docker rm $(docker ps -a -q)


Run Inside Container

docker exec -it deepseek_container ps aux | grep streamlit —> check if streamlit is running

docker exec -it deepseek_container streamlit run app.py --server.port 8501 --server.address 0.0.0.0

docker exec -it deepseek_container ollama serve

docker exec -it deepseek_container ps aux | grep ollama




# Dockerfile

│── 📄 open terminal and run below command and paste 

touch Dockerfile

nano Dockerfile


#Paste (Use Amazon Linux base image)

FROM amazonlinux:2023

#Install dependencies

RUN dnf install -y python3.11 python3.11-devel curl tar gzip --allowerasing && \
    alternatives --install /usr/bin/python3 python3 /usr/bin/python3.11 1 && \
    python3 -m ensurepip --default-pip && \
    python3 -m pip install --upgrade pip

#Verify Python and Pip installation

RUN python3 --version && python3 -m pip --version

#Install Ollama

RUN curl -fsSL https://ollama.com/install.sh | sh

#Pull the DeepSeek model

RUN ollama serve & sleep 5 && ollama pull deepseek-r1:1.5b

#Set the working directory

WORKDIR /app

#Copy and install dependencies

COPY requirements.txt .

RUN python3 -m pip install --no-cache-dir -r requirements.txt

#Copy the rest of the application code

COPY . .

#Expose port for Streamlit

EXPOSE 8501

#Start Ollama and Streamlit

CMD /root/.ollama/bin/ollama serve & python3 -m streamlit run app.py --server.port=8501 --server.address=0.0.0.0

Save and exit (if using nano, press Ctrl + X → Y → Enter).



# Dockerignore

#│── 📄 open terminal and run below command and paste 

touch .dockerignore

nano .dockerignore

Paste

__pycache__/

*.pyc

*.pyo

*.log

.env

venv/

Save and exit (if using nano, press Ctrl + X → Y → Enter).


