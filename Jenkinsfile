pipeline {
    agent any
    tools {
        nodejs "nodejs-20" 
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
                sh 'chmod +x node_modules/.bin/jest'
                sh 'npx jest'
            }
        }
    }
    post {
        always {
            echo 'Pipeline completed.'
        }
        failure {
            echo 'Pipeline failed.'
        }
    }
}
