import jenkins.model.*;
import jenkins.model.Jenkins;
import java.util.ArrayList;

jenkins = Jenkins.instance

def queue = jenkins.queue
println "Queue contains ${queue.items.length} items"
queue.clear()
println "Queue cleared"

// Stop all the currently running jobs
for (job in jenkins.items) {
    stopJobs(job)
}

def stopJobs(job) {
    if ( job in com.cloudbees.hudson.plugins.folder.Folder ) {
        for (child in job.items) {
            stopJobs(child)
        }    
    } else if ( job in org.jenkinsci.plugins.workflow.multibranch.WorkflowMultiBranchProject ) {
        for (child in job.items) {
            stopJobs(child)
        }
    } else if ( job in org.jenkinsci.plugins.workflow.job.WorkflowJob ) {

        if (job.isBuilding()) {
            for (build in job.builds) {
                build.doKill()
                println "Killed ${build}"
            }
        }
    }
}