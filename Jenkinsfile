node("master"){

    stage("scm"){
        checkout scm
    }

    stage("build"){
        sh "mix local.hex --force"
        sh "mix deps.get"
        sh "npm install"
    }

}
