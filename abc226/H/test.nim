include atcoder/extra/header/chaemon_header

{.experimental:"callOperator".}

#import atcoder/modint
#import atcoder/extra/math/formal_power_series

#type mint = modint998244353

#var v = Seq[10:mint]

type XX[T] = seq[T]

proc `()`*[T](self: XX[T], x:T):T = x

var v = newSeqOfCap[int](10)

echo v


