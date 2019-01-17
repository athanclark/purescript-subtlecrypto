"use strict";

exports.generateKeyImpl = function generateKeyImpl (a,e,u) {
    return crypto.subtle.generateKey(a,e,u);
};
exports.exp65537 = new Uint8Array([0x01,0x00,0x01]);
