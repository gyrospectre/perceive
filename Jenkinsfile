pipeline {
  agent any
  stages {
    stage('Build AMI') {
      steps {
        withCredentials([[
          $class: 'AmazonWebServicesCredentialsBinding',
          credentialsId: 'aws-jenkins',
          accessKeyVariable: 'AWS_ACCESS_KEY_ID',
          secretKeyVariable: 'AWS_SECRET_ACCESS_KEY'
        ]])
        {
          sh '/usr/local/bin/packer build -var aws_access_key=${AWS_KEY} -var aws_secret_key=${AWS_SECRET} packer/perceive-base.json'
        }
      }
    }
    stage('Deploy Confluent') {
      steps {
        ansiblePlaybook(playbook: 'playbooks/kafka.yml', credentialsId: 'ssh', disableHostKeyChecking: true, inventory: '/home/billm/hosts.yml', sudo: true, sudoUser: 'root')
      }
    }
  }
}