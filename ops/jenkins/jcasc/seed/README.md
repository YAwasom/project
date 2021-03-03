# Seed Job Configuration

Refer to [seed.groovy](./seed.groovy) for implementation of job configuration and [job dsl](https://jenkinsci.github.io/job-dsl-plugin/)

The [dsl seed job](../jenkins_build_context/dsl/boot_seed_sync/seed.groovy) configures the seed job. This job parses the configs and imports all the jobs.

There are multiple job configs, written in yaml, which are typically split by application.

The [jenkins build agents](../seed/config/jenkins.agents.seed.yaml) is an example of one