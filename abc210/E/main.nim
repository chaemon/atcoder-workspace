const
  DO_CHECK = true
  DEBUG = true
  DO_TEST = false
include atcoder/extra/header/chaemon_header

solveProc solve(N:int, M:int, A:seq[int], C:seq[int]):
  var v = Seq[(int, int)]
  for i in M:
    v.add((C[i], A[i]))
  v.sort
  var
    n = N
    ans = 0
  for (C, A) in v:
    let m = gcd(N, A)
    let n2 = gcd(n, m)
    # make n -> n2
    let d = n div n2
    ans += (d - 1) * n2 * C
    n = n2
    if n == 1: break
  if n > 1:
    echo -1
  else:
    echo ans
  return

# input part {{{
when not DO_TEST:
  var N = nextInt()
  var M = nextInt()
  var A = newSeqWith(M, 0)
  var C = newSeqWith(M, 0)
  for i in 0..<M:
    A[i] = nextInt()
    C[i] = nextInt()
  solve(N, M, A, C)
#}}}

