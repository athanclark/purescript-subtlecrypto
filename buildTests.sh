#!/bin/bash

spago build
echo "Bundling..."
spago bundle-app -m Test.Main -t test.browser.js
echo "Bundled."
