when defined SecondCompile:
  const DO_CHECK = false;const DEBUG = false
else:
  const DO_CHECK = true;const DEBUG = true
const
  USE_DEFAULT_TABLE = true
  DO_TEST = false


include lib/header/chaemon_header

solveProc solve(N:int, H:seq[int]):
  var ans = 1
  for d in 1 .. N - 1:
    for r in 0 ..< d:
      proc calc(v:seq[int]):int =
        var
          i = 0
          ans = 0
        while i < v.len:
          j := i
          while j < v.len and v[j] == v[i]:
            j.inc
          ans.max=j - i
          i = j
        return ans
      var
        i = r
        v:seq[int]
      while i < N:
        v.add H[i]
        i += d
      if v.len == 0: continue
      ans.max=v.calc()
  echo ans
  doAssert false

when not defined(DO_TEST):
  var N = nextInt()
  var H = newSeqWith(N, nextInt())
  solve(N, H)
else:
  discard

