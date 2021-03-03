#!/bin/bash -ex

RUNNING_ON_LOCALHOST=$1

if [ "$RUNNING_ON_LOCALHOST" == "true" ]; then
  # On localhost, remove auth in templates to get around saml auth
  yq d $CASC_JENKINS_CONFIG/jenkins.yaml jenkins.securityRealm > $CASC_JENKINS_CONFIG/jenkins_tmp.yaml
  rm -f $CASC_JENKINS_CONFIG/jenkins.yaml
  yq d $CASC_JENKINS_CONFIG/jenkins_tmp.yaml jenkins.authorizationStrategy > $CASC_JENKINS_CONFIG/jenkins.yaml
  rm -f $CASC_JENKINS_CONFIG/jenkins_tmp.yaml
fi