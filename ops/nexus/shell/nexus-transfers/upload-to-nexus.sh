#!/bin/bash
# used this to do migrations between nexus instances
# use https://github.com/thiagofigueiro/nexus3-cli for downloads
# once files are local.. hop to that dir and upload them to new/or existing nexus
files="./files.out"

username="xxxxxxxxx"
password="xxxxxxxxx"
nexusurl="https://nexus.cmd-ops.warnerbros.com/nexus3"
snapshoturl="https://nexus.cmd-ops.warnerbros.com/repository/com-warnerbros-cmdt-maven-snapshots/"
releaseurl="https://nexus.cmd-ops.warnerbros.com/repository/com-warnerbros-cmdt-maven-releases/"

# write all local repo file names to a file
find . -name '*.*' -type f | cut -c 3- | grep "/" > $files

# slowly upload all of them. prob wanna backgroud this..
while read i; do
  echo "upload $i to $releaseurl"
  curl -v -u $username:$password --upload-file $i "$releaseurl$i"
done <$files