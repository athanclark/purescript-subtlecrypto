export function digestImpl (h,x) {
    return crypto.subtle.digest(h,x);
};
