import java.util.logging.ConsoleHandler
import java.util.logging.FileHandler
import java.util.logging.SimpleFormatter
import java.util.logging.LogManager
import jenkins.model.Jenkins

def logsDir = new File(Jenkins.instance.rootDir, "logs")

if(!logsDir.exists()){
    println "Creating log dir for Jenkins startup logs";
    logsDir.mkdirs();
}

def loggerStartup = LogManager.getLogManager().getLogger("");
FileHandler handlerStartup = new FileHandler(logsDir.absolutePath + "/jenkins-startup.log", 1024 * 1024, 10, true);

handlerStartup.setFormatter(new SimpleFormatter());
loggerStartup.addHandler (new ConsoleHandler());
loggerStartup.addHandler(handlerStartup);