"use strict";

exports.deriveKeyImpl = function deriveKeyImpl (a,k,t,e,u) {
    return crypto.subtle.deriveKey(a,k,t,e,u);
};
exports.deriveBitsImpl = function deriveBitsImpl (a,k,l) {
    return crypto.subtle.deriveBits(a,k,l);
};
