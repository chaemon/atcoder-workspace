type S = object
  discard

type U = object
  discard

proc getAddr[T]():auto =
  var n {.global.} = (echo "getAddr is called "; 0)
  return n.addr

var p = getAddr[S]()
p[] = 10
var q = getAddr[S]()
echo q[] # 10になってほしい

var r = getAddr[U]()
echo r[] # 0になってほしい
