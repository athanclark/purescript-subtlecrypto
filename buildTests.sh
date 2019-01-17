#!/bin/bash

pulp build && \
    pulp test
echo "Bundling..."
purs bundle output/**/*.js -m Test.Main --main Test.Main > test.browser.js
echo "Bundled."
