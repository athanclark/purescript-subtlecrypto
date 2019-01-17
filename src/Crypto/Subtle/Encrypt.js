"use strict";

exports.encryptImpl = function encryptImpl (a,k,x) {
    return crypto.subtle.encrypt(a,k,x);
};
exports.decryptImpl = function decryptImpl (a,k,x) {
    return crypto.subtle.decrypt(a,k,x);
};
