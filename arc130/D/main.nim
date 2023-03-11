const
  DO_CHECK = true
  DEBUG = true
  DO_TEST = false
  USE_DEFAULT_TABLE = true

include lib/header/chaemon_header
import lib/graph/graph_template
import lib/math/combination
import lib/dp/cumulative_sum

import atcoder/modint
const MOD = 998244353
type mint = modint998244353

proc merge(a, b:seq[mint]):seq[mint] = # 最小値でやる
  if a.len == 0: return b
  elif b.len == 0: return a
  var
    a = a
    b = b
  result = newSeq[mint](a.len + b.len)
  for ct in 2:
    cs := initCumulativeSum[mint](b)
    for i in a.len:
      # a[i]が最小値となるように調整
      # 小さい値がi個, 大きい値がa.len - 1 - i個
      for j in 0 .. b.len:
        # j個を小さい方に挿入。最小値はインデックスj以降
        result[i + j] += a[i] * mint.C(i + j, i) * mint.C(a.len - i - 1 + b.len - j, b.len - j) * cs[j .. ^1]
    swap a, b
  discard

import random

proc random_tree(N:int):tuple[a, b:seq[int]] =
  var
    a, b = newSeq[int]()
    l = @[0]
    r = (1..<N).toSeq
  while r.len > 0:
    var
      i = random.rand(0 ..< l.len)
      j = random.rand(0 ..< r.len)
    swap r[j], r[^1]
    a.add l[i]
    let u = r.pop()
    b.add u
    l.add u
  return (a, b)

iterator all_tree(N:int):tuple[a, b:seq[int]] =
  var ans = newSeq[tuple[a, b:seq[int]]]()
  proc calc(a, b, l, r:seq[int]) =
    if r.len == 0:
      ans.add((a, b))
    else:
      for i in 0 ..< l.len:
        for j in 0 ..< r.len:
          var
            l = l
            r = r
            a = a
            b = b
          swap r[j], r[^1]
          a.add l[i]
          let u = r.pop()
          b.add u
          l.add u
          calc(a, b, l, r)
  calc(@[], @[], @[0], (1..<N).toSeq)
  for p in ans:
    yield p

solveProc solve(N:int, a:seq[int], b:seq[int]):
  var g = initGraph[int](N)
  for i in N - 1: g.addBiEdge(a[i], b[i])
  proc dfs(u, p, t:int):seq[mint] =
    v := Seq[mint]
    child := 0
    for e in g[u]:
      if p == e.dst: continue
      child.inc
      a := dfs(e.dst, u, 1 - t)
      if t == 1: a.reverse
      v = merge(v, a)
    if child == 0: return @[mint(1)]
    result = Seq[v.len + 1: mint(0)]
    s := mint(0)
    for i in countdown(v.len, 0):
      result[i] = s
      if i == 0: break
      s += v[i - 1]
    if t == 1: result.reverse
  echo dfs(0, -1, 0).sum * 2
  Naive:
    var g = initUndirectedGraph[int](N, a, b)
    proc test(a:seq[int]):bool =
      for u in N:
        var
          m = int.inf
          M = -int.inf
        for e in g[u]:
          m.min= a[e.dst]
          M.max= a[e.dst]
        if m <= a[u] and a[u] <= M: return false
      return true
    var
      a = (0 ..< N).toSeq
      ans = 0
    while true:
      if test(a): ans.inc
      if not a.nextPermutation(): break
    echo ans
  return

when not DO_TEST:
  var N = nextInt()
  var a = newSeqWith(N-1, 0)
  var b = newSeqWith(N-1, 0)
  for i in 0..<N-1:
    a[i] = nextInt() - 1
    b[i] = nextInt() - 1
  solve(N, a, b)
else:
  let N = 1000
  #for (a, b) in all_tree(N):
  for _ in 1000:
    let (a, b) = random_tree(N)
    #debug N, a, b
    #test(N, a, b)
    solve(N, a, b)

