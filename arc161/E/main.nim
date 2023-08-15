when defined SecondCompile:
  const DO_CHECK = false;const DEBUG = false
else:
  const DO_CHECK = true;const DEBUG = true
const
  USE_DEFAULT_TABLE = true
  DO_TEST = false

include lib/header/chaemon_header
import atcoder/twosat
import random

# Failed to predict input format
solveProc solve():
  let T = nextInt()
  for _ in T:
    let 
      N = nextInt()
      M = (3 * N) div 2
    var adj = Seq[N: seq[int]]
    for i in M:
      let A, B = nextInt() - 1
      adj[A].add B
      adj[B].add A
    proc is_ok(S:string):bool =
      var ts = initTwoSat(N)
      for u in N:
        var cl:bool
        if S[u] == 'W': cl = false
        else: cl = true
        for i in 3:
          var j = i + 1
          if j == 3: j = 0
          ts.add_clause(adj[u][i], cl, adj[u][j], cl)
      return not ts.satisfiable()
    while true:
      var S:string
      for i in N:
        if random.rand(0 .. 1) == 0:
          S.add 'W'
        else:
          S.add 'B'
      if is_ok(S): echo S;break
  discard

when not DO_TEST:
  solve()
else:
  discard

