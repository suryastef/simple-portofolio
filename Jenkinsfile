pipeline {
    agent any
    environment {
        imagename = "suryastef/simple-portofolio"
        registryCredential = 'suryastef-dockerhub'
        dockerImage = ''
    }
    stages {
        stage("Build") {
            steps {
              script {
                  dockerImage = docker.build imagename
              }
            }
        }
        stage("Unit test") {
            steps {
              script{
                dockerImage.inside {
                    'php artisan test'
                }
              }
            }
        }
        stage("Push to registry") {
            steps {
              script{
                docker.withRegistry( '', registryCredential ) {
                    dockerImage.push("$BUILD_NUMBER")
                    dockerImage.push('latest')
                }
              }
            }
        }
        stage("Deploy") {
            steps {
                sh "ansible-playbook /etc/ansible/playbook/playbook-production-run.yml"
            }
        }
        stage('Remove Unused docker image') {
            steps{
              sh "docker rmi $imagename:$BUILD_NUMBER"
              sh "docker rmi $imagename:latest"
            }
        }
    }
}