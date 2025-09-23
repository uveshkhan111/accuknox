pipeline {
    agent any

    environment {
        DOCKER_USER = "uveshkhan"
        DOCKER_PASS = credentials('docker-hub-password') // Replace with your Jenkins DockerHub credentials ID
        IMAGE_NAME = "uveshkhan/accuknox"
        IMAGE_TAG  = "v5"
        KUBE_CONFIG_CREDENTIALS = 'kubeconfig-cred-id' // Replace with your Jenkins kubeconfig credentials ID
    }

    stages {
        stage('Checkout SCM') {
            steps {
                git url: 'https://github.com/uveshkhan111/accuknox.git', branch: 'main'
            }
        }

        stage('Build Docker Image') {
            steps {
                sh "docker build -t ${IMAGE_NAME}:${IMAGE_TAG} ."
            }
        }

        stage('Push Docker Image') {
            steps {
                withCredentials([string(credentialsId: 'docker-hub-password', variable: 'DOCKER_PASS')]) {
                    sh "echo \$DOCKER_PASS | docker login -u ${DOCKER_USER} --password-stdin"
                }
                sh "docker tag ${IMAGE_NAME}:${IMAGE_TAG} ${IMAGE_NAME}:latest"
                sh "docker push ${IMAGE_NAME}:${IMAGE_TAG}"
                sh "docker push ${IMAGE_NAME}:latest"
            }
        }

        stage('Deploy to Kubernetes') {
            steps {
                withKubeConfig([credentialsId: "${KUBE_CONFIG_CREDENTIALS}"]) {
                    // Using kubectl inside a Docker container
                    sh """
                        docker run --rm -v \$HOME/.kube:/root/.kube bitnami/kubectl:latest apply -f k8s/deploysvc.yml
                    """
                }
            }
        }
    }

    post {
        success {
            echo "Pipeline finished successfully!"
        }
        failure {
            echo "Pipeline failed!"
        }
    }
}
