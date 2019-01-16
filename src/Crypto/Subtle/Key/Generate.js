"use strict";

exports.generateKeyImpl = crypto.subtle.generateKey;
exports.exp65537 = new Uint8Array([0x01,0x00,0x01]);
