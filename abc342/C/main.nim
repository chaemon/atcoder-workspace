when defined SecondCompile:
  const DO_CHECK = false;const DEBUG = false
else:
  const DO_CHECK = true;const DEBUG = true
const
  USE_DEFAULT_TABLE = true
  DO_TEST = false


include lib/header/chaemon_header

solveProc solve(N:int, S:string, Q:int, c:seq[string], d:seq[string]):
  var a = Seq[26:char]
  for i in 26:
    a[i] = 'a' + i
  for q in Q:
    for i in 26:
      if a[i] == c[q][0]:
        a[i] = d[q][0]
  var S = S
  for i in N:
    S[i] = a[S[i] - 'a']
  echo S
  discard

when not defined(DO_TEST):
  var N = nextInt()
  var S = nextString()
  var Q = nextInt()
  var c = newSeqWith(Q, "")
  var d = newSeqWith(Q, "")
  for i in 0..<Q:
    c[i] = nextString()
    d[i] = nextString()
  solve(N, S, Q, c, d)
else:
  discard

