include atcoder/extra/header/chaemon_header

import atcoder/math as math_lib2

const DEBUG = true

# Failed to predict input format
block main:
  let T = nextInt()
  for _ in T:
    var ans = int.inf
    let X, Y, P, Q = nextInt()
    let m = @[(X + Y)*2, P + Q]
    for r in X..<X+Y:
      for r2 in P..<P+Q:
        let (y, z) = crt([r, r2], m)
        if y == 0 and z == 0: continue
        ans.min=y
    if ans == int.inf: echo "infinity"
    else: echo ans

