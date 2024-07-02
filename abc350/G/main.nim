when defined SecondCompile:
  const DO_CHECK = false;const DEBUG = false
else:
  const DO_CHECK = true;const DEBUG = true
const
  USE_DEFAULT_TABLE = true
  DO_TEST = false


include lib/header/chaemon_header
import lib/other/bitset

const MOD = 998244353

# Failed to predict input format
solveProc solve():
  let N, Q = nextInt()
  var
    X = 0
    v = newSeqWith(N, initBitSet[100010]())
  for _ in Q:
    let a, b, c = nextInt()
    var
      A = 1 + ((a * (1 + X)) mod MOD) mod 2
      B = 1 + ((b * (1 + X)) mod MOD) mod N
      C = 1 + ((c * (1 + X)) mod MOD) mod N
    B.dec
    C.dec
    if A == 1:
      v[B][C] = 1
      v[C][B] = 1
    else:
      var
        u = v[B] and v[C]
        f = u.firstSetBit()

      if f != u.N:
        X = f
      else:
        X = 0
      echo X
  discard

when not DO_TEST:
  solve()
else:
  discard

