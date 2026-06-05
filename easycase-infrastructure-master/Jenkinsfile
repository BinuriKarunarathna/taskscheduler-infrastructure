pipeline {
    agent any

    environment {
        // Ensure these credentials are created in Jenkins with these IDs
        AWS_ACCESS_KEY_ID     = credentials('aws-access-key-id')
        AWS_SECRET_ACCESS_KEY = credentials('aws-secret-access-key')
        // Name of the SSH Key Pair in AWS
        TF_VAR_key_name       = 'easycase-key' 
    }

    stages {
        stage('Checkout') {
            steps {
                checkout scm
            }
        }

        stage('Terraform Init & Validate') {
            steps {
                dir('terraform') {
                    sh 'terraform init'
                    sh 'terraform validate'
                }
            }
        }

        stage('Terraform Plan') {
            steps {
                dir('terraform') {
                    sh 'terraform plan -out=tfplan'
                }
            }
        }

        stage('Terraform Apply') {
            steps {
                dir('terraform') {
                    // Apply the plan
                    sh 'terraform apply -auto-approve tfplan'
                    
                    // Extract the public IP to use in Ansible
                    script {
                        def serverIp = sh(script: "terraform output -raw instance_public_ip", returnStdout: true).trim()
                        env.SERVER_IP = serverIp
                    }
                }
            }
        }

        stage('Ansible Configuration') {
            steps {
                dir('ansible') {
                    script {
                        echo "Configuring Server at IP: ${env.SERVER_IP}"
                        
                        // Create a temporary inventory file with the dynamic IP
                        sh "echo '[webservers]\n${env.SERVER_IP}' > inventory.ini"
                    }
                    
                    // Run the playbook
                    // 'ec2-ssh-key' should be the ID of the private key credential in Jenkins
                    sshagent(['ec2-ssh-key']) {
                        // Assuming 'ubuntu' user for the AMI. Change to 'ec2-user' for Amazon Linux
                        sh "ansible-playbook -i inventory.ini playbook.yml -u ubuntu --ssh-common-args='-o StrictHostKeyChecking=no'"
                    }
                }
            }
        }
    }

    post {
        cleanup {
            cleanWs()
        }
    }
}
