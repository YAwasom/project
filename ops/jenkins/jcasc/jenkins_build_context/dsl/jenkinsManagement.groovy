job('seed_jenkins_management_scripts') {
    description("seed jenkins management scripts")
    label('master')
    scm {
        git {
            remote {
                credentials('cmdt_jenkins_github_ssh_key')
                url("git@github.com:wm-msc-malt/infrastructure.git")
            }
            branch('develop')
        }
    }
    steps {
        dsl{
            external("ops/jenkins/**/dsl/jenkins_management/*.groovy") 
        }
    }
}

listView('Jenkins Management') {
    columns {
        status()
        weather()
        name()
        lastSuccess()
        lastFailure()
        lastDuration()
        buildButton()
    }
    filterBuildQueue()
    filterExecutors()
    jobs {
        regex(/(?i)((.*)management(.*))/)
    }
}