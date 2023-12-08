pipeline {
    agent {label "DOCKER"}
    triggers{pollSCM('* * * * *')}
    stages {
        stage('clean work space'){
            steps{
                cleanWs()
            }
        }
        stage('git checkout main'){
            steps{
                 git url:'https://github.com/batchusivaji/argocd.git' ,
                     branch: 'main'
            }
        }
        stage('docker image build and push'){
            steps{
                sh "docker image build -t batchusivaji/argocd:v.${BUILD_ID} ."
                withCredentials([string(credentialsId: 'DOCKER', variable: 'docker')]) {
                  sh 'docker login -u batchusivaji -p $docker'
                  sh 'docker image push batchusivaji/argocd:v.${BUILD_ID}'
                }
              
            }
        }
        stage('deploy manifest files'){
            steps{
                dir('orderapps'){
                sh "cd ~/argocd/deploy && yq eval -i '.spec.template.spec.containers[0].image= \"batchusivaji/argocd:v.${BUILD_ID}\" ' ~/argocd/manifests/order.yaml"
                sh"""
                  ~/argocd
                  git add ~/argocd/manifests/order.yaml
                  git commit -m "updating manifests"
                  git push origin main

                  """
                }

            }
        }
    }    
}