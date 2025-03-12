# Add arrangement after removing restrited riles
tro-utils --declaration tro/test-example.jsonld --profile trs.jsonld arrangement add $TRACE_REPO_DIR \
  -m "After removing restricted files" 

# Add a performance for restricted file removal
tro-utils --declaration tro/test-example.jsonld \
  performance add -m "Removal of restricted files" \
  -s $START -e $END \
  -a arrangement/1 -M arrangement/2 