const
  DO_CHECK = true
  DEBUG = true
  DO_TEST = false
include atcoder/extra/header/chaemon_header

const YES = "Yes"
const NO = "No"

import atcoder/dsu

# Failed to predict input format
block main:
  let H, W = nextInt()
  var
    d = initDSU(H * W)
    a = Seq[H, W: false]
  let Q = nextInt()
  for _ in Q:
    let t = nextInt()
    if t == 1:
      var r, c = nextInt() - 1
      a[r][c] = true
      for (dr, dc) in @[(0, 1), (1, 0), (0, -1), (-1, 0)]:
        let r2 = r + dr
        if r2 notin 0 ..< H: continue
        let c2 = c + dc
        if c2 notin 0 ..< W: continue
        if a[r2][c2]:
          d.merge(r * W + c, r2 * W + c2)
    else:
      let r1, c1, r2, c2 = nextInt() - 1
      if a[r1][c1] and a[r2][c2] and d.same(r1 * W + c1, r2 * W + c2):
        echo YES
      else:
        echo NO
  discard

