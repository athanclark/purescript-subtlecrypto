export function wrapKeyImpl (f,x,k,a) {
    return crypto.subtle.wrapKey(f,x,k,a);
};
export function unwrapKeyImpl (f,x,k,a,i,e,u) {
    return crypto.subtle.unwrapKey(f,x,k,a,i,e,u);
};
