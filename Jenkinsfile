node {
    stage('SCM Checkout') {
        git 'https://github.com/bezardo/CICD-Project.git'
    }
    
    stage('Maven Build') {
        def mvnHome = tool name: 'maven3', type: 'maven'
        sh "${mvnHome}/bin/mvn clean package"
        sh 'mv target/myweb*.war target/newapp.war'
    }
    
    stage('SonarQube Analysis') {
        def mvnHome = tool name: 'maven3', type: 'maven'
        withSonarQubeEnv('sonar') {
            sh "${mvnHome}/bin/mvn sonar:sonar"
        }
    }
    
    stage('Build Docker Image') {
        sh 'docker build -t bezardo/myweb:0.0.2 .'
    }
    
stage('Remove Previous Container') {
    try {
        sh 'docker rm -f tomcattest'
    } catch (Exception e) {
        echo "Previous container not found, skipping removal."
    }
    sleep 15
    try {
        sh 'docker rm -f tomcattest'
    } catch (Exception e) {
        echo "Previous container not found, skipping removal."
    }
} 

stage('Cooldown Period') {
    echo "Waiting for 60 seconds to ensure container removal is complete..."
    sleep 50
}

stage('Docker Deployment') {
    sh 'docker run -d -p 8090:8080 --name tomcattest bezardo/myweb:0.0.2'
} 

stage('img push to artifactory') {
        withCredentials([usernamePassword(credentialsId: 'nexus', usernameVariable: 'NEXUS_USER', passwordVariable: 'NEXUS_PASS')]) {
        sh "echo ${NEXUS_PASS} | docker login -u ${NEXUS_USER} --password-stdin <IP>:8082"
        }
        sh 'docker tag bezardo/myweb:0.0.2 <IP>:8082/newapp:latest'
        sh 'docker push <IP>:8082/newapp:latest'
    }
    
}
