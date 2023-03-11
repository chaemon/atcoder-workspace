const
  DO_CHECK = true
  DEBUG = true
  DO_TEST = false
  USE_DEFAULT_TABLE = true

include lib/header/chaemon_header
import lib/graph/hopcroft_karp
import lib/string/knuth_morris_pratt
import lib/other/bitutils

solveProc solve(S:string):
  var palin = Seq[S.len + 1, S.len + 1: bool.none]
  proc isPalindrome(i, j:int):bool = # i ..< j
    if i == j: return true
    elif i + 1 == j: return true
    if palin[i][j].isSome: return palin[i][j].get
    if S[i] != S[j - 1]: result = false
    else: result = isPalindrome(i + 1, j - 1)
    palin[i][j] = result.some
  p := initSet[string]()
  for i in S.len:
    for j in i + 1 .. S.len:
      if isPalindrome(i, j):
        s := S[i ..< j]
        if s notin p: p.incl s
  var
    a = p.toSeq.sorted
    g = initHopcroftKarp(a.len, a.len)
  for i in a.len:
    for j in a.len:
      if i == j: continue
      if a[i].len > a[j].len: continue
      let v = KnuthMorrisPratt(a[j], a[i])
      if v.len > 0:
        g.addEdge(i, j)
  echo a.len - g.maximum_matching.len
  Naive:
    proc isSubstring(s, t:string):bool =
      var (s, t) = (s, t)
      if s.len > t.len: swap s, t
      for i in 0..t.len - s.len:
        if s == t[i ..< i + s.len]: return true
      return false
    var palin = Seq[S.len + 1, S.len + 1: bool.none]
    proc isPalindrome(i, j:int):bool = # i ..< j
      if i == j: return true
      elif i + 1 == j: return true
      if palin[i][j].isSome: return palin[i][j].get
      if S[i] != S[j - 1]: result = false
      else: result = isPalindrome(i + 1, j - 1)
      palin[i][j] = result.some
    p := initSet[string]()
    for i in S.len:
      for j in i + 1 .. S.len:
        if isPalindrome(i, j):
          s := S[i ..< j]
          if s notin p: p.incl s
    var
      a = p.toSeq
      ans = -int.inf
    for b in 2^a.len:
      v := newSeq[string]()
      for i in a.len:
        if b[i] == 1:
          v.add a[i]
      ok := true
      for i in v.len:
        for j in i + 1 ..< v.len:
          if isSubstring(v[i], v[j]): ok = false
      if ok: ans.max= v.len
    echo ans



when not DO_TEST:
  var S = nextString()
  solve(S)
  #test(S)
else:
  const N = 12
  for b in 2^N:
    S := 'a'.repeat(N)
    for i in N:
      if b[i] == 1: S[i] = 'b'
    debug S
    test(S)
  discard

