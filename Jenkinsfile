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
              withCredentials([usernamePassword(credentialsId: 'Vijay@3247',
                                  usernameVariable: 'vijay3247',
                                  passwordVariable: 'Vijay@3247')]) {
    sh """
        echo "$DOCKER_PASS" | docker login -u "$DOCKER_USER" --password-stdin
        docker push vijay3247/prime-clone:latest
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
