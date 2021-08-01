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
                checkout scm
                sh 'php --version'
                sh 'composer install'
                sh 'composer --version'
                sh 'cp .env.example .env'
                sh 'php artisan key:generate'
                sh 'cp .env .env.testing'
                sh 'php artisan migrate'
            }
        }
        stage("Unit test") {
            steps {
                sh 'php artisan test'
            }
        }
        stage("Docker build") {
            steps {
              script {
                  dockerImage = docker.build imagename
              }
            }
        }
        stage("Docker push") {
            steps {
              script{
                docker.withRegistry( '', registryCredential ) {
                    dockerImage.push("$BUILD_NUMBER")
                    dockerImage.push('latest')
                }
              }
            }
        }
        // stage("Release") {
        //     steps {
        //         sh "export AWS_ACCESS_KEY_ID=${AWS_ACCESS_KEY_ID}"
        //         sh "export AWS_SECRET_ACCESS_KEY=${AWS_SECRET_ACCESS_KEY}"
        //         sh "export AWS_SESSION_TOKEN=${AWS_SESSION_TOKEN}"
        //         sh "ssh-agent sh -c 'ssh-add /etc/ansible/pem/key.pem && ansible-playbook /etc/ansible/playbook/playbook-production-run.yml'"
        //     }
        // }
        // stage('Remove Unused docker image') {
        //     steps{
        //       sh "docker rmi $imagename:$BUILD_NUMBER"
        //       sh "docker rmi $imagename:latest"
        //     }
        // }
    }
}