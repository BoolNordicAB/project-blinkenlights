'use strict';
/**
* @module Either
* @example
const getThing = function () {
  const text = Math.random() < 0.5 ?
    'such success' : null;

  if (text) {
    return Either.right({information: text})
  }
  return Either.left(new Error('much error'))
};

const message = Either.match(getThing(), {
  right: (result) => result.information,
  left: (err) => err.message
});
*/
const Either = function Either() {};
const Left = function left(value) {
  this.value = value;
};
const Right = function right(value) {
  this.value = value;
}
Either.match = function match(either, matcher, dynamicThis) {
  return (matcher[either.constructor.name] || function () {})
    .call(dynamicThis, (either || {}).value);
};
Either.left = function left(value) {
  return new Left(value);
};
Either.right = function right(value) {
  return new Right(value);
};
