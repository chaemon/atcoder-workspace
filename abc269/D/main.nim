when defined SecondCompile:
  const DO_CHECK = false;const DEBUG = false
else:
  const DO_CHECK = true;const DEBUG = true
const
  USE_DEFAULT_TABLE = true

include lib/header/chaemon_header
import atcoder/dsu

solveProc solve(N:int, X:seq[int], Y:seq[int]):
  var
    id = initTable[(int, int), int]()
    ct = 0
  for i in N:
    id[(X[i], Y[i])] = ct
    ct.inc
  var dsu = initDSU(id.len)
  for i in N:
    let s = id[(X[i], Y[i])]
    for d in [(-1, -1), (-1, 0), (0, -1), (0, 1), (1, 0), (1, 1)]:
      let x = X[i] + d[0]
      let y = Y[i] + d[1]
      if (x, y) in id:
        let t = id[(x, y)]
        dsu.merge(s, t)
  var vis = Seq[id.len: false]
  ans := 0
  for i in N:
    let l = dsu.leader(i)
    if not vis[l]:
      vis[l] = true
      ans.inc
  echo ans
  discard

when not defined(DO_TEST):
  var N = nextInt()
  var X = newSeqWith(N, 0)
  var Y = newSeqWith(N, 0)
  for i in 0..<N:
    X[i] = nextInt()
    Y[i] = nextInt()
  solve(N, X, Y)
else:
  discard

