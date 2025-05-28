pipeline {
  agent any

  environment {
    TF_VAR_region = 'us-east-1'
  }

  stages {
    stage('Checkout') {
      steps {
        git 'https://github.com/Sherif127/Jenkins-EC2.git'
      }
    }

    stage('Terraform Init & Apply') {
      steps {
        dir('terraform') {
          withCredentials([
            usernamePassword(
              credentialsId: 'aws-cr',
              usernameVariable: 'AWS_ACCESS_KEY_ID',
              passwordVariable: 'AWS_SECRET_ACCESS_KEY'
            )
          ]) {
            sh '''
              export AWS_ACCESS_KEY_ID=$AWS_ACCESS_KEY_ID
              export AWS_SECRET_ACCESS_KEY=$AWS_SECRET_ACCESS_KEY
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
            script: "cd terraform && terraform output -raw public_ip",
            returnStdout: true
          ).trim()

          writeFile file: 'ansible/inventory.ini', text: """
          [ec2]
          ${publicIp} ansible_user=ec2-user ansible_ssh_private_key_file=~/.ssh/mykey.pem
          """
        }
      }
    }

    stage('Run Ansible Playbook') {
      steps {
        sh 'ansible-playbook -i ansible/inventory.ini ansible/playbook.yml'
      }
    }
  }
}
