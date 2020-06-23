#!/bin/bash

if [ "$1" != "" ]; then
    echo 'Will change the version in pom.xml files... and deploy to ='$1
else
    echo 'Will change the version in pom.xml files...'
fi
branch=$(git rev-parse --abbrev-ref HEAD)
version="$branch"
version="$(echo $version | sed 's/bugfix\///g')"
version="$(echo $version | sed 's/feature\///g')"
version="$(echo $version | sed 's/release\///g')"
version=$(echo "$version" | awk '{print toupper($0)}')
mvn clean versions:set -DgenerateBackupPoms=false -DnewVersion="$version"
if [ "$1" != "" ]; then
    mvn clean install deploy liferay:deploy -Dliferay.auto.deploy.dir=$1
else
    mvn clean install deploy
fi
mvn clean
echo 'Changed version in pom.xml files to= '$version
exit 0
