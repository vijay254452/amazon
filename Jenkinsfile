pipeline {
    agent any

    environment {
        IMAGE_NAME = "prime-clone"
        DOCKER_REGISTRY = "vijay3247/${IMAGE_NAME}"
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
                sh 'docker build -t ${DOCKER_REGISTRY}:latest .'
            }
        }

        stage('Push Docker Image') {
            steps {
                withCredentials([string(credentialsId: 'dockerhub-pass', variable: 'Vijay@3247')]) {
                    sh """
                        echo $DOCKER_PASS | docker login -u vijay3247 --password-stdin
                        docker push ${DOCKER_REGISTRY}:latest
                    """
                }
            }
        }

        stage('Deploy') {
            steps {
                sh """
                    docker stop prime-clone || true
                    docker rm prime-clone || true
                    docker run -d --name prime-clone -p 8077:8080 ${DOCKER_REGISTRY}:latest
                """
            }
        }
    }
}
