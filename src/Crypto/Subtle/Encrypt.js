export function encryptImpl (a,k,x) {
    return crypto.subtle.encrypt(a,k,x);
};
export function decryptImpl (a,k,x) {
    return crypto.subtle.decrypt(a,k,x);
};
