pipeline {
  agent any

  environment {
    TF_VAR_region = 'us-east-1'
    ANSIBLE_HOST_KEY_CHECKING = 'False'
  }

  stages {
    stage('Checkout') {
      steps {
        git branch: 'main', url: 'https://github.com/Sherif127/Jenkins-EC2.git', credentialsId: 'github-cr'
      }
    }

    stage('Terraform Init & Apply') {
      steps {
        withCredentials([
          string(credentialsId: 'aws-access-key', variable: 'AWS_ACCESS_KEY_ID'),
          string(credentialsId: 'aws-secret-key', variable: 'AWS_SECRET_ACCESS_KEY'),
          string(credentialsId: 'aws-session-token', variable: 'AWS_SESSION_TOKEN')
        ]) {
          dir('terraform') {
            sh '''
              export AWS_ACCESS_KEY_ID=$AWS_ACCESS_KEY_ID
              export AWS_SECRET_ACCESS_KEY=$AWS_SECRET_ACCESS_KEY
              export AWS_SESSION_TOKEN=$AWS_SESSION_TOKEN

              terraform init
              terraform apply -auto-approve
            '''
          }
        }
      }
    }

    stage('Generate Inventory') {
      steps {
        script {
          def publicIp = sh(
            script: "cd terraform && terraform output -raw aws_instance_ip",
            returnStdout: true
          ).trim()

          writeFile file: 'ansible/inventory.ini', text: """
[ec2]
${publicIp} ansible_user=ec2-user
"""
        }
      }
    }

    stage('Run Ansible Playbook') {
      steps {
        sshagent(credentials: ['ec2-ssh-key']) {
          sh '''
            ansible-playbook -i ansible/inventory.ini ansible/playbook.yml
          '''
        }
      }
    }
  }
}
