# Jenkins on ecs build agents

All agents are run as docker containers. The images are stored within AWS ECR located in cmd ops account.

You can read about configuring and integrating agents [in the main readme](../README.md)

All agents can be built and shipped to their respective ECR via their respective [makefile](alpine/dind-jnlp-slave/Makefile)

If the agent is non general, please place it under a project directory. e.g. `build-agents/amz2/nest/`
