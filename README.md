# perceive

Setup doco to do.

But, at a high level:

Setup a build machine on your home network.
 - Install Jenkins, don't use docker as it makes it hard to use ansible
 - Install Ansible
 - Install packer
 - Install OpenLDAP

Setup a DNS server on your home network (I use a Rpi, don't need anything big):
 - Install BIND
 - Setup initial zone for perceive.internal

Setup AWS:
- Login to AWS console.
- Select VPC from services.
- Create default VPC, under actions.
- Go to subnets, remove all but the one /20 - 172.31.0.0/20
- Create IAM group called "build", with one policy "AmazonEC2FullAccess"
- Create a new IAM user called jenkins, in this group.
- In VPCs, create new customer GW for your public IP.
- New Virtual Private GW - default ASN
- New VPN. Download PFSense config

Jenkins setup:
 - Install recommended plugins, plus:
    - Blue Ocean
    - Ansible
    - packer
    - CloudBees Amazon Web Services Credentials
    - Build Cause Run Condition
    - Run Condition
 - Configure creds for AWS and DNS server (SSH)
 - Configure new project in Blue Ocean pointed to your cloned Github repo

Install Winlogbeat on a Windows machine. In the config file, in the Kafka section:
  output.kafka:
  hosts: ["confluent.perceive.internal:9092"]

Setup a PFSense FW on your home network. This will provide th VPN to AWS. Use the exported VPN config to setup IPSec.

Then, you can (finally!), run a build. All this above is one time setup, though I tear down all the AWS and VPN after I'm finished playing.


