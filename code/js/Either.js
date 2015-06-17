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
}

var message = Either.match(getThing(), {
  right: function (result) {return result.information},
  left: function (err) {return err.message}
})
*/
var Either = function Either() {}

var Left = function left(value) {
  this.value = value
}
var Right = function right(value) {
  this.value = value
}

Either.match = function (either, matcher, dynamicThis) {
  return (matcher[either.constructor.name] || function () {})
    .call(dynamicThis, (either || {}).value)
}

Either.left = function (value) {
  return new Left(value)
}
Either.right = function (value) {
  return new Right(value)
}
