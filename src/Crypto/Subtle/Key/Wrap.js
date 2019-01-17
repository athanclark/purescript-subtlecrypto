"use strict";

exports.wrapKeyImpl = function wrapKeyImpl (f,x,k,a) {
    return crypto.subtle.wrapKey(f,x,k,a);
};
exports.unwrapKeyImpl = function unwrapKeyImpl (f,x,k,a,i,e,u) {
    return crypto.subtle.unwrapKey(f,x,k,a,i,e,u);
};
