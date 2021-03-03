freeStyleJob('casc_config_sync') {
    description('Sync casc configs from s3. REQUIRES MANUAL RELOAD OF CONFIGURATION.')
    label('master')
    logRotator {
        daysToKeep(1)
    }
    wrappers {
        credentialsBinding {
            amazonWebServicesCredentialsBinding {
                credentialsId("cmdt_jenkins_aws_credentials")
                accessKeyVariable("AWS_ACCESS_KEY_ID")
                secretKeyVariable("AWS_SECRET_ACCESS_KEY")
            }
        }
    }
    steps {
        shell("cp ${JENKINS_REF}/shell/sync-casc-configs.sh .")
        shell("./sync-casc-configs.sh")
    }
}