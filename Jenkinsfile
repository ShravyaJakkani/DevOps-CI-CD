pipeline {
    agent any

    environment {
        IMAGE_NAME = "jakkani7/my-k8s-app:latest"
    }

    stages {

        stage('Build Docker Image') {
            steps {
                sh 'docker build -t $IMAGE_NAME .'
            }
        }

        stage('Login to DockerHub') {
            steps {
                withCredentials([usernamePassword(
                    credentialsId: 'dockerhub-creds',
                    usernameVariable: 'DOCKER_USER',
                    passwordVariable: 'DOCKER_PASS'
                )]) {
                    sh 'echo $DOCKER_PASS | docker login -u $DOCKER_USER --password-stdin'
                }
            }
        }

        stage('Push Docker Image') {
            steps {
                sh 'docker push $IMAGE_NAME'
            }
        }

        stage('Deploy to Kubernetes') {
            steps {
                // Use workspace-local folders to avoid Minikube lock permission errors
                withEnv([
                    "MINIKUBE_HOME=$WORKSPACE/.minikube",
                    "XDG_RUNTIME_DIR=$WORKSPACE/tmp"
                ]) {
                    sh 'mkdir -p $XDG_RUNTIME_DIR'
                    sh 'minikube kubectl -- download' // optional: pre-download kubectl
                    sh 'minikube kubectl -- apply -f k8s/'
                    sh 'minikube kubectl -- rollout restart deployment my-k8s-app-deployment'
                }
            }
        }
    }
}
