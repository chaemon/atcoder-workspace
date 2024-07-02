when defined SecondCompile:
  const DO_CHECK = false;const DEBUG = false
else:
  const DO_CHECK = true;const DEBUG = true
const
  USE_DEFAULT_TABLE = true
  DO_TEST = false


include lib/header/chaemon_header

type T = tuple[C, V:int] # C: 色, V: 価値

solveProc solve(N:int, K:int, C:seq[int], V:seq[int]):
  var dp = Seq[K + 1: seq[T]]
  proc merge(a: var seq[T], t:T) =
    #debug "merge: ", a, t
    j := -1
    for i in a.len:
      if t.C == a[i].C:
        a[i].V.max=t.V
        j = i
        break
    if j == -1:
      j = a.len
      a.add t
    while j >= 1:
      if a[j - 1].V < a[j].V:
        swap a[j - 1], a[j]
      else: break
      j.dec
    if a.len > 2:
      a.setLen 2
    #debug "merge: ", a
  # dp[i]: ちょうどi個を取り除いた場合を価値順に並べたもの
  var dp_next = Seq[K + 1: seq[T]]
  for i in N:
    # 取り除く場合: dpから一個増えるだけ
    for k in K:
      dp_next[k + 1] = dp[k]
    # 取り除かない場合
    # ① 0 ..< iのi個を全部取り除く
    # i番を初めて取り除かない
    if i <= K:
      merge(dp_next[i], (C[i], V[i]))
    # ② i番を取り除かない場合
    for k in 0 .. K:
      # dp[k]のうちC[i]と同色でないものをとる
      Vmax := -int.inf
      for j in dp[k].len:
        if dp[k][j].C != C[i]:
          Vmax.max=dp[k][j].V + V[i]
          break
      if Vmax != -int.inf:
        merge(dp_next[k], (C[i], Vmax))
    swap dp, dp_next
    for i in dp_next.len:
      dp_next[i].setLen(0)
  if dp[K].len == 0:
    echo -1
  else:
    echo dp[K][0].V
  discard

when not defined(DO_TEST):
  var N = nextInt()
  var K = nextInt()
  var C = newSeqWith(N, 0)
  var V = newSeqWith(N, 0)
  for i in 0..<N:
    C[i] = nextInt()
    V[i] = nextInt()
  solve(N, K, C, V)
else:
  discard

