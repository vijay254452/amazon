pipeline {
    agent any

    environment {
        DOCKER_IMAGE = "prime-clone"
        DOCKER_TAG   = "latest"
        DOCKER_USER  = credentials('dockerhub-pass')
    }

    stages {
        stage('Build Docker Image') {
            steps {
                sh '''
                    docker rmi -f amazon || true
                    docker build -t vijay3247/${DOCKER_IMAGE}:${DOCKER_TAG} -f /var/lib/jenkins/workspace/amazon/Dockerfile /var/lib/jenkins/workspace/amazon
                '''
            }
        }

        stage('Push Docker Image') {
            steps {
                withCredentials([usernamePassword(
                    credentialsId: 'dockerhub-pass',
                    usernameVariable: 'DOCKER_USER',
                    passwordVariable: 'DOCKER_PASS'
                )]) {
                    sh """
                        echo "$DOCKER_PASS" | docker login -u "$DOCKER_USER" --password-stdin
                        docker push vijay3247/${DOCKER_IMAGE}:${DOCKER_TAG}
                    """
                }
            }
        }

        stage('Deploy') {
            steps {
                sh """
                    docker stop prime-clone || true
                    docker rm prime-clone || true
                    docker run -d --name prime-clone -p 8077:8080 vijay3247/${DOCKER_IMAGE}:${DOCKER_TAG}
                """
            }
        }

        stage('Docker Swarm Deploy') {
            steps {
                sh """
                    if docker service ls --format '{{.Name}}' | grep -q '^myservice\$'; then
                        echo "Updating existing service..."
                        docker service update --image vijay3247/${DOCKER_IMAGE}:${DOCKER_TAG} myservice
                    else
                        echo "Creating new service..."
                        docker service create --name myservice -p 8077:8080 vijay3247/${DOCKER_IMAGE}:${DOCKER_TAG}
                    fi
                """
            }
        }
    }
}
