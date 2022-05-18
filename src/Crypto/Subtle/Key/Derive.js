export function deriveKeyImpl (a,k,t,e,u) {
    return crypto.subtle.deriveKey(a,k,t,e,u);
};
export function deriveBitsImpl (a,k,l) {
    return crypto.subtle.deriveBits(a,k,l);
};
