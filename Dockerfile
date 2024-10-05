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
    && add-apt-repository \
       "deb [arch=amd64] https://download.docker.com/linux/debian \
       $(lsb_release -cs) stable" \
    && apt-get update && apt-get install -y docker-ce-cli \
    && rm -rf /var/lib/apt/lists/*

# שלב 5: התקנת Node.js ו-NPM מ-NodeSource
# כאן נשתמש בגרסה 16.x של Node.js, ניתן לשנות לפי הצורך
RUN curl -fsSL https://deb.nodesource.com/setup_16.x | bash - \
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

# שלב 10: חזרה למשתמש jenkins
USER jenkins

# שלב 11: הגדרת משתני סביבה ל-DNS (אופציונלי)
# ניתן לשנות את הערכים לפי הצורך או להסיר אם כבר מוגדרים בסביבה
ENV DNS1=8.8.8.8 \
    DNS2=8.8.4.4

# שלב 12: התקנת תוספים נוספים ב-Jenkins (אופציונלי)
# ניתן להוסיף תוספים נוספים כאן אם נדרש
# למשל:
# RUN jenkins-plugin-cli --plugins "git docker-plugin"

# סיום
