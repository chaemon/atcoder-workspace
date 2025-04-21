when defined SecondCompile:
  const DO_CHECK = false;const DEBUG = false
else:
  const DO_CHECK = true;const DEBUG = true
const
  USE_DEFAULT_TABLE = true
  DO_TEST = false


include lib/header/chaemon_header

solveProc solve(N:int, Q:int, T:string, p:seq[int]):
  Pred p
  var a = Seq[N + 1: string]
  for i in 0 ..< N:
    a[i] = '?'.repeat(3^i)
  a[N] = T
  proc update(p:int) =
    var
      h = N
      i = p
    while h > 0:
      i = i div 3
      let s = a[h][i * 3 ..< i * 3 + 3]
      a[h - 1][i] = if s.count('A') >= 2: 'A' else: 'B'
      h.dec
  for p in 3^N:
    update(p)

  for p in p:
    a[N][p] = if a[N][p] == 'A': 'B' else: 'A'
    update(p)
    echo a[0][0]
  discard

when not defined(DO_TEST):
  var N = nextInt()
  var Q = nextInt()
  var T = nextString()
  var p = newSeqWith(Q, nextInt())
  solve(N, Q, T, p)
else:
  discard

