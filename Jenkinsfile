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
        stage("deploy"){
            sh "git remote add heroku git@heroku.com:curle-b10g.git || true"
            sh "git checkout master"
            sh "git pull origin master"
            sh "git pull heroku master || true"
            sh "git push heroku master"
        }
        stage("build docker image"){
            sh "docker build -t gcr.io/curle-blog/b10g:`git rev-parse HEAD` ."
            sh "gcloud docker -- push gcr.io/curle-blog/b10g:`git rev-parse HEAD`"
        }
        stage("migrate"){
            sh "heroku run mix ecto.migrate"
        }
        stage("version-number"){
            sh "heroku config:set VERSION=\$((1 + `heroku config:get VERSION  -a curle-b10g`)) -a curle-b10g"
            sh "kubectl set image deployment/b10g-app b10g=gcr.io/curle-blog/b10g:`git rev-parse HEAD`"
        }
    }
}
