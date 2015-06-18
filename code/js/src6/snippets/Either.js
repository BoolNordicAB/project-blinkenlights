'use strict';
/**
* @module Either
* @example
let getThing = function () {
  let text = Math.random() < 0.5 ?
    'such success' : null;

  if (text) {
    return Either.right({information: text})
  }
  return Either.left(new Error('much error'))
};

let message = Either.match(getThing(), {
  right: (result) => result.information,
  left: (err) => err.message
});
*/
let Either = function Either() {};
let Left = function left(value) {
  this.value = value;
};
let Right = function right(value) {
  this.value = value;
}
Either.match = (either, matcher, dynamicThis) => {
  return (matcher[either.constructor.name] || function () {})
    .call(dynamicThis, (either || {}).value);
};
Either.left = (value) => {
  return new Left(value);
};
Either.right = (value) => {
  return new Right(value);
};
