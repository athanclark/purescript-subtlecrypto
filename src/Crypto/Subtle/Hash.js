"use strict";

var subtle = typeof module !== "undefined" && module.require
    ? module.require('subtle')
    : crypto.subtle;


exports.digestImpl = subtle.digest;
