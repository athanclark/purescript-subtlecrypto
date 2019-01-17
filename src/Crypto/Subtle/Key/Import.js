"use strict";

exports.importKeyImpl = function importKeyImpl (f,x,a,e,u) {
    return crypto.subtle.importKey(f,x,a,e,u);
};
