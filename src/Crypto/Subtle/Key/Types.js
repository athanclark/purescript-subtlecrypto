export function exportKeyImpl (f,x) {
    return crypto.subtle.exportKey(f,x);
};
