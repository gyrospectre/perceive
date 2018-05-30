pipeline {
  agent any
  stages {
    stage('Build AMI') {
      when {
        tag 'rebuild'
      }
      steps {
        withCredentials(bindings: [[
                    $class: 'AmazonWebServicesCredentialsBinding',
                    credentialsId: 'aws-jenkins',
                    accessKeyVariable: 'AWS_ACCESS_KEY_ID',
                    secretKeyVariable: 'AWS_SECRET_ACCESS_KEY'
                  ]]) {
            sh '/usr/local/bin/packer build -var aws_access_key=${AWS_KEY} -var aws_secret_key=${AWS_SECRET} packer/perceive-base.json'
          }

        }
      }
      stage('Deploy Confluent') {
        steps {
          ansiblePlaybook(playbook: 'playbooks/kafka.yml', credentialsId: 'ubuntu', disableHostKeyChecking: true, inventory: '192.168.1.4', become: true, becomeUser: 'root', dynamicInventory: true)
        }
      }
    }
  }