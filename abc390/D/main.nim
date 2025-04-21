when defined SecondCompile:
  const DO_CHECK = false;const DEBUG = false
else:
  const DO_CHECK = true;const DEBUG = true
const
  USE_DEFAULT_TABLE = true
  DO_TEST = false


include lib/header/chaemon_header
import lib/other/bitutils

solveProc solve(N:int, A:seq[int]):
  var
    used = 0
    ans = initSet[int]()
  proc f(s:int) =
    var v:seq[int]
    for i in N:
      if used[i] == 0:
        v.add i
    if v.len == 0:
      ans.incl s;return
    # v[0]は必ず入れる
    used[v[0]] = 1
    for b in 2^(v.len - 1):
      var p = A[v[0]]
      for i in N:
        if b[i] == 1:
          used[v[i + 1]] = 1
          p += A[v[i + 1]]
      f(s xor p)
      for i in N:
        if b[i] == 1:
          used[v[i + 1]] = 0
    used[v[0]] = 0
  f(0)
  echo ans.len
  discard

when not defined(DO_TEST):
  var N = nextInt()
  var A = newSeqWith(N, nextInt())
  solve(N, A)
else:
  discard

