## Adding a job to Jenkins

1. Commit a Jenkins pipeline file to your Github repository

    - Github is required. We will not support other forms of source control.

2. Add your repository to the [seed job config](./jcasc/seed/config/seed.json)

    - This job reaches out to all configured repositories to import and configure them

3. Commit the seed job config changes to the develop branch.
    - This is required for the seed job to be able to see the code changes you just made.
    - The seed job is simply a Jenkins job that reads the config and runs some groovy to install everything.

4. Run the [seed job](https://jenkins.cmd-ops.warnerbros.com/view/Boot%20Seed%20Sync/job/seed/)
    - Login to [Jenkins](https://jenkins.cmd-ops.warnerbros.com)

    - After running, you should now be able to see your job and commit further changes to your pipeline file.

5. Inform the Operations team that the seed job is defined and they should persist it with a new build of the Jenkins Docker image.

## Persist Seed Changes in Docker Image

In order to persist seed changes to Jenkins, a new image must be build. A sync to EFS is initiated on startup of the container. New containers will overwrite what is on EFS if they don't contain the new changes. For quick changes, just sync to the bucket and run the sync and seed job in Jenkins.

1. Configure and use an [aws profile switcher](../../utilities/aws/profile-switcher/README.md)

    - `awsp <aws-profile>`

    ```bash
        # assume the correct aws permissions
        awsp ops 

        # login to ecr, build image, sycn casc configs 
        # to s3, tag, and push to ecr
        ./gradlew login build syncConfig tag push

        # sync to s3 and don't place in docker image
        ./gradlew syncConfig
    ```

## Notes on Jenkins Docker slaves

- There is a strong chance that you won't need another slave. Think about reusing what is already existing.

- Public images can be used, but must support the jnlp protocol.

    - `docker pull cloudbees/jnlp-slave-with-java-build-tools` is a good public example

## Adding a new Jenkins Docker slave

- Add and deploy a new ECR repo with a namespace [here](../jenkins/cf/parameters/ops.jenkins.ecr.yaml)

- Copy an existing jnlp slave under [build-agents](../jenkins/build-agents/README.md) and make the modifications you require. Make sure to test out the images locally. Use a makefile to configure the builds.

    ```bash
    # assume the correct credentials for aws ecr
    awsp ops

    # build the image and push to ecr
    make all
    ```

- Add a new cloud configuration within the [configuration as code plugin configs](../jenkins/jcasc/casc_configs/jenkins.yaml).

    - The label, name, and template name are the same. Please follow the convention already specified.

    - Pick the general cpu and memory that suits your needs. Start small.

    - The label is used in the jenkins pipeline files to reference the slaves.

        ```bash
        pipeline {
            agent { 
                label 'amz2-05cpu-1gb' // label <-- app-os-cpu-ram
            }
            stages {
                stage('Hello') {
                    steps {
                        sh 'echo "Hello"' 
                    }
                }
            }
        }
        ```

Casc configs live in 3 places: github, S3, and EFS. When changes are made to them they must be synced to EFS and reloaded. We use s3 as an intermediate store for the sync job living in Jenkins to overwrite the existing configs on EFS. Once changes are synced to disk, you must reload the casc config plugin and run 2 jobs: boot and seed. All of the views will disappear, but fear not they are still on EFS and the jobs will repopulate everything.

- Use the gradle wrapper to sync your changes to s3 and then run the sync job within jenkins to sync the configs to disk.

    ```bash
    # assume the correct credentials for aws ecr
    awsp ops

    # build the image and push to ecr
    ./gradlew syncConfig
    ```

- Reload the configuration plugin. Click [Reload Existing Configuration](https://jenkins.cmd-ops.warnerbros.com/configuration-as-code/)

- Rerun the [boot and seed jobs](https://jenkins.cmd-ops.warnerbros.com/view/Boot%20Seed%20Sync/)

## Cross account deploy permission

- Jenkins will assume roles created in other accounts per build and per environment. 

  - [Examples of jenkins deploy users](../jenkins/cf/parameters/ops.jenkins.deploy.role.yaml)

  - [Examples of deploy roles](../../ask/cf/templates/ask/ask_jenkins_deploy_role.us-east-2.yaml)

- Store the aws credentials in SSM. These credentials only have the ability to assume the deploy role in the other accounts and execute the specific permissions required to do their job.

- Each credential corresponds to one role. [casc credentials](../jenkins/jcasc/casc_configs/credentials.yaml)

- Roles are referenced in pipelines.

    ```bash
    stage('deploy development') {
        when {
            branch 'development'
        }
        environment {
            // name of the credential id stored within Jenkins
            // Credentials are masked by the plugin within the logs
            AWS = credentials('ott_packager_deploy_user_dev_aws_credentials') 
        }
        steps {
            script {
                sh 'aws ecs update-service --force-new-deployment etc'
            }
        }
    }
    ```

- Long term would like to try and figure out a better method. Currently need to rotate out user keys per application.

## Cross account permissions steps

- Create a jenkins application aws user with permissions to the role

- Create an application role for the jenkins user to assume

- Ensure the Jenkins deploy user has the correct permissions to assume the application role

- Sync the casc configs up to s3. This is described above.

- Run the casc configs sync job in Jenkins to write the configs down to EFS
  
- Reload the casc plugin configuration and run the seed and boot jobs. Again, this process is described above.

- With the credential loaded in Jenkins, you can now test out the build after making the required updates in your codes Jenkinsfile.

## Jenkins administration

### Plugin upgrades

- Make changes to the plugins.txt to upgrade plugins.

- Test out the changes on your local. Docs can be found [here](./README.md#setup-your-environment-for-local-development)

- In order to test builds, you'll have to do that on the live Jenkins. Slaves don't have a way to connect back to the master running locally. 

- Build and push the new image: `./gradlew login build syncConfig tag push`

```bash
# Make ecs service-update to the cluster
./shell/update-ecs-jenkins-master.sh ops
```

### Configuration changes upgrades

- Make required changes to the casc configs. [Examples](https://github.com/jenkinsci/configuration-as-code-plugin/tree/master/demos)

- Sync the changes to the S3 bucket. `./gradlew syncConfig`

- Run the casc configs sync job in Jenkins to write the configs down to EFS.
  
- Reload the casc plugin configuration and run the seed and boot jobs. Again, this process is described above.

- To persist the changes long term, rebuild the image and deploy it. `./gradlew login build syncConfig tag push`

- Rollback is simple. Undo your changes local or in git and then rebuild and deploy a new image.

```bash
# Make ecs service-update to the cluster
./shell/update-ecs-jenkins-master.sh ops
```