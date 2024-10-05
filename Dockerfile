# Dockerfile

# שלב 1: בחירת תמונת הבסיס של Jenkins (גרסת LTS)
FROM jenkins/jenkins:lts

# שלב 2: מעבר למשתמש root כדי לבצע התקנות
USER root

# שלב 3: עדכון רשימת החבילות והתקנת דרישות מקדימות
RUN apt-get update && apt-get install -y \
    apt-transport-https \
    ca-certificates \
    curl \
    gnupg2 \
    lsb-release \
    software-properties-common \
    git \
    && rm -rf /var/lib/apt/lists/*

# שלב 4: התקנת Docker CLI
# הוספת המפתח הציבורי של Docker והוספת מאגר Docker לרשימת המקורות
RUN curl -fsSL https://download.docker.com/linux/debian/gpg | apt-key add - \
    && echo "deb [arch=amd64] https://download.docker.com/linux/debian $(lsb_release -cs) stable" > /etc/apt/sources.list.d/docker.list \
    && apt-get update && apt-get install -y docker-ce-cli \
    && rm -rf /var/lib/apt/lists/*

# שלב 5: התקנת Node.js ו-NPM מ-NodeSource
# אנו נשתמש בגרסה 20.x של Node.js, שהיא גרסת LTS מומלצת
RUN curl -fsSL https://deb.nodesource.com/setup_20.x | bash - \
    && apt-get install -y nodejs \
    && rm -rf /var/lib/apt/lists/*

# שלב 6: בדיקת התקנה של Node.js ו-NPM
# זהו שלב בדיקה, ניתן להסירו לאחר וידוא שההתקנה הצליחה
RUN node --version && npm --version

# שלב 7: התקנת kubectl
RUN curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl" \
    && install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl \
    && rm kubectl

# שלב 8: יצירת קבוצת docker והוספת המשתמש jenkins לקבוצה
RUN groupadd docker && usermod -aG docker jenkins

# שלב 9: עדכון PATH כדי לכלול את /usr/local/bin
ENV PATH=$PATH:/usr/local/bin

# שלב 10: שינוי בעלות על /var/jenkins_home למשתמש jenkins
RUN chown -R jenkins:jenkins /var/jenkins_home

# שלב 11: חזרה למשתמש jenkins
USER jenkins

# סיום
