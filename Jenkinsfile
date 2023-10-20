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
    }
    stages {
        stage("Create Infrastucture") {
            steps {
                script {
                    dir('infrastucture') {
                        sh 'terraform init'
                        sh 'terraform apply --auto-approve'
                        dbport = sh(script : '$(terraform output DB_PORT)', returnStdOut : True).trim()
                        sh "dburl = $(terraform output DB_HOST)"
                        sh "dbuser = $(terraform output DB_USERNAME)"
                        sh "dbpass = $(terraform output DB_PASSWORD)"
                        sh "repourl = $(terraform output ECR_REPOSITORY_URL)"
                        sh "bucketname = $(terraform output WEB_CLIENT_BUCKET_NAME)"
                        sh "clustername = $(terraform output EKS_CLUSTER_NAME)"
                        sh "dbname = $(terraform output DB_NAME)"


                    }
                }
            }
        }
        stage("Build & Push to ECR") {
            environment {
                IMAGE_TAG=getCommitSha()
                ECR_REPOSITORY_URL="${repourl}"
            }
            steps  {
                script {
                    dir('api')
                    sh 'aws ecr get-login-password --region eu-north-1 | docker login --username AWS --password-stdin 129392916120.dkr.ecr.eu-north-1.amazonaws.com'
                    sh 'docker build -t $ECR_REPOSITORY_URL:$IMAGE_TAG .'
                    imageurl = "${ECR_REPOSITORY_URL}:${IMAGE_TAG}"
                    sh 'docker push $imageurl'
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
                        sh 'aws eks update-kubeconfig --name $clustername'
                        sh 'envsubst < api.yaml | kubectl apply -f'
                        sh 'apiurl = $(kubectl get service api -o jsonpath={.status.loadBalancer.ingress[0].hostname})'
                        
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
                        sh 'aws s3 sync ./build/ s3://$bucketname --delete'
                    }

                }
            }
        }
    }
}