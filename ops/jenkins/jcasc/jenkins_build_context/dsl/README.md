## Job DSL scripts

- DSL scripts that are run at the boot of Jenkins and are built into its Docker image

- These live at the root of this directory.

- These are scripts that don't require frequent, if any, updates and usually only run once.
  - Any updates require a rebuild of the Docker image.

- [buildAndLoadTesting.groovy](./buildAndLoadTesting.groovy)

- [ecsTaskWarmer.groovy](./ecsTaskWarmer.groovy)