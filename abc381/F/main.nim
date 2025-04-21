when defined SecondCompile:
  const DO_CHECK = false;const DEBUG = false
else:
  const DO_CHECK = true;const DEBUG = true
const
  USE_DEFAULT_TABLE = true


include lib/header/chaemon_header
import lib/other/bitutils

const X = 20
#const X = 3

solveProc solve(N:int, A:seq[int]):
  Pred A
  var
    next = Seq[N + 1: seq[int]] # next[i][x]: i以降でxが現れる最初の位置の次。なかったらinf
    next0 = Seq[X: int.inf]
    nextnext = Seq[N, X: int.inf]
  next[N] = next0
  for i in 0 ..< N << 1:
    next0[A[i]] = i + 1
    next[i] = next0
  #debug A
  #debug next
  for i in 0 ..< N:
    for x in X:
      if next[i][x] < N:
        nextnext[i][x] = next[next[i][x]][x]
  #debug nextnext
  var
    dp = Seq[2^X: int.inf]
    ans = 0
  dp[0] = 0
  for b in 0 ..< 2^X:
    if dp[b].isInf: continue
    ans.max=b.popCount * 2
    let i = dp[b]
    if i == N: continue
    for x in X:
      if b[x] == 0 and not nextnext[i][x].isInf:
        dp[b xor [x]].min=nextnext[i][x]
  echo ans
  Naive:
    proc is_1122(a:seq[int]):bool =
      if a.len mod 2 != 0: return false
      var
        i = 0
        appeared = initSet[int]()
      while i < a.len:
        if a[i] != a[i + 1] or a[i] in appeared:
          return false
        appeared.incl a[i]
        i += 2
      return true
    var ans = 0
    for b in 2^N:
      let s = b.popCount
      if s mod 2 != 0: continue
      var a:seq[int]
      for i in N:
        if b[i] == 1:
          a.add A[i]
      if is_1122(a): ans.max= s
    echo ans
05f5c836aa770
const
  DO_TEST = false
when not declared(DO_TEST) or (not DO_TEST):
  var N = nextInt()
  var A = newSeqWith(N, nextInt())
  solve(N, A)
else:
  #let
  #  A = @[3, 3, 1, 3]
  #  N = A.len
  #solve(N, A)
  #test(N, A)
  when true:
    import random
    while true:
      let N = 9
      var A:seq[int]
      for i in N:
        A.add random.rand(1 .. 4)
      debug N, A
      test(N, A)
  discard

