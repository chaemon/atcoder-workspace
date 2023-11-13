when defined SecondCompile:
  const DO_CHECK = false;const DEBUG = false
else:
  const DO_CHECK = true;const DEBUG = true
const
  USE_DEFAULT_TABLE = true
  DO_TEST = false


include lib/header/chaemon_header

const B = 100

solveProc solve(N:int, X:seq[seq[int]], Y:seq[seq[int]], Z:seq[seq[int]]):
  var a = Seq[B, B, B: int32(-1)]
  for i in N:
    for x in X[i][0] ..< X[i][1]:
      for y in Y[i][0] ..< Y[i][1]:
        for z in Z[i][0] ..< Z[i][1]:
          doAssert a[x][y][z] == -1.int32
          a[x][y][z] = i.int32
  var adj = Seq[N: initSet[int32]()]
  for x in B:
    for y in B:
      for z in B:
        let s = a[x][y][z]
        if s == -1: continue
        if x + 1 < B:
          let t = a[x + 1][y][z]
          if t != -1 and s != t:
            adj[s].incl t.int32
            adj[t].incl s.int32
        if y + 1 < B:
          let t = a[x][y + 1][z]
          if t != -1 and s != t:
            adj[s].incl t.int32
            adj[t].incl s.int32
        if z + 1 < B:
          let t = a[x][y][z + 1]
          if t != -1 and s != t:
            adj[s].incl t.int32
            adj[t].incl s.int32
  for i in N:
    echo adj[i].len
  discard

when not defined(DO_TEST):
  var N = nextInt()
  var X, Y, Z = Seq[N, 2: int(0)]
  for i in N:
    for j in 2:
      X[i][j] = nextInt()
      Y[i][j] = nextInt()
      Z[i][j] = nextInt()
  solve(N, X, Y, Z)
else:
  discard

