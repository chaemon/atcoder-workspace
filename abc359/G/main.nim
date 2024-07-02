when defined SecondCompile:
  const DO_CHECK = false;const DEBUG = false
else:
  const DO_CHECK = true;const DEBUG = true
const
  USE_DEFAULT_TABLE = true
  DO_TEST = false


include lib/header/chaemon_header
import lib/graph/graph_template

type S = ref object
  s:int
  a:Table[int, int]

solveProc solve(N:int, u:seq[int], v:seq[int], A:seq[int]):
  Pred u, v, A
  var
    g = initGraph[int](N)
    ct = Seq[N: 0]
  for i in N:
    ct[A[i]].inc
  for i in N - 1:
    g.addBiEdge(u[i], v[i])
  proc merge(a, b:var S):S =
    if a.a.len < b.a.len:
      swap a, b
    for k, v in b.a:
      if k notin a.a:
        a.a[k] = v
        a.s += v * (ct[k] - v)
        doAssert a.s >= 0
      else:
        a.s -= a.a[k] * (ct[k] - a.a[k])
        a.a[k] += v
        a.s += a.a[k] * (ct[k] - a.a[k])
        doAssert a.s >= 0
    return a
  ans := 0
  proc dfs(u, p:int):S =
    result = S(s:0, a:initTable[int, int]())
    result.a[A[u]] = 1
    result.s = ct[A[u]] - 1
    for e in g[u]:
      if e.dst == p: continue
      a := dfs(e.dst, u)
      result = merge(result, a)
    if p != -1:
      ans += result.s
  discard dfs(0, -1)
  echo ans
  discard

when not defined(DO_TEST):
  var N = nextInt()
  var u = newSeqWith(N-1, 0)
  var v = newSeqWith(N-1, 0)
  for i in 0..<N-1:
    u[i] = nextInt()
    v[i] = nextInt()
  var A = newSeqWith(N, nextInt())
  solve(N, u, v, A)
else:
  discard

