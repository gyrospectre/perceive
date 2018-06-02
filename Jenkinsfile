pipeline {
  agent any

  stages {
    stage('Build AMI') {
      when {
        environment name: 'REBUILD_AMI', value: 'True'
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
      stage('Deploy Instances') {
        steps {
          withCredentials(bindings: [[
                      $class: 'AmazonWebServicesCredentialsBinding',
                      credentialsId: 'aws-jenkins',
                      accessKeyVariable: 'AWS_ACCESS_KEY_ID',
                      secretKeyVariable: 'AWS_SECRET_ACCESS_KEY'
                    ]]) {
              sh '''
               cd terraform
               terraform init
               terraform apply -auto-approve -var access_key=${AWS_KEY} -var secret_key=${AWS_SECRET}
             '''
            }

          }
        }
        stage('Update Configs with Host IPs') {
          steps {
            sh '''
             cd terraform
             cat ../playbooks/hosts.template | sed "s/{CONFLUENT_IP}/$(terraform output confluent_ip)/g" | sed "s/{NIFI_IP}/$(terraform output nifi_ip)/g" | sed "s/{ELASTIC_IP}/$(terraform output elastic_ip)/g"> ../hosts.yml
             sed -i "s/{CONFLUENT_IP}/$(terraform output confluent_ip)/g" ../nificfg/flow.xml
             sed -i "s/{ELASTIC_IP}/$(terraform output elastic_ip)/g" ../nificfg/flow.xml
           '''
          }
        }
        stage('Pause') {
          steps {
            echo 'Waiting 15 seconds to allow instances to finish starting up...'
            sleep 15
          }
        }
        stage('Deploy Confluent') {
          parallel {
            stage('Deploy Confluent') {
              steps {
                ansiblePlaybook(playbook: 'playbooks/confluent.yml', credentialsId: 'ubuntu', disableHostKeyChecking: true, inventory: 'hosts.yml', become: true, becomeUser: 'root')
              }
            }
            stage('Deploy Nifi') {
              steps {
                ansiblePlaybook(playbook: 'playbooks/nifi.yml', credentialsId: 'ubuntu', disableHostKeyChecking: true, inventory: 'hosts.yml', become: true, becomeUser: 'root')
              }
            }
            stage('Deploy ElasticSearch') {
              steps {
                ansiblePlaybook(playbook: 'playbooks/elastic.yml', credentialsId: 'ubuntu', disableHostKeyChecking: true, inventory: 'hosts.yml', become: true, becomeUser: 'root')
              }
            }
          }
        }
        stage('Configure Confluent') {
          steps {
            ansiblePlaybook(playbook: 'playbooks/confluent-setup.yml', credentialsId: 'ubuntu', disableHostKeyChecking: true, inventory: 'hosts.yml', become: true, becomeUser: 'root')
          }
        }
        stage('Configure DNS') {
          steps {
            sh 'python dns/ansible-host-to-zone.py --hosts hosts.yml --zone dns/db.perceive.internal.head'
            ansiblePlaybook(playbook: 'playbooks/update-dns.yml', credentialsId: 'rasppi', disableHostKeyChecking: true, inventory: 'hosts.yml', become: true, becomeUser: 'root')
          }
        }
      }
      environment {
        REBUILD_AMI = 'False'
        ANSIBLE_HOST_KEY_CHECKING = 'False'
      }
    }