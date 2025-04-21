when defined SecondCompile:
  const DO_CHECK = false;const DEBUG = false
else:
  const DO_CHECK = true;const DEBUG = true
const
  USE_DEFAULT_TABLE = true
  DO_TEST = false


include lib/header/chaemon_header

import atcoder/modint
const MOD = 998244353
type mint = modint998244353

for r in 0 ..< MOD:
  if (r * r) mod MOD == 5:
    echo r

echo "end!!"

solveProc solve(N:int, x:int, y:int):
  discard

when not defined(DO_TEST):
  var T = nextInt()
  for case_index in 0..<T:
    var N = nextInt()
    var x = nextInt()
    var y = nextInt()
    solve(N, x, y)
else:
  discard

