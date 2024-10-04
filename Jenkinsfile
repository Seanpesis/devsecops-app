pipeline {
    agent any
    stages {
        stage('Checkout') {
            steps {
                git 'https://github.com/seanpesis/devsecops-app.git'
            }
        }
        stage('Build') {
            agent {
                docker {
                    image 'node:14'
                }
            }
            steps {
                sh 'npm install'
            }
        }
        stage('Test') {
            agent {
                docker {
                    image 'node:14'
                }
            }
            steps {
                sh 'npm test'
            }
        }
        // שאר השלבים נשארים ללא שינוי
        stage('Static Code Analysis') {
            steps {
                withSonarQubeEnv('SonarQube') {
                    sh '''
                    sonar-scanner \
                      -Dsonar.projectKey=devsecops-app \
                      -Dsonar.sources=. \
                      -Dsonar.host.url=$SONARQUBE_URL \
                      -Dsonar.login=$SONARQUBE_AUTH_TOKEN
                    '''
                }
            }
        }
        stage('Docker Build') {
            steps {
                sh 'docker build -t devsecops-app:$BUILD_NUMBER .'
            }
        }
        stage('Docker Scan') {
            steps {
                sh 'trivy image --exit-code 1 devsecops-app:$BUILD_NUMBER || true'
            }
        }
        stage('Push Image') {
            steps {
                sh 'docker tag devsecops-app:$BUILD_NUMBER your_dockerhub_username/devsecops-app:$BUILD_NUMBER'
                sh 'docker push your_dockerhub_username/devsecops-app:$BUILD_NUMBER'
            }
        }
        stage('Deploy to Kubernetes') {
            steps {
                sh 'kubectl apply -f k8s/'
            }
        }
    }
}
