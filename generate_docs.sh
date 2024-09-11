#!/bin/bash

# Extract version number from package.json
VERSION=$(grep -o '"version": "[^"]*' package.json | grep -o '[^"]*$')

# Build core files
npm run buildCore

# Set up directories
mkdir -p tmp distrib

# Update version number in COPYRIGHT file
sed -i '' "2s/.*/    JSXGraph $VERSION/" COPYRIGHT

# Prepend COPYRIGHT to jsxgraphcore files
cat COPYRIGHT distrib/jsxgraphcore.js > distrib/tmp.file && mv distrib/tmp.file distrib/jsxgraphcore.js
cat COPYRIGHT distrib/jsxgraphcore.mjs > distrib/tmp.file && mv distrib/tmp.file distrib/jsxgraphcore.mjs

# Update template related files
cp 3rdparty/jquery.min.js doc/jsdoc-tk/template/static/jquery.min.js
cp distrib/jsxgraphcore.js doc/jsdoc-tk/template/static/jsxgraphcore.js
cp distrib/jsxgraph.css doc/jsdoc-tk/template/static/jsxgraph.css

# Update version number in header file
sed -i '' "2s/.*/<h1>JSXGraph $VERSION Reference<\/h1>/" doc/jsdoc-tk/template/static/header.html

# Patch run.js
cp doc/jsdoc-tk/patches/*.js ./node_modules/jsdoc2/app/

# Update the plugin
cp doc/jsdoc-tk/plugins/*.js ./node_modules/jsdoc2/app/plugins/

# Generate file list for documentation
FILELIST=$(find src -name "*.js" ! -path "*/node_modules/*" ! -path "*/test/*")

# Run node-jsdoc2
./node_modules/.bin/jsdoc2 -v -p -t=doc/jsdoc-tk/template -d=tmp/docs $FILELIST

# Check if docs were generated
if [ -d "tmp/docs" ]; then
    # Compress documentation
    cd tmp && zip -r docs.zip docs/
    cp docs.zip ../distrib/docs.zip
    cd ..

    # Test documentation
    cd distrib && unzip -o docs.zip
else
    echo "Error: Documentation was not generated. Check the jsdoc2 output for errors."
fi