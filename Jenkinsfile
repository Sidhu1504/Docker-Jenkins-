pipeline {
  agent any

  environment {
    REGISTRY = 'docker.io/sidhu1504/docker-jenkins-cicd' // change this to your repo
  }

  stages {
    stage('Checkout') {
      steps {
        checkout scm
        script {
          COMMIT = sh(returnStdout: true, script: 'git rev-parse --short HEAD').trim()
          BUILD_TAG = "build-${env.BUILD_NUMBER}-${COMMIT}"
          env.BUILD_TAG = BUILD_TAG
          echo "Build tag will be: ${BUILD_TAG}"
        }
      }
    }

    stage('Build Image') {
      steps {
        sh "docker build -t ${REGISTRY}:${BUILD_TAG} ."
        sh "docker tag ${REGISTRY}:${BUILD_TAG} ${REGISTRY}:latest"
      }
    }

    stage('Push Image') {
      steps {
        withCredentials([usernamePassword(credentialsId: 'docker-creds', usernameVariable: 'DOCKER_USER', passwordVariable: 'DOCKER_PASS')]) {
          sh 'echo $DOCKER_PASS | docker login -u $DOCKER_USER --password-stdin'
          sh "docker push ${REGISTRY}:${BUILD_TAG}"
          sh "docker push ${REGISTRY}:latest"
        }
      }
    }

    stage('Deploy (local)') {
      steps {
        sh "docker pull ${REGISTRY}:${BUILD_TAG}"
        sh "docker stop myapp || true"
        sh "docker rm myapp || true"
        sh "docker run -d --name myapp -p 28080:80 ${REGISTRY}:${BUILD_TAG}"
      }
    }
  }

  post {
    always {
      sh 'docker logout || true'
    }
  }
}
