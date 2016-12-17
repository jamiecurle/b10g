node("master"){

    stage("scm"){
        checkout scm
    }

    stage("build"){
        sh "mix local.hex --force"
        sh "mix deps.get"
        sh "npm install"
    }

    stage("test"){
        sh "mix test"
    }

    if (env.BRANCH_NAME == "master"){

        stage("build docker image"){
            sh "docker build -t gcr.io/curle-blog/b10g:`git rev-parse HEAD` ."
        }

        stage("push docker image"){
            sh "gcloud docker -- push gcr.io/curle-blog/b10g:`git rev-parse HEAD`"
        }

        stage("update deployment"){
            sh "kubectl set image deployment/b10g b10g=gcr.io/curle-blog/b10g:`git rev-parse HEAD`"
        }
    }
}
