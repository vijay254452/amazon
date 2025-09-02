pipeline {
    agent any

    environment {
        IMAGE_NAME = "prime-clone"
        DOCKER_REGISTRY = "vijay3247/prime-clone"
        DOCKER_IMAGE = "vijay3247/prime-clone"
        DOCKER_TAG   = "latest"
    }

    stages {
        stage('Checkout') {
            steps {
                git branch: 'main',
                    url: 'https://github.com/vijay254452/amazon.git'
            }
        }

        stage('Build with Maven') {
            steps {
                sh 'mvn clean package -DskipTests'
            }
        }

        stage('Run Tests') {
            steps {
                sh 'mvn test'
            }
        }

       stage('Build Docker Image') {
            steps {
                sh '''
                    docker rmi -f amazon || true
                    docker build -t amazon -f /var/lib/jenkins/workspace/amazon/Dockerfile /var/lib/jenkins/workspace/amazon
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
                   docker push ${DOCKER_IMAGE}:${DOCKER_TAG}
                    """

                }
            }
        }

        stage('Deploy') {
            steps {
                sh """
                    docker stop prime-clone || true
                    docker rm prime-clone || true
                    docker run -d --name prime-clone -p 8077:8080 ${ DOCKER_REGISTRY}:latest
                """
            }
        }
        stage('Docker Swarm Deploy') {
            steps {
                   sh """
                 docker service update --image vijay3247/${DOCKER_IMAGE}:${DOCKER_TAG} myservice
                    docker service create --name amazonserv -p 8078:8080 --replicas=10 vijay3247/prime-clone
                   """
     }
  }
}
}
