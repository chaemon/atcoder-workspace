const
  DO_CHECK = true
  DEBUG = true
  USE_DEFAULT_TABLE = true

when defined(DO_TEST):
  const DO_TEST = true
else:
  const DO_TEST = false

include lib/header/chaemon_header
import atcoder/segtree

solveProc solve(N:int, K:int, p:seq[int]):
  if K == 0:
    var p = p
    for a in p.mitems: a.inc
    echo p.join(" ")
    return
  var
    v = min(p[^(1 + K - 1) .. ^1])
    selected = initSet[int]()
  proc calc(a:seq[int], K:int):seq[int] =
    if a.len == 0: return
    # K個まで消せる
    # K番目のインデックスまでで最小を残す
    #doAssert a.len > K
    var st = initSegTree[int](a.len, (a, b:int)=>min(a, b), ()=>int.inf)
    for i in a.len:
      st[i] = a[i]
    var
      i = 0
      K = K
    while i < a.len and K > 0:
      if a.len - i <= K: i = a.len; break
      var t = st[i .. min(K + i, a.len - 1)] # 最大でK個
      while true:
        if a[i] != t:
          doAssert a[i] > t
          K.dec;i.inc
        else:
          break
      result.add t
      i.inc
    while i < a.len:
      result.add a[i]
      i.inc
  var ans = calc(p, K)
  if ans[0] >= v:
    let k = p.find(v)
    # vを先頭に持ってくる
    # k ..< Nは必ず操作する
    selected.incl v
    var a = calc(p[0 ..< k], K - (N - k))
    # 後方についてa[0]より小さいものだけ残す
    var ans0 = @[v]
    if a.len > 0:
      var
        p2 = p[k + 1 ..< N]
        st = initSegTree[int](p2, (a, b:int)=>min(a, b), ()=>int.inf)
        i = 0
        a0 = int.inf
      if a.len > 0: a0.min=a[0]
      while i < p2.len:
        var u = st[i ..< p2.len]
        if u > a0: break
        while i < p2.len:
          if p2[i] == u: break
          i.inc
          doAssert i < p2.len
        doAssert p2[i] == u
        ans0.add u
        i.inc
    ans0 &= a
    ans.min=ans0
  for a in ans.mitems:a.inc
  echo ans.join(" ")
  Naive:
    var ans = newSeq[seq[int]]()
    proc calc(a:seq[int], K:int) =
      ans.add a
      if K == 0: return
      for i in a.len:
        var a = a[0 .. i - 1] & a[i + 1 ..< a.len]
        calc(a, K - 1)
      var a = a[^1] & a[0 ..< ^1]
      calc(a, K - 1)
    calc(p, K)
    ans.sort()
    var a = ans[0]
    for a in a.mitems: a.inc
    echo a.join(" ")
  discard

when not DO_TEST:
  var N = nextInt()
  var K = nextInt()
  var p = newSeqWith(N, nextInt() - 1)
  solve(N, K, p)
else:
  #block:
  #  var
  #    N = 5
  #    K = 4
  #    p = @[1, 0, 2, 3, 4]
  #  test(N, K, p)
  let N = 6
  var p = (0 ..< N).toSeq
  while true:
    for K in 0 .. N - 1:
      debug "test for", N, K, p
      test(N, K, p)
    if not p.nextPermutation: break
  #discard

