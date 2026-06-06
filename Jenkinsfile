pipeline {
    agent any

    environment {
        // Ensure these credentials are created in Jenkins with these IDs
        AWS_ACCESS_KEY_ID     = credentials('aws-access-key')
        AWS_SECRET_ACCESS_KEY = credentials('aws-creds')
        // Name of the SSH Key Pair in AWS
        TF_VAR_key_name       = 'jenkins-key' 
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
                    sh 'terraform init -upgrade'
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
                    sh 'terraform apply -auto-approve tfplan'
                    script {
                        def serverIp = sh(
                            script: 'terraform output -raw instance_public_ip',
                            returnStdout: true
                        ).trim()
                        env.SERVER_IP = serverIp
                        echo "EC2 Server IP: ${env.SERVER_IP}"

                        // Save IP to a shared file
                        sh "echo ${serverIp} > /var/lib/jenkins/ec2_ip.txt"
                    }
                }
            }
        }

        stage('Ansible Configuration') {
            steps {
                dir('ansible') {
                    script {
                        echo "Configuring Server at IP: ${env.SERVER_IP}"
                        sh "echo '[webservers]\n${env.SERVER_IP}' > inventory.ini"
                    }
                    sh """
                        ansible-playbook -i inventory.ini playbook.yml \
                            -u ubuntu \
                            --private-key /var/lib/jenkins/jenkins-key.pem \
                            --ssh-common-args='-o StrictHostKeyChecking=no'
                    """
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
