export function getRandomValuesImpl (typedArray) {
  return crypto.getRandomValues(typedArray);
};
export function randomUUID () {
  return crypto.randomUUID();
};