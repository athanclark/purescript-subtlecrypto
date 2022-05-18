export function signImpl (a,k,x) {
    return crypto.subtle.sign(a,k,x);
};
export function verifyImpl(a, k, s, x) {
    return crypto.subtle.verify(a, k, s, x);
}
