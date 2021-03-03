job('jenkins_management_casc_reload') {
    description("Reload the casc configuration")
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
        systemGroovyCommand(readFileFromWorkspace("ops/jenkins/jcasc/jenkins_build_context/dsl/jenkins_management/scripts/cascReload.groovy"))
    }
}