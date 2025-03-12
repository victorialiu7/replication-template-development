# Add post-execution arrangement
tro-utils --declaration tro/test-example.jsonld --profile trs.jsonld arrangement add $TRACE_REPO_DIR \
  -m "After executing workflow"

# Add a performance for the executed workflow
tro-utils --declaration tro/test-example.jsonld \
  performance add -m "Executed workflow" \
  -s $START \
  -e $END \
  -a arrangement/0 -M arrangement/1
