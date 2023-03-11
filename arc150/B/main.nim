when defined SecondCompile:
  const DO_CHECK = false;const DEBUG = false
else:
  const DO_CHECK = true;const DEBUG = true
const
  USE_DEFAULT_TABLE = true

include lib/header/chaemon_header

const MX = 45000

# Failed to predict input format
solveProc solve(A, B:int):
  if B <= A:
    echo A - B;return
  # B > A
  k := 1
  ans := int.inf
  # X = 0
  block:
    # B + Y = k * A
    var
      r = B mod A
      Y = A - r
    if Y == A: Y = 0
    ans.min= Y
  for k in 1 .. MX:
    # Y in 0 ..< k
    let Y0 = (-B).floorMod k
    let X0 = (B + Y0) div k - A
    if X0 >= 0:
      ans.min= X0 + Y0
  for a in 1 .. MX:
    # (B + Y) / k = a
    if a - A < 0: continue
    let X = a - A
    # Y = k * a - Bとなる最小のYを探す
    let kmax = B.ceilDiv a
    let Y = kmax * a - B
    ans.min= X + Y
    discard
  echo ans
  discard

when not defined(DO_TEST):
  let T = nextInt()
  for _ in T:
    let A, B = nextInt()
    solve(A, B)
else:
  discard

