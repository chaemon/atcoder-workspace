import atcoder/modint

type mint = modint998244353

#proc inv[T:float](a:T):T =
#  T(1) / a

type hasInv = concept x, type T
  x.inv

#type convertibleFromInt = concept x, type T
#  T(0)
#
#proc inv[T:convertibleFromInt](a:T):T =
#  echo "convertible!!"
#  T(1) / a

proc inv[T](a:T):T =
  mixin inv
  when T is hasInv:
    `inv`(a)
  else:
    T(1) / a

var v = 2.0
echo v.inv
echo mint(3).inv
