FROM jenkins/jenkins:lts

USER root

# התקנת דרישות מקדימות
RUN apt-get update && apt-get install -y \
    apt-transport-https \
    ca-certificates \
    curl \
    gnupg2 \
    lsb-release \
    software-properties-common

# הוספת המפתח והמאגר של Docker
RUN curl -fsSL https://download.docker.com/linux/debian/gpg | apt-key add -
RUN echo "deb [arch=amd64] https://download.docker.com/linux/debian $(lsb_release -cs) stable" > /etc/apt/sources.list.d/docker.list

# התקנת Docker CLI
RUN apt-get update && apt-get install -y docker-ce-cli

# התקנת Node.js ו-npm
RUN curl -fsSL https://deb.nodesource.com/setup_14.x | bash - && \
    apt-get install -y nodejs

# **יצירת קבוצת docker והוספת המשתמש jenkins לקבוצה**
RUN groupadd docker && usermod -aG docker jenkins

USER jenkins
