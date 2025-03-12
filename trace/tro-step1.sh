# Create a new TRO declaration and pre-execution arrangement
tro-utils --declaration tro/test-example.jsonld \
  --profile trs.jsonld \
  --tro-creator "Test User" \
  --tro-name "Test Example" \
  --tro-description "An attempt to test the workflow." \
  arrangement add "$TRACE_REPO_DIR" \
  -m "Before executing workflow"