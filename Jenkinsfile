pipeline {
    agent any
    tools {
        nodejs "nodejs-20" // שם ההתקנה שהגדרת במנהל הכלים
    }
    environment {
        PATH = "${tool 'nodejs-20'}/bin:${env.PATH}:./node_modules/.bin"
    }
    stages {
        stage('Checkout') {
            steps {
                git credentialsId: 'github-token', url: 'https://github.com/seanpesis/devsecops-app.git', branch: 'master'
            }
        }
        stage('Build') {
            steps {
                sh 'npm install'
            }
        }
        stage('Test') {
            steps {
                // שינוי הרשאות ל-Jest אם נדרש
                sh 'chmod +x node_modules/.bin/jest'
                // שימוש ב-npx להרצת Jest
                sh 'npx jest'
                // לחלופין, ניתן להשתמש ב: sh 'jest'
            }
        }
        // שלבים נוספים ניתן להוסיף כאן...
    }
    post {
        always {
            // פעולות לאחר כל בנייה, כמו ניקוי או דיווח
            echo 'Pipeline completed.'
        }
        failure {
            // פעולות במקרה של כשל בבנייה
            echo 'Pipeline failed.'
        }
    }
}
