include atcoder/extra/header/chaemon_header
import BigNum

import atcoder/extra/other/binary_search

const DEBUG = true

proc solve(X:string, M:int) =
  var x = newSeq[int]()
  for i in X.len:
    x.add(X[i].ord - '0'.ord)
  if x.len == 1:
    if x[0] <= M: echo 1
    else: echo 0
    return
  proc f(b:int):bool =
    var s = newInt(0)
    for i in X.len:
      s *= b
      s += x[i]
    return s <= M
  var d = 0
  for i in X.len:
    d.max=x[i]
  let u = f.maxRight(d + 1..M + 1)
  echo u - d
  return

# input part {{{
block:
  var X = nextString()
  var M = nextInt()
  solve(X, M)
#}}}

