when defined SecondCompile:
  const DO_CHECK = false;const DEBUG = false
else:
  const DO_CHECK = true;const DEBUG = true
const
  USE_DEFAULT_TABLE = true
  DO_TEST = false

include lib/header/chaemon_header

solveProc solve(N:int, M:int, B:seq[int], W:seq[int]):
  shadow B, W
  B.sort(Descending)
  W.sort(Descending)
  var b = 0
  while b < B.len and B[b] >= 0:
    b.inc
  var
    ans = -int.inf
    sw = 0
    sb = B[0 ..< b].sum
  for w in 0 .. W.len:
    # 白をw個
    # 黒はw <= bならb個
    # そうでなければw個
    ans.max= sw + sb
    if w == W.len: break
    if w >= B.len: break
    sw += W[w]
    if w >= b:
      sb += B[w]
  echo ans
  doAssert false

when not defined(DO_TEST):
  var N = nextInt()
  var M = nextInt()
  var B = newSeqWith(N, nextInt())
  var W = newSeqWith(M, nextInt())
  solve(N, M, B, W)
else:
  discard

