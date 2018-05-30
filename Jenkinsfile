pipeline {
  agent any
  stages {
    stage('Build AMI') {
      steps {
        withCredentials([
          usernamePassword(credentialsId: 'a77c8394-8156-4431-b4dd-96a3bf83f5e4', passwordVariable: 'AWS_SECRET', usernameVariable: 'AWS_KEY')
        ]) {
          sh '/usr/local/bin/packer build -var aws_access_key=${AWS_KEY} -var aws_secret_key=${AWS_SECRET} packer/perceive-base.json'
        }
      }
    }
  }
}