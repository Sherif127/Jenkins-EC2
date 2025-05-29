pipeline {
  agent any

  environment {
    TF_VAR_region = 'us-east-1'
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
          string(credentialsId: 'AWS_ACCESS_KEY_ID', variable: 'AWS_ACCESS_KEY_ID'),
          string(credentialsId: 'AWS_SECRET_ACCESS_KEY', variable: 'AWS_SECRET_ACCESS_KEY'),
          string(credentialsId: 'AWS_SESSION_TOKEN', variable: 'AWS_SESSION_TOKEN')
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
