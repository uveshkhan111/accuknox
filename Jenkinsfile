pipeline {
    agent any

    environment {
        DOCKER_IMAGE = "uveshkhan/accuknox"
        DOCKER_TAG = "v5"
    }

    stages {
        stage('Checkout') {
            steps {
                git branch: 'main', url: 'https://github.com/uveshkhan111/accuknox.git'
            }
        }

        stage('Build & Push Docker Image') {
            steps {
                script {
                    docker.withRegistry('https://index.docker.io/v1/', 'dockerhub-credentials') {
                        def app = docker.build("${DOCKER_IMAGE}:${DOCKER_TAG}")
                        app.push()
                        app.push("latest")
                    }
                }
            }
        }

        stage('Deploy to Kubernetes') {
            steps {
                withKubeConfig([credentialsId: 'kubeconfig', contentType: 'file']) {
                    kubernetesDeploy(
                        configs: 'k8s/deploysvc.yaml',
                        kubeconfigId: 'kubeconfig'
                    )
                }
            }
        }
    }
}
