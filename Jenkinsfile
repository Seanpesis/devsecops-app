pipeline {
    agent any
    stages {
        stage('Checkout') {
            steps {
                git credentialsId: 'github-token', url: 'https://github.com/seanpesis/devsecops-app.git'
            }
        }
        stage('Build') {
            agent {
                docker {
                    image 'node:14'
                    args '-v /var/run/docker.sock:/var/run/docker.sock'
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
                    args '-v /var/run/docker.sock:/var/run/docker.sock'
                }
            }
            steps {
                sh 'npm test'
            }
        }
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
                sh 'docker tag devsecops-app:$BUILD_NUMBER seanpe/devsecops-app:$BUILD_NUMBER'
                sh 'docker push seanpe/devsecops-app:$BUILD_NUMBER'
            }
        }
        stage('Deploy to Kubernetes') {
            steps {
                sh 'kubectl apply -f k8s/'
            }
        }
    }
}
