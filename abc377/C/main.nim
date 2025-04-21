when defined SecondCompile:
  const DO_CHECK = false;const DEBUG = false
else:
  const DO_CHECK = true;const DEBUG = true
const
  USE_DEFAULT_TABLE = true
  DO_TEST = false


include lib/header/chaemon_header

solveProc solve(N:int, M:int, a:seq[int], b:seq[int]):
  var s = initSet[(int, int)]()
  Pred a, b
  for i in M:
    let
      a = a[i]
      b = b[i]
    s.incl (a, b)
    for d in 1 .. 2:
      let e = 3 - d
      for x in [a - d, a + d]:
        for y in [b - e, b + e]:
          if x notin 0 ..< N or y notin 0 ..< N: continue
          s.incl (x, y)
  echo N^2 - s.len

when not defined(DO_TEST):
  var N = nextInt()
  var M = nextInt()
  var a = newSeqWith(M, 0)
  var b = newSeqWith(M, 0)
  for i in 0..<M:
    a[i] = nextInt()
    b[i] = nextInt()
  solve(N, M, a, b)
else:
  discard

