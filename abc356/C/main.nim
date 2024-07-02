when defined SecondCompile:
  const DO_CHECK = false;const DEBUG = false
else:
  const DO_CHECK = true;const DEBUG = true
const
  USE_DEFAULT_TABLE = true
  DO_TEST = false


include lib/header/chaemon_header
import lib/other/bitutils

# Failed to predict input format
solveProc solve():
  let N, M, K = nextInt()
  var v:seq[tuple[A:int, R:bool]]
  for i in M:
    var A = 0
    let C = nextInt()
    for _ in C:
      var a = nextInt() - 1
      A[a] = 1
    var
      c = nextString()
      R:bool
    if c[0] == 'o': R = true
    elif c[0] == 'x': R = false
    else: doAssert false
    v.add (A, R)
  ans := 0
  for b in 2^N:
    ok := true
    for i in M:
      let R = popcount(v[i].A and b) >= K
      if R != v[i].R: ok = false;break
    if ok:
      ans.inc
  echo ans
  discard

when not DO_TEST:
  solve()
else:
  discard

