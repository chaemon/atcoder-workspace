const
  DO_CHECK = true
  DEBUG = true
  DO_TEST = false

include lib/header/chaemon_header

proc id(x:char):int =
  if x == 'G': return 0
  elif x == 'C': return 1
  else: return 2

proc win(x, y:char):int =
  var
    x0 = id(x)
    y0 = id(y)
  if x0 == y0: return 0
  elif (x0 + 1) mod 3 == y0: return 1
  else: return -1

# Failed to predict input format

solveProc solve():
  let N, M = nextInt()
  let A = Seq[N * 2: nextString()]
  var w = Seq[N * 2: 0]
  for j in M:
    var v = Seq[(int, int)]
    for i in N * 2:
      v.add((-w[i], i))
    v.sort()
    for i in N:
      let s = v[i * 2][1]
      let t = v[i * 2 + 1][1]
      if win(A[s][j], A[t][j]) == 1:
        w[s].inc
      elif win(A[t][j], A[s][j]) == 1:
        w[t].inc
  var v = Seq[(int, int)]
  for i in N * 2:
    v.add((-w[i], i))
  v.sort()
  for i in v.len:
    echo v[i][1] + 1
  discard

block main:
  solve()
  discard

