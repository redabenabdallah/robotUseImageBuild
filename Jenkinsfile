pipeline {
    agent {
        docker { image 'ghcr.io/https://github.com/redabenabdallah/robotframeworktestdemo.git:latest' }
    }

    stages {
        stage('Test') {
            steps {
                sh './scripts/run_suites.sh'
            }
        }
    }
}