"use strict";

exports.signImpl = function signImpl (a,k,x) {
    return crypto.subtle.sign(a,k,x);
};
exports.verifyImpl = function verifyImpl (a,k,s,x) {
    return crypto.subtle.verify(a,k,s,x);
};
