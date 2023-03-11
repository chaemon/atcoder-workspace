const
  DO_CHECK = true
  DEBUG = true
  DO_TEST = false
  USE_DEFAULT_TABLE = true

include lib/header/chaemon_header


solveProc solve(N:int, X:int, S:string):
  var
    X = X
    v = Seq[int]
  while X > 0:
    if X mod 2 == 0:
      v.add 0
    else:
      v.add 1
    X = X div 2
  v.reverse
  for s in S:
    if s == 'U':
      discard v.pop
    elif s == 'L':
      v.add 0
    elif s == 'R':
      v.add 1
  v.reverse
  var
    p = 1
    ans = 0
  for i in v.len:
    ans += p * v[i]
    p *= 2
  echo ans
  discard

when not DO_TEST:
  var N = nextInt()
  var X = nextInt()
  var S = nextString()
  solve(N, X, S)
else:
  discard

