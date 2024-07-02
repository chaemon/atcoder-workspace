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

import atcoder/dsu

type Node = object
  l, r, sz:int

solveProc solve(N:int, p:seq[int], q:seq[int]):
  Pred p, q
  var
    nd = Seq[Node]
    pos:seq[int]
    d = initDSU(N)
  for i in N:
    pos.add i
    nd.add Node(l: -1, r: -1, sz:1)
  for i in N - 1:
    let
      lp = d.leader p[i]
      lq = d.leader q[i]
    doAssert lp != lq
    let
      r = nd.len
      s = d.size(lp) + d.size(lq)
    nd.add Node(l:pos[lp], r:pos[lq], sz:s)
    d.merge(lp, lq)
    pos[d.leader(lp)] = r
  let r = pos[d.leader(0)]
  var ans = Seq[N: mint]
  proc dfs(u:int, s:mint) =
    if nd[u].l == -1:
      ans[u] = s
    else:
      let
        a = nd[nd[u].l].sz
        b = nd[nd[u].r].sz
      dfs(nd[u].l, s + mint(a) / mint(a + b))
      dfs(nd[u].r, s + mint(b) / mint(a + b))
  dfs(r, 0)
  echo ans.join(" ")
  discard

when not defined(DO_TEST):
  var N = nextInt()
  var p = newSeqWith(N-1, 0)
  var q = newSeqWith(N-1, 0)
  for i in 0..<N-1:
    p[i] = nextInt()
    q[i] = nextInt()
  solve(N, p, q)
else:
  discard

