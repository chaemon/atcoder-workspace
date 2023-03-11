when defined SecondCompile:
  const DO_CHECK = false;const DEBUG = false
else:
  const DO_CHECK = true;const DEBUG = true
const
  USE_DEFAULT_TABLE = true

include lib/header/chaemon_header

converter toInt16(a:int):int16 = a.int16

solveProc solve(N:int, M:int, a:seq[int], b:seq[int], Q:int, s:seq[int], t:seq[int]):
  Pred a, b, s, t
  ans := Seq[N, N: int16.inf]
  var es:seq[tuple[w, a, b:int16]]
  for i in M:
    let
      a = a[i].int16
      b = b[i].int16
    es.add (max(a, b), a, b)
  es.sort
  var 
    reacheable = Seq[N: seq[int]]
    rev_reacheable = Seq[N: seq[int]]
  for u in N:
    reacheable[u].add u
    rev_reacheable[u].add u
  # 重みの小さい順(一度決まったものは更新しない)
  for (w, a, b) in es:
    # a -> bの辺が追加
    # 追加前から移動可能か?
    if not ans[a][b].isInf:
      continue
    debug a, b, w
    var
      ar = rev_reacheable[a]
      br = reacheable[b]
    debug ar, br
    for a1 in ar:
      for b1 in br:
        # a1からb1へ移動可能
        ans[a1][b1].min= w
        reacheable[a1].add b1
        rev_reacheable[b1].add a1
  #for a in N:
  #  for b in N:
  #    debug a, b, ans[a][b]
  for q in Q:
    if ans[s[q]][t[q]].isInf:
      echo -1
    else:
      echo ans[s[q]][t[q]] + 1
  echo "HelloWorld"
  discard

when not defined(DO_TEST):
  var N = nextInt()
  var M = nextInt()
  var a = newSeqWith(M, 0)
  var b = newSeqWith(M, 0)
  for i in 0..<M:
    a[i] = nextInt()
    b[i] = nextInt()
  var Q = nextInt()
  var s = newSeqWith(Q, 0)
  var t = newSeqWith(Q, 0)
  for i in 0..<Q:
    s[i] = nextInt()
    t[i] = nextInt()
  solve(N, M, a, b, Q, s, t)
else:
  discard

