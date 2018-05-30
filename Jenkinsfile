pipeline {
  agent any
  stages {
    stage('Build AMI') {
      steps {
        sh '/usr/local/bin/packer build -var aws_access_key=${AWS_KEY} -var aws_secret_key=${AWS_SECRET} perceive-base.json'
      }
    }
  }
}