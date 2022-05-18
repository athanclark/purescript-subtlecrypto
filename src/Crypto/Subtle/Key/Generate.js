export function generateKeyImpl (a,e,u) {
    return crypto.subtle.generateKey(a,e,u);
};
export const exp65537 = new Uint8Array([0x01,0x00,0x01]);
