when defined SecondCompile:
  const DO_CHECK = false;const DEBUG = false
else:
  const DO_CHECK = true;const DEBUG = true
const
  USE_DEFAULT_TABLE = true
  DO_TEST = false


include lib/header/chaemon_header
import lib/graph/hopcroft_karp
import lib/other/binary_search

solveProc solve(N:int, M:int, S:seq[string]):
  var
    ans = int.inf
  for d in 0 .. 9:
    var v = Seq[N: newSeq[int]()]
    for i in N:
      for j in M:
        if S[i][j] == '0' + d:
          v[i].add j
    var ok = true
    for i in N:
      if v[i].len == 0: ok = false; break
    if not ok: continue
    for i in N:
      # 長さがM以上になるようにvを拡張
      var
        L = v[i].len
        b = M
      while v[i].len < N:
        for j in L:
          v[i].add b + v[i][j]
          if v[i].len >= N: break
        b += M
    var U = -int.inf
    for i in N:
      if v[i].len > N: v[i].setLen(N)
      for j in v[i].len:
        U.max=v[i][j]
    var x:seq[int]
    for i in N:
      x &= v[i]
    x.sort
    x = x.deduplicate(isSorted = true)
    #debug d, v, x
    proc f(t:int):bool =
      # t以下で完全マッチングが作れるか？
      var hk = initHopcroftKarp(N, x.len)
      for i in N:
        for j in v[i].len:
          if v[i][j] > t: break
          let id = x.lowerBound(v[i][j])
          doAssert x[id] == v[i][j]
          hk.addEdge(i, id)
      if hk.maximumMatching().len == N:
        return true
      else:
        return false
    ans.min=f.minLeft(0 .. U)
  if ans.isInf:
    echo -1
  else:
    echo ans
  discard

when not defined(DO_TEST):
  var N = nextInt()
  var M = nextInt()
  var S = newSeqWith(N, nextString())
  solve(N, M, S)
else:
  discard

