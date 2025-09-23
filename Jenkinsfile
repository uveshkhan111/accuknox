pipeline {
    agent any

    environment {
        DOCKER_USER = "uveshkhan"
        DOCKER_PASS = credentials('docker-hub-password') // Make sure this ID exists in Jenkins
        IMAGE_NAME = "uveshkhan/accuknox"
        IMAGE_TAG = "v5"
    }

    stages {
        stage('Checkout') {
            steps {
                git(
                    url: 'https://github.com/uveshkhan111/accuknox.git',
                    branch: 'main'
                )
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    sh "docker build -t ${IMAGE_NAME}:${IMAGE_TAG} ."
                    sh "docker tag ${IMAGE_NAME}:${IMAGE_TAG} ${IMAGE_NAME}:latest"
                }
            }
        }

        stage('Push Docker Image') {
            steps {
                script {
                    withCredentials([usernamePassword(credentialsId: 'docker-hub-password', usernameVariable: 'DOCKER_USERNAME', passwordVariable: 'DOCKER_PASSWORD')]) {
                        sh 'echo $DOCKER_PASSWORD | docker login -u $DOCKER_USERNAME --password-stdin'
                        sh "docker push ${IMAGE_NAME}:${IMAGE_TAG}"
                        sh "docker push ${IMAGE_NAME}:latest"
                    }
                }
            }
        }

        stage('Deploy to Kubernetes') {
            steps {
                script {
                    // Make sure kubectl is installed on Jenkins agent
                    withKubeConfig([credentialsId: 'kubeconfig-id']) {
                        sh "kubectl apply -f k8s/deploysvc.yml"
                    }
                }
            }
        }
    }

    post {
        success {
            echo 'Pipeline completed successfully!'
        }
        failure {
            echo 'Pipeline failed!'
        }
    }
}
