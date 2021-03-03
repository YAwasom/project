# ops Nexus

We now run nexus via docker on ecs.

- Repos are backed by Blob-stores which are backed by s3 and replicated to other regions. (s3://wb-cmd-ops-s3-nexus-repo)

- Don't create repositories that use the file type unless there is a very good reason. S3 is highly preferred.

- EFS is still hooked in for snapshots of administration configuration and failover.

- Docker images for nexus are stored within ECR. Docker uses overlay2 like jenkins.

## migrations

- use <https://github.com/thiagofigueiro/nexus3-cli> for downloads

  - `pip install nexus-cli`
  - `nexus3 login` to generate config file with creds
  - `nexus3 -h`

- once files are local.. hop to that dir and upload them to new/or existing nexus

  - bash is the easiest (not so efficient way for this). [upload-to-nexus.sh](./shell/nexus-transfers/upload-to-nexus.sh)

```bash
# NOTE: there are some issues with nexus, elastic search, and large repo downloads.
# You'll get a json decode error etc.
# If repo is too large..have to download folder nestings 1 by 1
# e.g. com is too big. had to go com/warnerbros/contentnow/ or com/warnerbros/nuxeo/cors/
# be sure to add the / at the end for folders

$ nexus3 download com-warnerbros-cmdt-maven-snapshots/com/warnerbros/contentnow/ /Users/psladek/Code/warnerbros/nexus/com-warnerbros-cmdt-maven-snapshots/

Downloading com-warnerbros-cmdt-maven-snapshots/com/warnerbros/contentnow/ to /Users/psladek/Code/warnerbros/nexus/com-warnerbros-cmdt-maven-snapshots/
Downloading[#########                       ] 2788/9742 - 00:23:52
```
