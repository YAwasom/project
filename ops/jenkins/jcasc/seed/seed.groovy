@Grab('org.yaml:snakeyaml:1.25')

import groovy.io.FileType
import org.yaml.snakeyaml.Yaml

def build = Thread.currentThread().executable
def workspace = build.workspace.toString()

def seeds = []
def seedDir = "${workspace}/ops/jenkins/jcasc/seed/config/"
def dir = new File(seedDir)
dir.eachFileRecurse (FileType.FILES) { seedConfigFile ->
  seeds << new Yaml().load(seedConfigFile.text)
}

def repos = seeds.flatten()

if(!repos){
  throw new Exception("Failed to get repos. Double check seed.json.")
}

repos.each { project ->
    if (project.viewName) {
        createView(project)
    }

    if (!project.isMultiBranch) {
        createPipelineJob(project)
    } else {
        if(!project.tagDiscovery){
            createMultibranchPipelineJob(project)
        }else{
            createMultibranchPipelineJobWithTagDiscovery(project)
        }
    }
}

private def createView(project){
    def viewRegex = project.viewRegex ? project.viewRegex : "${project.projectName}*"

    listView(project.viewName) {
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
            regex(/(?i)(${viewRegex})/)
        }
    }
}

private def createPipelineJob(project){
    def scmTrigger = project.scmTrigger ? project.scmTrigger : null
    def cronTrigger = project.cronTrigger ? project.cronTrigger : null
    def parallel = project.parallel == false ? false : true

    pipelineJob(project.projectName) {
        description(project.description)
        logRotator {
            daysToKeep(30)
        }
        if (!parallel) {
            properties {
                disableConcurrentBuilds()
            }
        }
        if (scmTrigger){
            triggers {
                scm scmTrigger
            }
        }
        if (cronTrigger){
            triggers {
                cron cronTrigger
            }
        }

        definition {
            cpsScm {
                lightweight(project.lightweight)
                scriptPath(project.scriptPath)
                scm {
                    git {
                        remote {
                            name(project.projectName)
                            url(project.url)
                            credentials(project.credentials)
                        }
                        branch(project.branch)
                        extensions {}
                    }
                }
            }
        }
    }
}

private def createMultibranchPipelineJob(project){
    def scmScanInterval = project.scmScanInterval ? project.scmScanInterval : null
    def wipeWorkspace  = project.wipeWorkspace ? project.wipeWorkspace : null

    multibranchPipelineJob(project.projectName) {
        description(project.description)
        branchSources {
            branchSource {
                source {
                    git {
                        remote(project.url)
                        credentialsId(project.credentials)
                        traits {
                            localBranchTrait()
                            headWildcardFilter {
                                includes(project.includes)
                                excludes("")
                            }
                            if (wipeWorkspace) {
                                wipeWorkspaceTrait()
                            }
                        }
                    }
                    buildStrategies {
                        skipInitialBuildOnFirstBranchIndexing()
                    }
                }
            }
        }
        if (scmScanInterval) {
            triggers {
                periodicFolderTrigger {
                    interval(project.scmScanInterval)
                }
            }
        }
        orphanedItemStrategy {
            discardOldItems {
                numToKeep(20)
            }
            defaultOrphanedItemStrategy {
                pruneDeadBranches(true)
                numToKeepStr("20")
                daysToKeepStr("")
            }
        }
        factory {
            workflowBranchProjectFactory {
                scriptPath(project.scriptPath)
            }
        }

        // https://github.com/jenkinsci/git-plugin/pull/595
        // traits {
        //   gitBranchDiscovery()
        // }
        // Couldn't get above to work..Using below for now.
        configure {
            def traits = it / sources / data / 'jenkins.branch.BranchSource' / source / traits
            traits << 'jenkins.plugins.git.traits.BranchDiscoveryTrait' {}
        }
    }
}

private def createMultibranchPipelineJobWithTagDiscovery(project){
     multibranchPipelineJob(project.projectName) {
        description(project.description)
        branchSources {
            branchSource {
                source {
                    git {
                        remote(project.url)
                        credentialsId(project.credentials)
                        traits {
                            localBranchTrait()
                            headWildcardFilter {
                                includes(project.includes)
                                excludes("")
                            }
                        }
                    }
                    buildStrategies {
                        buildAllBranches{
                            strategies{
                                buildAnyBranches{
                                    strategies{
                                        buildRegularBranches()
                                        buildTags {
                                            atLeastDays '-1'
                                            atMostDays '5'
                                        }
                                    }
                                }
                                skipInitialBuildOnFirstBranchIndexing()
                            }
                        }
                    }
                }
            }
        }
        triggers {
            periodicFolderTrigger {
                interval(project.scmScanInterval)
            }
        }
        orphanedItemStrategy {
            discardOldItems {
                numToKeep(20)
            }
            defaultOrphanedItemStrategy {
                pruneDeadBranches(true)
                numToKeepStr("20")
                daysToKeepStr("")
            }
        }
        // https://github.com/jenkinsci/git-plugin/pull/595
        // traits {
        //   gitBranchDiscovery()
        // }
        // Couldn't get above to work..Using below for now.
        configure {
            def traits = it / sources / data / 'jenkins.branch.BranchSource' / source / traits
            traits << 'jenkins.plugins.git.traits.BranchDiscoveryTrait' {}
            traits << 'jenkins.plugins.git.traits.TagDiscoveryTrait'()
        }
    }
}
