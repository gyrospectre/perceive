pipeline {
  agent any

  environment {
    REBUILD_AMI = 'False'
    ANSIBLE_HOST_KEY_CHECKING = 'False'
  }

  stages {
    stage('Build AMI') {
      when {
        environment name: 'REBUILD_AMI', value: 'True'
      }
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
    stage('Deploy Instances') {
      steps {
        withCredentials([[
          $class: 'AmazonWebServicesCredentialsBinding',
          credentialsId: 'aws-jenkins',
          accessKeyVariable: 'AWS_ACCESS_KEY_ID',
          secretKeyVariable: 'AWS_SECRET_ACCESS_KEY'
        ]])
        {
          sh '''
               cd terraform
               terraform init
               terraform apply -auto-approve -var access_key=${AWS_KEY} -var secret_key=${AWS_SECRET}
             '''
        }
      }
    }
    stage('Build Hosts File') {
      steps {
        sh '''
             cd terraform
             cat ../playbooks/hosts.template | sed "s/{CONFLUENT_IP}/$(terraform output confluent_ip)/g" > ../hosts.yml
           '''
      }
    }
    stage('Deploy Confluent') {
      steps {
        ansiblePlaybook(playbook: 'playbooks/confluent.yml', credentialsId: 'ubuntu', disableHostKeyChecking: true, inventory: 'hosts.yml', become: true, becomeUser: 'root')
      }
    }
  }
}