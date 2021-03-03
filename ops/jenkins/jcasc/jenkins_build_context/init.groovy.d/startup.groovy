import jenkins.model.Jenkins
import java.util.logging.Logger
import jenkins.model.JenkinsLocationConfiguration
import org.jenkinsci.plugins.scriptsecurity.scripts.*

Logger.global.info("Running startup script")

scheduleBuild('seed')
scheduleBuild('_run_at_boot_')

sleepForScriptApproval()

scheduleBuild('seed', 60)
scheduleBuild('_run_at_boot_', 60)

approvePendingScripts()

Logger.global.info("Startup script complete")

// Prior to execution of this function, scripts must have
// been run once to be in a pending state and thus approved
private def approvePendingScripts(){
    Logger.global.info("Running script approvals")
    toApprove = ScriptApproval.get().getPendingScripts().collect()
    toApprove.each {
        pending -> ScriptApproval.get().approveScript(pending.getHash())
        Logger.global.info("Approved ${pending.getHash()}")
    }
}

private def sleepForScriptApproval(){
    Logger.global.info("""
    Waiting for builds to fail inorder to approve for script security: 20 secs
    """)
    sleep(20*1000)
}

private def scheduleBuild(def jobName, def seconds=0) {
    Logger.global.info("Scheduling ${jobName} job ${seconds} seconds from now")
    jenkins = Jenkins.instance;
    def job = jenkins.getJob(jobName)
    job.scheduleBuild2(seconds)
}