# Package the redistributable artifacts
echo ">> Zip artifacts"
pushd $TRACE_REPO_DIR && \
  zip -r test-example.zip . && \
  popd

mv $TRACE_REPO_DIR/test-example.zip tro

# Sign the TRO
echo ">> Sign declaration"
tro-utils --declaration tro/test-example.jsonld sign

# Verify the TRO
echo ">> Verify declaration"
tro-utils --declaration tro/test-example.jsonld verify

# Generate the TRO report
echo ">> Generate Report"
tro-utils --declaration tro/test-example.jsonld report --template tro.md.jinja2 -o tro/test-example.md