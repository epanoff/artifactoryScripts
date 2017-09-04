#!/bin/bash

# find all artifacts created in 2013, time are expressed in milliseconds
# grep look for uri attribute in JSON results returned then awk take the corresponding value of the uri attribute. The first 2 sed commands remove the last character and the last sed command remove the first character, ie stripping off the comma and double quotes from the URL in awk  

USER=$1
PASSWORD=$2


RESULTS=`curl -k   -X GET -u $USER:$PASSWORD "http://artifactory.dek.corp.mvideo.ru/artifactory/api/search/creation?from=00&to=1491004800000&repos=ext-release-local" | grep uri | awk '{print $3}' | sed s'/.$//' | sed s'/.$//' | sed -r 's/^.{1}//' | grep ui-asset`
#RESULTS=`curl -k   -X GET -u $USER:$PASSWORD "http://artifactory.dek.corp.mvideo.ru/artifactory/api/search/usage?notUsedSince=1491004800000&repos=ext-release-local" | grep uri | awk '{print $3}' | sed s'/.$//' | sed s'/.$//' | sed -r 's/^.{1}//'`

for RESULT in $RESULTS ; do
    echo "fetching path from $RESULT"
    # from the URL we fetch the download uri to remove
    # grep look for downloadUri attribute in JSON results returned then awk take the corresponding value of the downloadUri attribute. The first 2 sed commands remove the last character and the last sed command remove the first character, ie stripping off the comma and double quotes from the URL in awk
    PATH_TO_FILE=`curl -s -X GET -u $USER:$PASSWORD $RESULT | grep downloadUri | awk '{print $3}' | sed s'/.$//' | sed s'/.$//' | sed -r 's/^.{1}//'`
    echo "deleting path $PATH_TO_FILE"
    # deleting the corresponding artifact at last
    curl -X DELETE -u  $USER:$PASSWORD  $PATH_TO_FILE
done
