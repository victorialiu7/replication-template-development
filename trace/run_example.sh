#!/bin/bash
#
# This script executes the "test-example" workflow in the context of an 
# example TRACE System (TRS) and uses the tro-utils command-line tools
# to create and sign a Trusted Research Object (TRO).
#

fileShare="aearep-6173"
# Figure out a way to retrieve the fileShare name
# fileShare="workspace"
JIRA_KEY="AEAREP-6173" 

# Extract the GPG fingerprint
FINGERPRINT=$(gpg --list-keys --fingerprint | grep -A 1 'pub' | grep -v 'pub' | grep -v '\-\-' | tr -d ' ')
[[ -z $FINGERPRINT ]] && echo "FINGERPRINT is empty!!"

export GPG_FINGERPRINT=$FINGERPRINT
export GPG_PASSPHRASE="hello"

# Setting the working directory to the root of this repo (/home/rstudio/workspace/$fileShare/project)
TRACE_REPO_DIR="$HOME/workspace/$fileShare/project"

# Find the next folder number for the tro outputs
TRO_DIR="$HOME/workspace/$fileShare/tro"
LAST_RUN=$(find $TRO_DIR -maxdepth 1 -type d -regex '.*/[0-9]+' | awk -F '/' '{print $NF}' | sort -n | tail -1)
NEXT_RUN=$((LAST_RUN + 1))

# Create the new folder for this run
CURRENT_TRO_DIR="$TRO_DIR/$NEXT_RUN"
mkdir -p $CURRENT_TRO_DIR

echo ">> Run workflow"
# Create a new TRO declaration and pre-execution arrangement
tro-utils --declaration $CURRENT_TRO_DIR/test-example.jsonld \
  --profile "$HOME/trace/trs.jsonld" \
  --tro-creator "Test User" \
  --tro-name "Test Example" \
  --tro-description "An attempt to test the workflow." \
  arrangement add $TRACE_REPO_DIR \
  -m "Before executing workflow"

# Tasks: Test run.sh if there, and if not, error 
# Run the example workflow
echo ">> Run workflow"

# Giving run.sh executable permission
chmod +x $TRACE_REPO_DIR/run.sh

START=`date +"%Y-%m-%dT%H:%M:%S"` 
pushd $TRACE_REPO_DIR && \
  sh run.sh && \
  popd
END=`date +"%Y-%m-%dT%H:%M:%S"`

# Add post-execution arrangement
tro-utils --declaration $CURRENT_TRO_DIR/test-example.jsonld \
  --profile $HOME/trace/trs.jsonld \
  arrangement add $TRACE_REPO_DIR \
  -m "After executing workflow"

# Step 2 
# Add a performance for the executed workflow
tro-utils --declaration $CURRENT_TRO_DIR/test-example.jsonld \
  performance add -m "Executed workflow" \
  -s $START \
  -e $END \
  -a arrangement/0 -M arrangement/1 

# Add arrangement after removing restrited riles
# tro-utils --declaration tro/test-example.jsonld --profile trs.jsonld arrangement add $TRACE_REPO_DIR \
#   -m "After removing restricted files" 

# Add a performance for restricted file removal (not needed)
# echo ">> Adding performance for restricted file removal"
# tro-utils --declaration $CURRENT_TRO_DIR/test-example.jsonld \
#   performance add -m "Removal of restricted files" \
#   -s $START -e $END \
#   -a arrangement/1 -M arrangement/2 

# Package the redistributable artifacts
echo ">> Zip artifacts"
pushd $TRACE_REPO_DIR && \
  zip -r test-example.zip . && \
  popd

mv $TRACE_REPO_DIR/test-example.zip $CURRENT_TRO_DIR/

# Sign the TRO
echo ">> Sign declaration"
tro-utils --declaration $CURRENT_TRO_DIR/test-example.jsonld sign

# Verify the TRO
echo ">> Verify declaration"
tro-utils --declaration $CURRENT_TRO_DIR/test-example.jsonld verify

# Generate the TRO report
echo ">> Generate Report"
tro-utils --declaration $CURRENT_TRO_DIR/test-example.jsonld report \
  --template $HOME/trace/tro.md.jinja2 \
  -o $CURRENT_TRO_DIR/test-example.md

#Capturing exit code
exit_code=$?

# Convey the exit code to Jira
case $exit_code in
  0)
    result="Success"
    ;;
  1)
    result="Possible failure"
    ;;
  *)
    result="Exit code $exit_code"
    ;;
esac

bash $HOME/notification/azure_to_jira.sh "$result" "$JIRA_KEY"