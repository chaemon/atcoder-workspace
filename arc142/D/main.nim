const
  DO_CHECK = true
  DEBUG = true
  #DO_TEST = true
  DO_TEST = false
  USE_DEFAULT_TABLE = true

include lib/header/chaemon_header
import lib/graph/graph_template
import lib/other/bitutils

import atcoder/modint
const MOD = 998244353
type mint = modint998244353

import lib/other/random_tree

proc calc(a, base:seq[mint]):mint =
  var dp = [mint(1), mint(0)] # baseだけの積, aを含む積の和
  for i in a.len:
    var dp2 = dp
    for j in dp.len: dp2[j] *= base[i]
    dp2[1] += dp[0] * a[i]
    dp = dp2.move
  return dp[^1]
proc calc2(a, b, base:seq[mint]):mint =
  var dp = [mint(1), mint(0), mint(0), mint(0)] # baseだけの積, a, bを含む積の和
  for i in a.len:
    var dp2 = dp
    for j in dp.len: dp2[j] *= base[i]
    dp2[1] += dp[0] * a[i]
    dp2[2] += dp[0] * b[i]
    dp2[3] += dp[1] * b[i] + dp[2] * a[i]
    dp = dp2.move
  return dp[^1]


solveProc solve(N:int, a:seq[int], b:seq[int]):
  var g = initGraph[int](N)
  for i in N - 1:
    g.addBiEdge(a[i], b[i])
  proc dfs(u, p:int):tuple[e: tuple[bb, bw, w:mint], p: tuple[b, w:mint]] =
    # 戻り値
    # 黒で完結(次の手は白) e.bw
    # 黒で完結(次の手は黒) e.bb
    # 白で完結             e.w
    # 全黒で継続           p.b
    # 白-黒*で継続         p.w
    var v = collect(newSeq):
      for e in g[u]:
        if e.dst == p: continue
        dfs(e.dst, u)
    var
      ebw = v.mapIt(it.e.bw)
      ebb = v.mapIt(it.e.bb)
      ew = v.mapIt(it.e.w)
      pb = v.mapIt(it.p.b)
      pw = v.mapIt(it.p.w)

    result.e.bw = block:
      #白-黒*(3)で残りは白で完結
      #s := mint(0)
      #for i in v.len:
      #  p := mint(1)
      #  for j in v.len:
      #    if i == j: p *= v[j].p.w
      #    else: p *= v[j].e.w
      #  s += p
      #s
      calc(pw, ew)
    result.e.w = block: # 1つ全黒であとは黒(次の手白)で完結
      #s := mint(0)
      #for i in v.len:
      #  p := mint(1)
      #  for j in v.len:
      #    if i == j:
      #      p *= v[j].p.b
      #    else:
      #      p *= v[j].e.bw
      #  s += p
      #s
      calc(pb, ebw)
    result.p.b = block:
      # 1つ全黒で残り黒(次の手黒)で完結
      # またはuから開始つまり、uは黒でuの子は全部白で完結
      #s := mint(0)
      #for i in v.len:
      #  p := mint(1)
      #  for j in v.len:
      #    if i == j: p *= v[j].p.b
      #    else: p *= v[j].e.bb
      #  s += p
      p := mint(1)
      for i in v.len:
        p *= v[i].e.w
      calc(pb, ebb) + p
    result.p.w = block:
      # (1) 1つ白-黒*で残り黒で完結(次の手黒)
      # (2) uは白であと全部黒(次の手白)で完結
      #s := mint(0)
      #for i in v.len:
      #  p := mint(1)
      #  for j in v.len:
      #    if i == j: p *= v[j].p.w
      #    else: p *= v[j].e.bb
      #  s += p
      p := mint(1)
      for i in v.len:
        p *= v[i].e.bw
      calc(pw, ebb) + p
    result.e.bb = block:
      # 全黒(2)と白-黒*(3)の付け合せ
      # 残りは黒(次の手黒)で完結
      #s := mint(0)
      #for i in v.len:
      #  for j in v.len:
      #    if i == j: continue
      #    p := mint(1)
      #    for k in v.len:
      #      if k == i:
      #        p *= v[k].p.b
      #      elif k == j:
      #        p *= v[k].p.w
      #      else:
      #        p *= v[k].e.bb
      #    s += p
      #s
      calc2(pb, pw, ebb)

  let v = dfs(0, -1)
  echo v.e.bb + v.e.bw + v.e.w
  Naive:
    var g = initGraph[int](N)
    for i in N - 1:
      g.addBiEdge(a[i], b[i])
    proc adj(b:int):int =
      found := initSet[int]()
      next := 0
      ok := true
      used_edge := Seq[N, N: false]
      proc f(u:int) =
        # uの行き先を決める
        if u == N:
          # 見つかった
          if found.len >= 1 and next notin found:
            ok = false
            return
          found.incl next
        elif b[u] == 0:
          f(u + 1)
          if not ok: return
        else:
          for e in g[u]:
            if next[e.dst] == 1 or used_edge[u][e.dst]:
              continue
            used_edge[u][e.dst] = true
            used_edge[e.dst][u] = true
            next[e.dst] = 1
            f(u + 1)
            if not ok: return
            used_edge[u][e.dst] = false
            used_edge[e.dst][u] = false
            next[e.dst] = 0
      f(0)
      if not ok: return -1
      elif found.len == 0: return -1
      else:
        doAssert found.len == 1
        for s in found:
          return s
    proc test(b:int):bool =
      let b1 = adj(b)
      if b1 == -1: return false
      let b2 = adj(b1)
      if b2 == -1: return false
      return true
    ans := 0
    for b in 1 ..< 2^N:
      if test(b):
        # debug "found: ", @b
        ans.inc
    echo ans
  discard

when not DO_TEST:
  var N = nextInt()
  var a = newSeqWith(N-1, 0)
  var b = newSeqWith(N-1, 0)
  for i in 0..<N-1:
    a[i] = nextInt() - 1
    b[i] = nextInt() - 1
  solve(N, a, b)
  #solve_naive(N, a, b)
else:
  for N in 2..7:
    var t = random_tree(N)
    debug t.len
    for e in random_tree(N):
      var a, b = newSeq[int]()
      for (x, y) in e:
        a.add x
        b.add y
      test(N, a, b)
