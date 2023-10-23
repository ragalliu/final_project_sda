#!/usr/bin/env groovy
def dbport = ""
def dburl = ""
def repourl = ""
def dbuser = ""
def dbpass = ""
def bucketname = ""
def clustername = ""
def imageurl = ""
def dmname = ""
def apiurl = ""
def getCommitSha() {
  return sh(returnStdout: true, script: 'git rev-parse HEAD')
}
pipeline {
    agent any
    environment {
        AWS_ACCESS_KEY_ID = credentials('AWS_ACCESS_KEY_ID')
        AWS_SECRET_ACCESS_KEY = credentials('AWS_SECRET_ACCESS_KEY')
        AWS_DEFAULT_REGION = "eu-north-1"
        ACCOUNT_ID = credentials('ACCOUNT_ID')
    }
    stages {
        stage("Create Infrastucture") {
            steps {
                script {
                    dir('infrastucture') {
                        sh 'terraform init'
                        sh 'terraform apply --auto-approve'
                        dbport = sh(script : 'terraform output DB_PORT', returnStdout : true).trim()
                        dburl  = sh(script : 'terraform output DB_HOST', returnStdout : true).trim()
                        dbuser = sh(script : 'terraform output DB_USERNAME', returnStdout : true).trim()
                        dbpass = sh(script : 'terraform output DB_PASSWORD', returnStdout : true).trim()
                        repourl = sh(script : 'terraform output ECR_REPOSITORY_URL', returnStdout : true).trim()
                        bucketname = sh(script : 'terraform output WEB_CLIENT_BUCKET_NAME', returnStdout : true).trim()
                        clustername = sh(script : 'terraform output EKS_CLUSTER_NAME', returnStdout : true).trim()
                        dbname = sh(script: 'terraform output DB_NAME', returnStdout : true).trim()


                    }
                }
            }
        }
        stage("Build & Push to ECR") {
            environment {
                IMAGE_TAG=getCommitSha() 
                // ECR_REPOSITORY_URL = $repourl
            }
            steps  {
                script {
                    dir('api') {
                    sh "aws ecr get-login-password --region ${AWS_DEFAULT_REGION} | docker login --username AWS --password-stdin ${ACCOUNT_ID}.dkr.ecr.${AWS_DEFAULT_REGION}.amazonaws.com"
                    sh 'docker build -t myimg . '
                    sh "docker tag myimg ${repourl}:${IMAGE_TAG}"
                    imageurl = sh(script : "echo ${repourl}:${IMAGE_TAG}",returnStdout: true).trim()
                    sh "docker push ${repourl}:${IMAGE_TAG}"
                    }
                }
            }
        }
        stage("Deploy to EKS") {
            environment{
                IMAGE_URL = "${imageurl}"
                DATABASE_HOST = "${dburl}"
                DATABASE_PORT = "${dbport}"
                DATABASE_USER = "${dbuser}"
                DATABASE_PASSWORD = "${dbpass}"
                DATABASE_NAME = "${dbname}"


            }
            steps {
                script {
                    dir('kubernetes') {
                        echo env.IMAGE_URL
                        echo env.DATABASE_HOST
                        echo env.DATABASE_PORT
                        sh "aws eks update-kubeconfig --name ${clustername}"
                        sh 'envsubst < deployment.yaml > deploysub.yaml'
                        sh 'kubectl apply -f deploysub.yaml'
                        sh 'kubectl apply -f service.yaml'
                        apiurl = sh(script: 'kubectl get service api -o jsonpath={.status.loadBalancer.ingress[0].hostname}' , returnStdout : true ).trim()
                        
                    }
                }
            }
        }
        stage('Build Web Client') {
            environment{
                REACT_APP_SERVER_URL = "http://${apiurl}"

            }
            steps{
                script{
                    dir('web_client'){
                        sh 'npm install'
                        sh 'npm run build'
                        sh "aws s3 sync ./build/ s3://${bucketname} --delete"
                    }

                }
            }
        }
        stage('Destroy infrastructure') {
            input {
                message "Destroy Infrastructure?"
                ok "Yes"
            }
            steps{
                dir('infrastucture'){
                    sh "aws s3 rm s3://${bucketname} --recursive"
                    sh 'terraform destroy --auto-approve'
                }
            }

        }
    }
}