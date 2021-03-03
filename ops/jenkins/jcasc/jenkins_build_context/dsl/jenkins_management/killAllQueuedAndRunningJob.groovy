job('jenkins_management_kill_all_jobs') {
    description("kill all running an queued jobs")
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
        systemGroovyCommand(readFileFromWorkspace("ops/jenkins/jcasc/jenkins_build_context/dsl/jenkins_management/scripts/killAllJobs.groovy"))
    }
}