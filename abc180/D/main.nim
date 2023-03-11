include atcoder/extra/header/chaemon_header

import bigNum


proc solve(X:int, Y:int, A:int, B:int) =
  var k = 0
  var ans0 = 0
  var X = X.newInt
  while true:
#    echo k
    var ans = k
    if X >= Y: break
    ans += (Y - X.toInt - 1) div B
    ans0.max=ans
    let prod = X * A
    if (prod div A) != X: # overflow
      break
    X = prod
    k.inc
  echo ans0
  return

# input part {{{
block:
  var X = nextInt()
  var Y = nextInt()
  var A = nextInt()
  var B = nextInt()
  solve(X, Y, A, B)
#}}}
