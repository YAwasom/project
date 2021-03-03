freeStyleJob('seed') {
    description(
    '''
    Generates jobs configured within jcasc/seed/config/seed.json. 
    Commit changes to seed.json to reconfigure jobs. 
    This job will pickup the changes and update all jobs accordingly.
    '''
    )
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
        dsl {
            external("ops/jenkins/**/seed/*seed*") 
        }
    }
}