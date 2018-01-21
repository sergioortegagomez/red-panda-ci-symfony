#!groovy

@Library('github.com/red-panda-ci/jenkins-pipeline-library') _

// Initialize global config
cfg = jplConfig('red-panda-ci-symfony4','backend','', [hipchat: '', slack: '', email:''])

// The pipeline
pipeline {

    agent any

    stages {
        stage ('Initialize') {
            agent { label 'docker' }
            steps  {
                jplStart(cfg)
            }
        }        
        stage ('Build') {
            agent { label 'docker' }
            steps  {
                jplBuild(cfg)
            }
        }
        stage('Test') {
            agent { label 'docker' }
            steps {
                sh 'bin/test.sh'
                // jplSonarScanner(cfg)
            }
        }        
    }

    post {
        always {
            jplPostBuild(cfg)
        }
    }

    options {
        timestamps()
        ansiColor('xterm')
        buildDiscarder(logRotator(artifactNumToKeepStr: '20',artifactDaysToKeepStr: '30'))
        disableConcurrentBuilds()
        skipDefaultCheckout()
        timeout(time: 1, unit: 'DAYS')
    }
}