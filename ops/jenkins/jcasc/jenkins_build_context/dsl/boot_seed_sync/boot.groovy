freeStyleJob("_run_at_boot_") {
    description("Run all jobs under /dsl on boot.")
    label('master')
    logRotator {
        daysToKeep(1)
    }
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
            external("ops/jenkins/**/dsl/*.groovy") 
        }
    }
}