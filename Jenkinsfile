pipeline {
    agent any

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
                      -Dsonar.host.url=$SONAR_HOST_URL \
                      -Dsonar.login=$SONAR_AUTH_TOKEN
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
                withCredentials([usernamePassword(credentialsId: 'dockerhub-credentials', usernameVariable: 'DOCKERHUB_USERNAME', passwordVariable: 'DOCKERHUB_PASSWORD')]) {
                    sh 'echo $DOCKERHUB_PASSWORD | docker login -u $DOCKERHUB_USERNAME --password-stdin'
                    sh 'docker tag devsecops-app:$BUILD_NUMBER $DOCKERHUB_USERNAME/devsecops-app:$BUILD_NUMBER'
                    sh 'docker push $DOCKERHUB_USERNAME/devsecops-app:$BUILD_NUMBER'
                }
            }
        }
        stage('Deploy to Kubernetes') {
            steps {
                sh 'kubectl apply -f k8s/'
            }
        }
    }
}
