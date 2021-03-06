node {
    def app

    def app_name = 'ai-lab-nace-poc'
    def namespace = 'ai-lab-nace-poc'
    def cluster = 'oera-q.local'
    def yaml_path = 'https://raw.githubusercontent.com/navikt/ai-lab-nace-poc/master/nais.yaml'

    stage('Clean workspace') {
        cleanWs()
    }

    stage('Checkout code') {
        checkout scm
    }

    stage('Copy certificate bundle') {
        sh "cp /etc/ssl/certs/ca-bundle.crt ca-bundle.crt"
    }

    stage('Build react app') {
        sh "chmod +x scripts/buildReactApp.sh"
        sh "./scripts/buildReactApp.sh"
    }

    stage('Build docker image') {
        app = docker.build("${app_name}", "-f Dockerfile.jenkins .")
    }

    stage('Push docker image') {
        docker.withRegistry('https://repo.adeo.no:5443', 'docker-credentials') {
            app.push("${env.BUILD_ID}")
        }
    }

    stage('Deploy app to nais') {
        sh "curl --fail -k -d '{\"application\": \"${app_name}\", \"version\": \"${env.BUILD_ID}\", \"skipFasit\": true, \"namespace\": \"${namespace}\", \"manifesturl\": \"${yaml_path}\"}' https://daemon.nais.${cluster}/deploy"
    }

}