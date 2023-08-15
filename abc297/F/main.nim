when defined SecondCompile:
  const DO_CHECK = false;const DEBUG = false
else:
  const DO_CHECK = true;const DEBUG = true
const
  USE_DEFAULT_TABLE = true
  DO_TEST = false


include lib/header/chaemon_header
import lib/other/bitutils
import lib/math/combination

import atcoder/modint
const MOD = 998244353
type mint = modint998244353
solveProc solve(H:int, W:int, K:int):
  ans := mint(0)
  for x in H:
    for y in W:
      # (x, y)が含まれる配置個数を数える
      for b in 2^4:
        # b[i] = 0のとき、(x, y)からその方向に駒がある
        # つまり、すべてのビットが0のものを包除
        var
          xmin = 0
          xmax = H - 1
          ymin = 0
          ymax = W - 1
          ct = 0
        for i in 4:
          if b[i] == 1:
            ct.inc
            case i:
              of 0:
                xmax.min=x - 1
              of 1:
                xmin.max=x + 1
              of 2:
                ymax.min=y - 1
              of 3:
                ymin.max=y + 1
              else:
                doAssert false
        var s = 1
        if xmax < 0 or xmin >= H or ymax < 0 or ymin >= W or xmin > xmax or ymin > ymax:
          s = -1
        else:
          s = (xmax - xmin + 1) * (ymax - ymin + 1)
          if ct mod 2 == 0:
            ans += mint.C(s, K)
          else:
            ans -= mint.C(s, K)
  echo ans / mint.C(H * W, K)
  discard

when not defined(DO_TEST):
  var H = nextInt()
  var W = nextInt()
  var K = nextInt()
  solve(H, W, K)
else:
  discard

