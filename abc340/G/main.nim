when defined SecondCompile:
  const DO_CHECK = false;const DEBUG = false
else:
  const DO_CHECK = true;const DEBUG = true
const
  USE_DEFAULT_TABLE = true
  DO_TEST = false


include lib/header/chaemon_header

import atcoder/modint
const MOD = 998244353
type mint = modint998244353

import lib/graph/graph_template

solveProc solve(N:int, A:seq[int], u:seq[int], v:seq[int]):
  Pred A, u, v
  var
    g = initGraph[int](N)
    ans = mint(0)
  for i in N - 1:
    g.addBiEdge(u[i], v[i])

  proc dfs(u, p:int):Table[int, mint] =
    # uを葉にする(色はA[u]限定) or uを通過する(二本以上)
    var a = initDeque[Table[int, array[1 .. 2, mint]]]()
    for e in g[u]:
      let v = e.dst
      if v == p: continue
      var
        t = dfs(v, u)
        t2 = initTable[int, array[1 .. 2, mint]]()
      for k, v in t:
        t2[k] = [v, 0]
      a.addLast t2
    if a.len == 0:
      result = {A[u]: mint(1)}.toTable
    else:
      while a.len >= 2:
        var
          p, q = a.popFirst
          r = p
        for k, v in q:
          if k notin r:
            r[k] = v
          else: # 両方存在
            # p, qのものを足す
            r[k][2] += (p[k][1] + p[k][2]) * (v[1] + v[2])
        a.addLast r
      result = initTable[int, mint]()
      for k, v in a[0]:
        if k == A[u]:
          ans += v[1] + v[2]
        else:
          ans += v[2]
        result[k] = v[1] + v[2]
      if A[u] notin a[0]:
        a[0][A[u]] = [mint(0), mint(0)]
      a[0][A[u]][1].inc

    ans += 1 #自分自身だけのものを足す
    debug u, p, A[u], ans, result
    if a.len > 0:
      debug a[0]
  discard dfs(0, -1)
  echo ans
  discard

when not defined(DO_TEST):
  var N = nextInt()
  var A = newSeqWith(N, nextInt())
  var u = newSeqWith(N-1, 0)
  var v = newSeqWith(N-1, 0)
  for i in 0..<N-1:
    u[i] = nextInt()
    v[i] = nextInt()
  solve(N, A, u, v)
else:
  discard

