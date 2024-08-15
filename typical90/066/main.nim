const
  DO_CHECK = true
  DEBUG = true
  DO_TEST = false
include atcoder/extra/header/chaemon_header



solveProc solve(N:int, L:seq[int], R:seq[int]):
  var
    ans = 0.0
    d:seq[float]
  for i in N:
    d.add float(R[i] - L[i] + 1)
  for i in N:
    for j in i + 1 ..< N:
      for k in L[i] .. R[i]:
        for l in L[j] .. R[j]:
          if k > l:
            ans += 1.0 / (d[i] * d[j])
  echo ans
  return

# input part {{{
when not DO_TEST:
  var N = nextInt()
  var L = newSeqWith(N, 0)
  var R = newSeqWith(N, 0)
  for i in 0..<N:
    L[i] = nextInt()
    R[i] = nextInt()
  solve(N, L, R)
#}}}

