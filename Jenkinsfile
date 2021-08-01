pipeline {
    agent any
    checkout scm
    environment {
        imagename = "suryastef/simple-portofolio"
        registryCredential = 'suryastef-dockerhub'
        dockerImage = ''
    }
    stages {
        stage("Docker build") {
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