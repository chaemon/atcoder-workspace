const
  DO_CHECK = true
  DEBUG = true
  DO_TEST = false
include atcoder/extra/header/chaemon_header


solveProc solve(N:int, P:int, Q:int, A:seq[int]):
  ans := 0
  for i in N:
    var p = A[i]
    for j in i + 1 ..< N:
      var p = (p * A[j]) mod P
      for k in j + 1 ..< N:
        var p = (p * A[k]) mod P
        for l in k + 1 ..< N:
          var p = (p * A[l]) mod P
          for m in l + 1 ..< N:
            var p = (p * A[m]) mod P
            if p == Q: ans.inc
  echo ans
  return

# input part {{{
when not DO_TEST:
  var N = nextInt()
  var P = nextInt()
  var Q = nextInt()
  var A = newSeqWith(N, nextInt())
  solve(N, P, Q, A)
#}}}

