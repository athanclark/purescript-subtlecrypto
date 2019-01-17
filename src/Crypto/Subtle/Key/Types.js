"use strict";

exports.exportKeyImpl = function exportKeyImpl (f,x) {
    return crypto.subtle.exportKey(f,x);
};
