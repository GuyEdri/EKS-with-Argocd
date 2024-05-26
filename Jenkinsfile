pipeline {
    agent {
        label 'agent1'
    }

    environment {
        GITLAB_CREDENTIALS_ID = 'gitlabargocdtoken'
        tag = "guyedri/flask-app:${BUILD_NUMBER}"
    }

    stages {
        stage('Build App Image') {
            steps {
                dir("./argocd/eks/weather-app") {
                    script {
                        sh "docker build -t ${tag} ."
                    }
                }
            }
        }

        stage('Push Image to Docker Hub') {
            steps {
                script {
                    // Set up Docker Hub credentials
                    withCredentials([usernamePassword(credentialsId: 'dockerhub', passwordVariable: 'DOCKER_PASSWORD', usernameVariable: 'DOCKER_USERNAME')]) {
                        sh "echo \$DOCKER_PASSWORD | docker login -u \$DOCKER_USERNAME --password-stdin"
                        sh "docker push ${tag}"
                    }
                }
            }
        }

        stage('Update Argo CD Application') {
            steps {
                script {
                    def appName = 'myapp-argocd' // Initial name
                    def updatedAppName = "${appName}-${env.BUILD_NUMBER}" // Append build number

                    // Set up Git configurations
                    sh """
                        git config --global user.name "guyedrix2@gmail.com"
                        git config --global user.email "guyedrix2@gmail.com"
                    """

                    // Use sed to update the name field in the YAML manifest
                    sh "sed -i \"s/name: ${appName}/name: ${updatedAppName}/\" ./argocd/eks/argocd.yaml"

                    // Add, commit, and push the updated manifest to GitLab
                    withCredentials([gitLabCredentials(credentialsId: env.GITLAB_CREDENTIALS_ID, url: 'https://gitlab.com/guyedrix2/argocd.git')]) {
                        sh """
                            git add -A
                            git commit -m "Update Argo CD Application name"
                            git push origin master
                        """
                    }
                }
            }
        }
    }
}

