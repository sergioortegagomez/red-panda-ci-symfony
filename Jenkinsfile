#!groovy

@Library('github.com/red-panda-ci/jenkins-pipeline-library@v2.6.0') _

// Initialize global config
cfg = jplConfig('red-panda-ci-symfony4','backend')

// The pipeline
pipeline {

    agent any

    stages {
        stage ('Initialize') {
            agent { label 'docker' }
            steps  {
                deleteDir()
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
                jplSonarScanner(cfg)
                sh 'bin/test.sh'
            }
        }
        stage ('Release confirm') {
            when { branch 'release/v*' }
            steps {
                jplPromoteBuild(cfg)
            }
        }
        stage ('Release finish') {
            agent { label 'docker' }
            when { branch 'release/v*' }
            steps {
                jplCloseRelease(cfg)
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